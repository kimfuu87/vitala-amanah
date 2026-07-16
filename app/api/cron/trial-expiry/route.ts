import { NextRequest,NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime="nodejs";
export async function GET(request:NextRequest){
  const expected=process.env.CRON_SECRET,provided=request.headers.get("authorization");
  if(!expected||provided!==`Bearer ${expected}`)return NextResponse.json({error:"Unauthorized"},{status:401});
  try{const {data,error}=await createAdminClient().rpc("process_founding_trial_expiry");if(error)throw error;return NextResponse.json(data)}
  catch(error){console.error("[trial-expiry] scheduled processing failed",error);return NextResponse.json({error:"Trial processing failed"},{status:500})}
}

