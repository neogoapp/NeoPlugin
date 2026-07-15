---
name: neogoskill
description: Your gateway to NeoGo — run multi-agent workflows on your own worker (BYO Anthropic account) via natural language. Use whenever the user wants to run a NeoGo agent/skill, delegate a task, check a delegated task, install/connect their worker, or use a NeoGo utility (e.g. HTML→PDF). This skill is thin: it fetches how to operate from the server at runtime.
---

# NeoGo

NeoGo runs multi-agent workflows on **your own worker** — a container on your machine running a second Claude (**claude-neogo**) logged in with **your own Anthropic account** (BYO). No central LLM proxy, no platform API keys.

This skill is intentionally **thin**. The actual behavior — how to delegate (host) or how to execute (worker), the available agents/skills, and the utility skills — lives on the NeoGo server and is fetched on demand. That keeps the plugin tiny and always current.

> **The server tells you your role.** The same plugin runs on the host (**claude-cliente** — you *delegate*) and inside the worker container (**claude-neogo** — you *execute*). You don't need to guess which you are: `get_playbook` returns the right protocol for your token automatically.

## How to operate

**Step 1 — Always start here.** Call the `get_playbook` MCP tool. The server returns your playbook:

- **Control plane** (host / claude-cliente): how to discover agents/skills and **delegate** tasks to your worker, then track them. You do *not* execute.
- **Execution plane** (worker / claude-neogo): how to **pull** delegated tasks, run them with your connectors, and report results.

The control-plane playbook also defines **who you are**: it opens with the Neo persona (identity + soul). Don't just call its tools — **embody Neo**: triage requests, delegate to your worker, and speak as Neo while you operate. Then follow the playbook — it lists exactly which tools to call and how.

**Step 2 — Utility skills on demand.** When a task needs a NeoGo utility (e.g. `html2pdf` to render a PDF, `neoproxy` to route to another LLM), call `get_skill(name: "…")` — it returns the skill's instructions plus any bundled scripts. Call `get_skill` with no name to list what's available.

## Not connected yet? (subscription required)

NeoGo needs a **neogo.app account with an active subscription**. Authentication is automatic via OAuth 2.1 — no token to configure.

- If `get_playbook` (or any NeoGo tool) reports you're unauthenticated or unauthorized, the MCP connection needs authorizing: complete the OAuth prompt, or sign up / subscribe at **https://neogo.app**.
- Once subscribed and authorized, `get_playbook` works and guides you the rest of the way — including installing your worker if you don't have one yet.

## Why so little here

Everything else — the delegation and execution protocols, agent/skill definitions, and utility skills — is served by the NeoGo MCP server (`get_playbook`, `get_skill`, and the tools they reference). This skill is just the entry point that connects you and routes you to the right behavior for your role.
