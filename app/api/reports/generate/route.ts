import { PDFDocument, StandardFonts, rgb } from "pdf-lib";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

type ReportRequest = { reportType?: "family-pack" | "professional-review"; includedSections?: string[]; redacted?: boolean };
type Line = { heading?: boolean; text: string };
type Row = Record<string, unknown>;

const clean = (value: unknown) => String(value ?? "Not recorded").replace(/[^\x20-\x7E]/g, " ").replace(/\s+/g, " ").trim();
const money = (value: unknown) => `RM ${Number(value || 0).toLocaleString("en-MY", { maximumFractionDigits: 0 })}`;
const mask = (value: unknown) => { const s = clean(value); return s.length > 4 ? `${"*".repeat(Math.min(8, s.length - 4))}${s.slice(-4)}` : s; };

export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  const { data: { session } } = await supabase.auth.getSession();
  if (!user || !session) return Response.json({ error: "Sign in is required." }, { status: 401 });

  const payload = JSON.parse(Buffer.from(session.access_token.split(".")[1], "base64url").toString()) as { auth_time?: number; iat?: number };
  const authenticatedAt = payload.auth_time || payload.iat;
  if (!authenticatedAt || Date.now() / 1000 - authenticatedAt > 15 * 60) {
    return Response.json({ error: "For your protection, sign in again before generating a detailed report." }, { status: 401 });
  }

  const body = await request.json() as ReportRequest;
  const reportType = body.reportType === "professional-review" ? "professional-review" : "family-pack";
  const redacted = body.redacted !== false;
  const allowed = new Set(["owner", "family", "contacts", "protection", "assets", "liabilities", "legacy", "professionals", "documents", "instructions"]);
  const included = (body.includedSections || [...allowed]).filter(section => allowed.has(section));
  const tableNames = ["profiles", "family_packs", "contacts", "policies", "assets", "liabilities", "legacy_records", "professionals", "document_records"] as const;
  const results = await Promise.all(tableNames.map(table => supabase.from(table).select("*")));
  const failed = results.find(result => result.error);
  if (failed?.error) return Response.json({ error: "Report data could not be loaded." }, { status: 500 });
  const [profiles, packs, contacts, policies, assets, liabilities, legacy, professionals, documents] = results.map(result => result.data || []);
  const profile = profiles[0] as Record<string, unknown> | undefined;
  const pack = packs[0] as { sections?: Record<string, unknown>; last_reviewed_at?: string } | undefined;
  const reportId = `VA-${new Date().toISOString().slice(0,10).replace(/-/g,"")}-${crypto.randomUUID().slice(0,8).toUpperCase()}`;
  const lines: Line[] = [];
  const section = (title: string, values: string[]) => { lines.push({ heading: true, text: title }); values.filter(Boolean).forEach(text => lines.push({ text })); };
  if (included.includes("owner")) section("Owner information", [`Name: ${clean(profile?.full_name || user.user_metadata?.full_name || user.email)}`, `Account: ${clean(profile?.account_type || "individual")}`]);
  if (included.includes("family")) section("Spouse and dependants", [clean(pack?.sections?.spouse_dependants || "Not recorded")]);
  if (included.includes("contacts")) section("Emergency and trusted contacts", (contacts as Row[]).map(c => `${clean(c.name)} - ${clean(c.relationship)} - ${redacted ? mask(c.phone || c.email) : clean(c.phone || c.email)}`));
  if (included.includes("protection")) section("Insurance and takaful", (policies as Row[]).map(p => `${clean(p.provider)} - ${clean(p.policy_type)} - ${redacted ? mask(p.masked_number) : clean(p.masked_number)} - Coverage ${redacted ? "Withheld" : money(p.coverage)}`));
  if (included.includes("assets")) section("Asset summary", (assets as Row[]).map(a => `${clean(a.name)} - ${clean(a.category)} - ${redacted ? "Value withheld" : money(a.value)} - Ownership ${clean(a.ownership_percentage || 100)}%`));
  if (included.includes("liabilities")) section("Liabilities and commitments", (liabilities as Row[]).map(l => `${clean(l.name)} - ${redacted ? "Balance withheld" : money(l.balance)} - Monthly ${money(l.monthly_payment)}`));
  if (included.includes("legacy")) section("Legacy, nomination and hibah records", (legacy as Row[]).map(l => `${clean(l.title)} - ${clean(l.record_type)} - ${clean(l.status)}`));
  if (included.includes("professionals")) section("Professional contacts", (professionals as Row[]).filter(p => !p.is_directory_demo).map(p => `${clean(p.name)} - ${clean(p.category)} - ${redacted ? mask(p.telephone || p.email) : clean(p.telephone || p.email)}`));
  if (included.includes("documents")) section("Original document locations", (documents as Row[]).map(d => `${clean(d.name)} - ${clean(d.original_location)} - Expiry ${clean(d.expiry_date)}`));
  if (included.includes("instructions")) section("Owner instructions and immediate actions", [clean(pack?.sections?.personal_instructions || "Not recorded"), clean(pack?.sections?.immediate_action_checklist || "Not recorded")]);

  const pdf = await PDFDocument.create();
  const regular = await pdf.embedFont(StandardFonts.Helvetica);
  const bold = await pdf.embedFont(StandardFonts.HelveticaBold);
  const pageSize: [number, number] = [595.28, 841.89];
  let page = pdf.addPage(pageSize), y = 790, pageNumber = 1;
  const footer = () => { page.drawText(`Confidential | ${reportId} | Page ${pageNumber}`, { x: 42, y: 25, size: 8, font: regular, color: rgb(.35,.35,.35) }); };
  const addPage = () => { footer(); page = pdf.addPage(pageSize); pageNumber += 1; y = 790; };
  page.drawText("VITALA AMANAH", { x: 42, y, size: 11, font: bold, color: rgb(.02,.23,.25) }); y -= 30;
  page.drawText(reportType === "family-pack" ? "Safe Emergency Family Pack" : "Estate and Professional Review Pack", { x: 42, y, size: 22, font: bold, color: rgb(.03,.11,.22) }); y -= 22;
  page.drawText(`Generated ${new Date().toLocaleString("en-MY")} | ${redacted ? "Masked by default" : "Owner included detailed values"}`, { x: 42, y, size: 9, font: regular }); y -= 28;
  for (const line of lines) {
    if (y < 70) addPage();
    const font = line.heading ? bold : regular, size = line.heading ? 13 : 9;
    if (line.heading) y -= 8;
    const words = clean(line.text).split(" "); let row = "";
    for (const word of words) { const candidate = `${row} ${word}`.trim(); if (font.widthOfTextAtSize(candidate,size) > 505) { page.drawText(row,{x:42,y,size,font}); y -= size + 4; row = word; if(y<70)addPage(); } else row=candidate; }
    page.drawText(row || "Not recorded", { x: 42, y, size, font }); y -= size + (line.heading ? 8 : 5);
  }
  if (y < 110) addPage();
  y -= 12; page.drawText("Important disclaimer", { x:42,y,size:11,font:bold }); y -= 16;
  page.drawText("This report organises owner-recorded information. It is not legal, financial, tax, insurance or inheritance advice and does not claim legal validity.", { x:42,y,size:8,font:regular,maxWidth:505,lineHeight:11 });
  footer();
  await supabase.from("report_events").insert({ owner_id:user.id, family_pack_id:(packs[0] as Row | undefined)?.id || null, report_type:reportType, report_id:reportId, included_sections:included, redacted, status:"downloaded", expires_at:new Date(Date.now()+10*60*1000).toISOString() });
  await supabase.from("audit_events").insert({ owner_id:user.id, action:"report_downloaded", entity_type:"report", details:{report_id:reportId,report_type:reportType,redacted} });
  const bytes = await pdf.save();
  return new Response(Buffer.from(bytes), { headers:{ "Content-Type":"application/pdf", "Content-Disposition":`attachment; filename="${reportType}-${reportId}.pdf"`, "Cache-Control":"private, no-store, max-age=0" } });
}
