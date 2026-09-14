/** Minimal Redis Cluster key helpers. Same names and key shapes as upstream
 * PR #17 (LibreChat-AI/code-interpreter, "Add Redis Cluster Support") so this
 * file can be dropped when that lands. ElastiCache Serverless is always
 * cluster mode: every multi-key script, MULTI/EXEC or MGET must stay in one
 * hash slot.
 *
 * ponytail: covers what the api, worker and file-server use (session
 * registry, replay state, BullMQ). bridge/*, egress-ledger and
 * tool-call-server still do cross-slot work; tag them before running those
 * components against a cluster. */

export function isClusterMode(): boolean {
  return process.env.USE_REDIS_CLUSTER === 'true' || (process.env.REDIS_HOST ?? '').includes(',');
}

/** One hash tag keeps every BullMQ key in one slot on a cluster. Standalone
 * keeps BullMQ's default so existing queues are untouched. */
export function bullmqPrefix(): string {
  return isClusterMode() ? '{codeapi}' : 'bull';
}

/** Wrap an id in a hash tag so every key built from it lands in one slot.
 * Redis Cluster hashes only the substring between the first `{` and `}`. */
export function hashTag(id: string): string {
  return `{${id}}`;
}

/** Reverse of `hashTag`. */
export function stripHashTag(raw: string): string {
  return raw.startsWith('{') && raw.endsWith('}') ? raw.slice(1, -1) : raw;
}
