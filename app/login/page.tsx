"use client";

import Link from "next/link";
import { FormEvent, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function LoginPage(){
  const db=useMemo(()=>createClient(),[]),router=useRouter();
  const [mode,setMode]=useState<"signin"|"signup">("signin"),[busy,setBusy]=useState(false),[message,setMessage]=useState(""),[show,setShow]=useState(false);
  useEffect(()=>{db.auth.getUser().then(({data})=>{if(data.user)router.replace("/app")})},[db,router]);
  useEffect(()=>{if(new URLSearchParams(location.search).get("mode")==="signup")setMode("signup")},[]);

  async function submit(event:FormEvent<HTMLFormElement>){
    event.preventDefault();setBusy(true);setMessage("");
    const data=new FormData(event.currentTarget),email=String(data.get("email")||""),password=String(data.get("password")||"");
    if(mode==="signup"){
      const name=String(data.get("name")||""),confirm=String(data.get("confirm")||"");
      if(password!==confirm){setMessage("Passwords do not match.");setBusy(false);return}
      const {error}=await db.auth.signUp({email,password,options:{data:{full_name:name},emailRedirectTo:`${location.origin}/auth/callback?next=/onboarding`}});
      setMessage(error?.message||"Check your email to verify your new account.");
    }else{
      const {error}=await db.auth.signInWithPassword({email,password});
      if(error)setMessage("We could not sign you in. Check your details and try again.");else router.replace("/app");
    }
    setBusy(false);
  }

  async function demoLogin(){
    setBusy(true);setMessage("");
    const response=await fetch("/api/auth/demo",{method:"POST"});
    if(!response.ok){setMessage("The demo account is temporarily unavailable.");setBusy(false);return}
    router.replace(mode==="signup"?"/onboarding":"/app");
    router.refresh();
  }
  async function google(){await db.auth.signInWithOAuth({provider:"google",options:{redirectTo:`${location.origin}/auth/callback?next=/onboarding`}})}
  async function reset(){const email=prompt("Enter the email address for your account");if(!email)return;const {error}=await db.auth.resetPasswordForEmail(email,{redirectTo:`${location.origin}/auth/callback?next=/login`});setMessage(error?.message||"If an account exists, a recovery email has been sent.")}

  return <main className="auth-page">
    <section className="auth-brand"><Link href="/" className="auth-logo"><span>VA</span> Vitala Amanah</Link><div><span className="eyebrow light">YOUR LIFE, WEALTH AND LEGACY</span><h1>Clarity for you.<br/>Continuity for family.</h1><p>Keep the information that matters organised in one calm, practical family plan.</p><ul><li>Malaysian-first wealth records</li><li>Protection and legacy checklists</li><li>Safe, redacted emergency summaries</li></ul></div><small>Vitala Amanah is an organisational platform, not legal or financial advice.</small></section>
    <section className="auth-panel"><div className="auth-card"><Link href="/" className="back-link">← Continue to public demo</Link><span className="eyebrow">SECURE ACCOUNT ACCESS</span><h2>{mode==="signin"?"Welcome back":"Create your account"}</h2><p>{mode==="signin"?"Sign in to continue your family plan.":"Start with the free plan. Verify your email before sensitive actions."}</p>
      <div className="auth-tabs" role="tablist"><button className={mode==="signin"?"active":""} onClick={()=>{setMode("signin");setMessage("")}}>Sign in</button><button className={mode==="signup"?"active":""} onClick={()=>{setMode("signup");setMessage("")}}>Sign up</button></div>
      {mode==="signin"&&<><button className="demo-login" onClick={demoLogin} disabled={busy}><span>▶</span><span><b>Enter with demo account</b><small>No password needed · fictional data only</small></span></button><div className="or"><span>or choose another sign-in method</span></div></>}
      <button className="google" onClick={google}>G&nbsp;&nbsp; Continue with Google</button><div className="or"><span>or use email</span></div>
      <form onSubmit={submit}>{mode==="signup"&&<label>Full name<input name="name" autoComplete="name" required/></label>}<label>Email address<input key={mode} name="email" type="email" autoComplete="email" required/></label><label>Password<div className="password"><input name="password" type={show?"text":"password"} minLength={8} autoComplete={mode==="signin"?"current-password":"new-password"} required/><button type="button" onClick={()=>setShow(!show)}>{show?"Hide":"Show"}</button></div></label>{mode==="signup"&&<><small className="hint">Use at least 8 characters. A longer passphrase is easier to remember.</small><label>Confirm password<input name="confirm" type="password" minLength={8} autoComplete="new-password" required/></label><label className="consent"><input type="checkbox" required/> <span>I accept the Terms and Privacy Notice.</span></label></>}{mode==="signin"&&<button type="button" className="forgot" onClick={reset}>Forgot password?</button>}{message&&<div className="auth-message" role="status">{message}</div>}<button className="primary auth-submit" disabled={busy}>{busy?"Please wait…":mode==="signin"?"Sign in":"Create account"}</button></form>
      <p className="security-note">🔒 Authentication is handled by Supabase. Never share recovery codes or passwords.</p>
    </div></section>
  </main>
}
