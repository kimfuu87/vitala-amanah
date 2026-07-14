import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function POST(request:Request){
  const origin=request.headers.get("origin");
  if(origin&&origin!==new URL(request.url).origin)return NextResponse.json({error:"Invalid origin"},{status:403});
  const email=process.env.DEMO_ACCOUNT_EMAIL,password=process.env.DEMO_ACCOUNT_PASSWORD;
  if(!email||!password)return NextResponse.json({error:"Demo account unavailable"},{status:503});
  const db=await createClient();
  const {error}=await db.auth.signInWithPassword({email,password});
  if(error)return NextResponse.json({error:"Demo account unavailable"},{status:503});
  return NextResponse.json({ok:true});
}
