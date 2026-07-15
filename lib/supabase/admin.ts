import { createClient } from "@supabase/supabase-js";

export function createAdminClient(){
  const url=process.env.NEXT_PUBLIC_SUPABASE_URL,serviceKey=process.env.SUPABASE_SERVICE_ROLE_KEY;
  if(!url||!serviceKey) throw new Error("Server billing credentials are not configured.");
  return createClient(url,serviceKey,{auth:{persistSession:false,autoRefreshToken:false}});
}
