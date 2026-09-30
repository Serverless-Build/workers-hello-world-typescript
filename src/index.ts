/** Minimal TypeScript Worker used to verify local and remote deployments. */

const MARKER = 'SERVERLESS_BUILD_HELLO_WORLD_TYPESCRIPT_V1';

export default {
  /** Return a deterministic response that identifies this runtime sample. */
  fetch(): Response {
    return new Response(`Hello from Cloudflare Workers!\nRuntime: TypeScript\n${MARKER}\n`, {
      headers: {
        'content-type': 'text/plain; charset=utf-8',
        'cache-control': 'no-store',
      },
    });
  },
} satisfies ExportedHandler;
