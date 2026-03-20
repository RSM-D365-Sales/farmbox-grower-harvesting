/**
 * Minimal Deno type declarations for Supabase Edge Functions.
 * These allow VS Code's TypeScript language server to understand
 * Deno-specific APIs used in Edge Function code.
 *
 * When deployed, Supabase runs these functions on the Deno runtime
 * which provides these APIs natively.
 */

declare namespace Deno {
  interface Env {
    get(key: string): string | undefined
    set(key: string, value: string): void
    delete(key: string): void
    has(key: string): boolean
    toObject(): Record<string, string>
  }

  const env: Env

  function serve(
    handler: (request: Request) => Response | Promise<Response>
  ): void
  function serve(
    options: { port?: number; hostname?: string },
    handler: (request: Request) => Response | Promise<Response>
  ): void
}

// Allow importing from esm.sh and other HTTP URLs
declare module 'https://*' {
  const value: any
  export default value
  export const createClient: any
  export type SupabaseClient = any
}
