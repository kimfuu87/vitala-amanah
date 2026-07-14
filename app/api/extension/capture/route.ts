import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

const headers={"Access-Control-Allow-Origin":"*","Access-Control-Allow-Methods":"POST, OPTIONS","Access-Control-Allow-Headers":"Content-Type"};
export function OPTIONS(){return new NextResponse(null,{status:204,headers})}
export async function POST(request:Request){
  let body:unknown;try{body=await request.json()}catch{return NextResponse.json({error:"Invalid request"},{status:400,headers})}
  const value=body as {name?:unknown;category?:unknown;value?:unknown;institution?:unknown};
  const name=String(value.name||"").trim(),category=String(value.category||"Other").trim(),amount=Number(value.value);
  if(name.length<2||name.length>120||!Number.isFinite(amount)||amount<0||amount>999999999999)return NextResponse.json({error:"Check the name and value"},{status:400,headers});
  const db=await createClient();const {data,error}=await db.from("assets").insert({name,category:category.slice(0,60),value:amount,institution:String(value.institution||"Chrome companion").slice(0,120),liquidity:"Liquid",notes:"Added from the Vitala Amanah Chrome companion."}).select("id").single();
  if(error)return NextResponse.json({error:"Could not save this record"},{status:500,headers});
  await db.from("audit_events").insert({action:"extension_capture",entity_type:"assets",entity_id:data.id,details:{source:"chrome_companion"}});
  return NextResponse.json({ok:true,id:data.id},{status:201,headers});
}
