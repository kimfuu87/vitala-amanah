"use client";
import { useEffect, useMemo, useState } from "react";

export type FamilyPackRecord={id?:string;sections:Record<string,string>;completed_sections:string[];updated_at?:string;last_reviewed_at?:string|null;last_pdf_generated_at?:string|null};
const steps=[
  ["owner","Owner information","Name, identity summary and preferred contact"],
  ["dependants","Spouse and dependants","Who relies on you and their practical needs"],
  ["emergency","Emergency contacts","Who should be contacted first"],
  ["trusted","Trusted contacts","People authorised to receive the redacted pack"],
  ["protection","Insurance / takaful summary","Policies, covered people and renewal facts"],
  ["claims","Claims contacts","Hotlines, email and responsible family member"],
  ["assets","Redacted asset summary","Categories and locations—not complete identifiers"],
  ["commitments","Liabilities and commitments","Important loans and recurring commitments"],
  ["employer","Employer and HR","Workplace contact and benefit enquiries"],
  ["medical","Owner-entered medical information","Only information you choose to record"],
  ["professionals","Professionals","Lawyer, planner, trustee, tax or other contacts"],
  ["documents","Original document locations","Where originals can be found; no uploads"],
  ["instructions","Personal instructions","Calm, practical guidance for your family"],
  ["actions","Immediate action checklist","First calls, urgent commitments and responsibilities"],
  ["review","Final review","Confirm accuracy and exclusions"],
  ["recipient","Recipient view","What trusted contacts will actually see"],
  ["pdf","Generate PDF","Create a redacted temporary report"],
  ["sharing","Secure sharing controls","Choose recipient and revoke access"],
] as const;

export function FamilyPack({record,save,preview}:{record:FamilyPackRecord|null;save:(record:FamilyPackRecord)=>Promise<void>;preview:()=>void}){
  const [draft,setDraft]=useState<FamilyPackRecord>(record||{sections:{},completed_sections:[]}),[active,setActive]=useState(0),[saved,setSaved]=useState("");
  useEffect(()=>{if(record)setDraft(record)},[record]);
  const completed=useMemo(()=>steps.filter(([key])=>draft.sections[key]?.trim()).map(([key])=>key),[draft.sections]);
  const progress=Math.round(completed.length/steps.length*100),step=steps[active];
  async function persist(){const next={...draft,completed_sections:completed};await save(next);setDraft(next);setSaved(new Date().toLocaleTimeString("en-MY",{hour:"2-digit",minute:"2-digit"}))}
  function next(){if(active<steps.length-1)setActive(active+1)}
  return <><div className="title-row"><div><span className="eyebrow">FAMILY PACK</span><h1>One practical pack for your family</h1><p>Build a redacted guide containing only the contacts, responsibilities and instructions you choose.</p></div><button className="secondary" onClick={persist}>Save and continue later</button></div>
    <section className="hero-card family-hook"><div><span className="eyebrow light">FAMILY CONTINUITY</span><h2>If something happened to you today, would your family know what to do?</h2><p>Prepare one secure, practical family pack containing the contacts, protection information, responsibilities and instructions your family may need.</p><div className="pack-actions"><button className="champagne" onClick={()=>setActive(Math.min(completed.length,steps.length-1))}>Prepare My Family Pack</button><button className="secondary" onClick={preview}>Preview What Family Will See</button></div></div><div className="score-ring" style={{"--score":`${progress*3.6}deg`} as React.CSSProperties}><span><b>{progress}%</b><small>Complete</small></span></div></section>
    <div className="pack-builder"><aside className="panel pack-steps" aria-label="Family Pack sections">{steps.map(([key,label],index)=><button key={key} className={active===index?"active":""} onClick={()=>setActive(index)}><span>{draft.sections[key]?.trim()?"✓":index+1}</span>{label}</button>)}</aside>
      <section className="panel pack-editor"><div className="panel-head"><div><span className="eyebrow">STEP {active+1} OF {steps.length}</span><h2>{step[1]}</h2></div><span className="pill">{progress}% complete</span></div><p>{step[2]}</p>{active<14?<label>Information for this section<textarea value={draft.sections[step[0]]||""} onChange={e=>setDraft({...draft,sections:{...draft.sections,[step[0]]:e.target.value}})} placeholder="Enter only practical information your family may need. Never enter passwords, PINs or complete account numbers." rows={9}/></label>:<ReviewStep draft={draft} active={active} preview={preview}/>}<div className="modal-actions"><small>{saved&&`Saved at ${saved}`}</small><button className="secondary" disabled={active===0} onClick={()=>setActive(active-1)}>Back</button><button className="primary" onClick={async()=>{await persist();next()}}>{active===steps.length-1?"Save controls":"Save and continue"}</button></div></section></div>
    <p className="disclaimer">This pack organises owner-entered information. It does not prove legal validity, entitlement, claim eligibility or beneficial ownership. Passwords, PINs, complete account numbers and Secure Vault secrets are always excluded.</p></>
}
function ReviewStep({draft,active,preview}:{draft:FamilyPackRecord;active:number;preview:()=>void}){if(active===15)return <div className="pack-preview"><h3>Safe recipient preview</h3>{Object.entries(draft.sections).filter(([,v])=>v.trim()).map(([k,v])=><article key={k}><b>{steps.find(s=>s[0]===k)?.[1]}</b><p>{v}</p></article>)}<button className="secondary" onClick={preview}>Open print preview</button></div>;if(active===16)return <div className="empty"><b>Protected PDF report</b><span>Server-generated, short-lived PDF delivery is the next security-reviewed sprint. Browser printing remains available for the fictional demo only.</span><button className="secondary" onClick={preview}>Print redacted demo</button></div>;if(active===17)return <div className="empty"><b>Secure sharing remains gated</b><span>Sharing will activate only after expiring grants, recipient verification, revocation and audit tests pass.</span></div>;return <div className="pack-preview"><h3>Review completed sections</h3><p>{Object.values(draft.sections).filter(v=>v.trim()).length} sections currently contain information. Confirm it is current and contains no secrets.</p></div>}
