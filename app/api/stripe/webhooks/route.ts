import { constructWebhookEvent } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { NextResponse } from "next/server";
import type Stripe from "stripe";

/**
 * POST /api/stripe/webhooks
 *
 * Receives and processes Stripe webhook events.
 * Register this URL in your Stripe dashboard:
 *   https://dashboard.stripe.com/webhooks → add endpoint → /api/stripe/webhooks
 *
 * Required events to enable in Stripe dashboard:
 *   - checkout.session.completed
 *   - customer.subscription.updated
 *   - customer.subscription.deleted
 *   - invoice.payment_failed
 */
export async function POST(request: Request) {
  const payload = await request.text();
  const signature = request.headers.get("stripe-signature");

  if (!signature) {
    return NextResponse.json({ error: "Missing stripe-signature" }, { status: 400 });
  }

  let event: Stripe.Event;
  try {
    event = constructWebhookEvent(payload, signature);
  } catch (err) {
    console.error("[stripe/webhooks] signature verification failed:", err);
    return NextResponse.json({ error: "Invalid signature" }, { status: 400 });
  }

  const supabase = createAdminClient();

  try {
    switch (event.type) {
      // ── New subscription or one-time purchase ─────────────────────────────
      case "checkout.session.completed": {
        const session = event.data.object as Stripe.Checkout.Session;
        const userId = session.metadata?.userId;
        if (!userId) break;

        // Store Stripe customer ID on profile for future portal/checkout calls
        if (session.customer) {
          await supabase
            .from("profiles")
            .update({ stripe_customer_id: session.customer as string })
            .eq("id", userId);
        }

        // If subscription, the subscription.updated event will handle status
        if (session.mode === "payment") {
          await supabase.from("purchases").upsert({
            owner_id: userId,
            provider: "stripe",
            external_reference: session.id,
            amount_sen: session.amount_total,
            status: "paid",
          },{onConflict:"provider,external_reference"});
        }
        break;
      }

      // ── Subscription created or updated ───────────────────────────────────
      case "customer.subscription.updated":
      case "customer.subscription.created": {
        const sub = event.data.object as Stripe.Subscription;
        const userId = sub.metadata?.userId;
        if (!userId) break;

        await supabase.from("subscriptions").upsert({
          id: sub.id,
          owner_id: userId,
          stripe_customer_id: sub.customer as string,
          status: sub.status,
          price_id: sub.items.data[0]?.price.id,
          current_period_end: new Date(sub.current_period_end * 1000).toISOString(),
          cancel_at_period_end: sub.cancel_at_period_end,
          updated_at: new Date().toISOString(),
        });
        const plan=sub.metadata?.plan==="family"?"family":"pro";
        await supabase.from("profiles").update({plan:sub.status==="active"?plan:"free",renewal_date:new Date(sub.current_period_end*1000).toISOString().slice(0,10),grace_period_ends_at:null}).eq("id",userId);
        break;
      }

      // ── Subscription cancelled ────────────────────────────────────────────
      case "customer.subscription.deleted": {
        const sub = event.data.object as Stripe.Subscription;
        await supabase
          .from("subscriptions")
          .update({ status: "canceled", updated_at: new Date().toISOString() })
          .eq("id", sub.id);
        await supabase.from("profiles").update({grace_period_ends_at:new Date(Date.now()+30*86400000).toISOString()}).eq("stripe_customer_id",sub.customer as string);
        break;
      }

      // ── Payment failed — notify user ──────────────────────────────────────
      case "invoice.payment_failed": {
        const invoice = event.data.object as Stripe.Invoice;
        const customer=invoice.customer as string;
        const {data:profile}=await supabase.from("profiles").select("id").eq("stripe_customer_id",customer).maybeSingle();
        if(profile?.id){await supabase.from("payment_records").upsert({owner_id:profile.id,provider:"stripe",external_reference:invoice.id,amount_sen:invoice.amount_due||0,status:"failed"},{onConflict:"provider,external_reference"});await supabase.from("profiles").update({grace_period_ends_at:new Date(Date.now()+30*86400000).toISOString()}).eq("id",profile.id)}
        break;
      }

      default:
        // Unhandled event — safe to ignore
        break;
    }
  } catch (err) {
    console.error(`[stripe/webhooks] error handling ${event.type}:`, err);
    // Return 200 anyway — Stripe will retry on 5xx, not on handler errors
  }

  return NextResponse.json({ received: true });
}
