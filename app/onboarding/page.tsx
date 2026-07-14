"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import "../public.css";

export default function Onboarding(){
  const db=useMemo(()=>createClient(),[]),router=useRouter();
  const [accountType,setAccountType]=useState("individual"),[goal,setGoal]=useState("organise_assets"),[name,setName]=useState(""),[error,setError]=useState("");
  useEffect(()=>{db.auth.getUser().then(async({data})=>{if(!data.user)return;const {data:p}=await db.from("profiles").select("onboarding_complete").eq("id",data.user.id).maybeSingle();if(p?.onboarding_complete)router.replace("/app")})},[db,router]);
  async function submit(e:FormEvent){e.preventDefault();setError("");const {data:{user}}=await db.auth.getUser();if(!user)return router.replace("/login");
    const {error:profileError}=await db.from("profiles").upsert({id:user.id,full_name:name,account_type:accountType,primary_goal:goal,plan:"free",onboarding_complete:true});
    if(profileError){setError(profileError.message);return}
    await db.from("retirement_profiles").insert({owner_id:user.id,is_demo:false,current_age:35,retirement_age:60,monthly_spending:5000,current_savings:0,monthly_contribution:0,annual_return:5,inflation:3});router.replace("/app");
  }
  return <main className="public-page"><section className="pricing public-section onboarding"><span className="eyebrow">WELCOME</span><h1>Set up your private organiser</h1><p>Choose the workspace that fits your household. You can change this later.</p><form className="price-card featured" onSubmit={submit}><label>Preferred name<input value={name} onChange={e=>setName(e.target.value)} required/></label><fieldset><legend>Account type</legend><label><input type="radio" checked={accountType==="individual"} onChange={()=>setAccountType("individual")}/> Individual</label><label><input type="radio" checked={accountType==="family"} onChange={()=>setAccountType("family")}/> Family</label></fieldset><label>First goal<select value={goal} onChange={e=>setGoal(e.target.value)}><option value="organise_assets">Organise assets and debts</option><option value="family_continuity">Prepare my family</option><option value="retirement">Plan retirement</option></select></label>{error&&<p className="form-error">{error}</p>}<button className="public-primary" type="submit">Create my workspace</button><small>Your records are separated from every other user. Sensitive document uploads remain disabled pending encryption review.</small></form></section></main>
}
