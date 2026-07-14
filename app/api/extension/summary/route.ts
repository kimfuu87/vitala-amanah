import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

const headers={"Access-Control-Allow-Origin":"*","Access-Control-Allow-Methods":"GET, OPTIONS","Access-Control-Allow-Headers":"Content-Type"};
export function OPTIONS(){return new NextResponse(null,{status:204,headers})}
export async function GET(){
  const db=await createClient();
  const [assets,liabilities,policies,contacts,reminders]=await Promise.all([
    db.from("assets").select("value"),db.from("liabilities").select("balance"),db.from("policies").select("coverage"),db.from("contacts").select("emergency_access"),db.from("reminders").select("completed")
  ]);
  if([assets,liabilities,policies,contacts,reminders].some(x=>x.error))return NextResponse.json({error:"Summary unavailable"},{status:503,headers});
  const assetTotal=(assets.data||[]).reduce((sum,row)=>sum+Number(row.value),0),debtTotal=(liabilities.data||[]).reduce((sum,row)=>sum+Number(row.balance),0);
  const score=Math.min(100,25+(assets.data?.length?15:0)+(policies.data?.length?15:0)+(contacts.data?.some(x=>x.emergency_access)?20:0)+10);
  return NextResponse.json({netWorth:assetTotal-debtTotal,assets:assets.data?.length||0,policies:policies.data?.length||0,actions:reminders.data?.filter(x=>!x.completed).length||0,readiness:score,mode:"public-demo"},{headers});
}
