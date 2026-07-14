import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function GET(request:Request){
  const url=new URL(request.url),code=url.searchParams.get("code"),next=url.searchParams.get("next")||"/app";
  if(code){const db=await createClient();await db.auth.exchangeCodeForSession(code)}
  return NextResponse.redirect(new URL(next,url.origin));
}
