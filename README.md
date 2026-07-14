# NeoPlugin

Claude Plugin that connects Claude to Neo — your AI agent running outside the Matrix.

## What it does

NeoPlugin is a **thin gateway**. It adds one MCP connector and one small skill (`neogoskill`). Everything else — how to delegate work, how the worker executes it, the available agents/flows, and the utility skills — is served **on demand** by the NeoGo MCP server. This keeps the plugin tiny and always current: new behavior ships on the server, not in a plugin update.

With NeoGo you:

- **Delegate multi-agent workflows** in natural language to **your own worker** — a container on your machine running a second Claude (**claude-neogo**) logged in with **your own Anthropic account** (BYO). No central LLM proxy, no platform API keys.
- **Use NeoGo utilities on demand** (e.g. `html2pdf`, `neoproxy`) fetched from the server when needed.

Authentication is automatic via **OAuth 2.1 + PKCE** — no token configuration.

## How it works

The same plugin runs in two roles, and the server tells you which you are (by your token):

- **Host / claude-cliente (control plane)** — you *delegate* tasks to your worker and track them.
- **Worker / claude-neogo (execution plane)** — you *pull* delegated tasks, run them with your connectors, and report back.

The `neogoskill` skill is the entry point. On any NeoGo request it calls **`get_playbook`**, which returns the right protocol for your role; utility skills come from **`get_skill`**.

## Installation

### From Claude.ai

1. Download `neogo-plugin.zip` from your [NeoGo dashboard](https://neogo.app/dashboard)
2. Open Claude → **Customize → Plugins → Add → Upload plugin**
3. Select the ZIP file
4. On your first Neo conversation, Claude will prompt you to authorize the connection via neogo.app
5. Authorize → connection established

### Manual (Claude Code)

```bash
git clone https://github.com/neogoapp/NeoPlugin ~/.claude/plugins/neo
```

On first use, Claude opens the OAuth flow automatically.

> **Subscription required.** A neogo.app account with an active subscription. If a NeoGo tool reports you're unauthorized, complete the OAuth prompt or subscribe at https://neogo.app.

## MCP Connector

The connector at `mcp.neogo.app` uses OAuth 2.1 + PKCE. Claude handles the auth flow transparently — no manual token setup.

Core tools (the playbook references the rest):

| Tool | Description |
|------|-------------|
| `get_playbook` | Get your role's operating protocol (control or execution). Call this first. |
| `get_skill` | Fetch a utility skill on demand (instructions + bundled files). Omit name to list. |

## Structure

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest (v1.0.0)
├── .mcp.json               # MCP connector → mcp.neogo.app (OAuth 2.1) — host
├── skills/
│   └── neogoskill/
│       └── SKILL.md        # Thin entry point: routes to get_playbook / get_skill
├── scripts/
│   └── commit.sh           # Versioned commit helper
├── LICENSE
└── VERSION                 # Current plugin version
```

## Development

```bash
./scripts/commit.sh feat  "add new capability"
./scripts/commit.sh major "breaking restructure"
./scripts/commit.sh docs  "update readme"
```

## Changelog

> Mantido manualmente — o `commit.sh` versiona `VERSION` e `plugin.json`, mas não edita esta seção.

### v1.0.0
- Initial release. Thin gateway: a single `neogoskill` entry point plus the MCP
  connector (OAuth 2.1 + PKCE) to `mcp.neogo.app`.
- The operating protocol and utilities are served on demand by the server
  (`get_playbook`, `get_skill`) — the plugin stays tiny and always current.
