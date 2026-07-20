# NeoPlugin

Claude Plugin that connects Claude to Neo — your AI agent running outside the Matrix.

## What it does

NeoPlugin is a **thin gateway**. It adds one MCP connector and one small skill (`NeoSkill`). Everything else — how to delegate work, how the worker executes it, the available agents/flows, and the utility skills — is served **on demand** by the NeoGo MCP server. This keeps the plugin tiny and always current: new behavior ships on the server, not in a plugin update.

With NeoGo you:

- **Delegate multi-agent workflows** in natural language to **your own worker** — a container on your machine running a second Claude (**claude-neogo**) logged in with **your own Anthropic account** (BYO). No central LLM proxy, no platform API keys.
- **Use NeoGo utilities on demand** (e.g. `html2pdf`, `neoproxy`) fetched from the server when needed.

Authentication is automatic via **OAuth 2.1 + PKCE** — no token configuration.

## How it works

The same plugin runs in two roles, and the server tells you which you are (by your token):

- **Host / claude-cliente (control plane)** — you *delegate* tasks to your worker and track them.
- **Worker / claude-neogo (execution plane)** — you *pull* delegated tasks, run them with your connectors, and report back.

The `NeoSkill` skill is the entry point. On any NeoGo request it calls **`get_playbook`**, which returns the right protocol for your role; utility skills come from **`get_skill`**.

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
├── .mcp.json               # MCP connectors: neogo (gateway) + connector pack (see Connectors)
├── skills/
│   └── NeoSkill/
│       └── SKILL.md        # Thin entry point: routes to get_playbook / get_skill
├── scripts/
│   └── commit.sh           # Versioned commit helper
├── LICENSE
└── VERSION                 # Current plugin version
```

## Connectors

The plugin bundles a **connector pack** in `.mcp.json`: the NeoGo gateway plus
curated third-party MCP servers that cover the use cases (marketing, social,
sites, content, finance, e-commerce). Connectors are **declarations only** (not
IP), so they live in the plugin.

| Connector | Endpoint | Serves |
|-----------|----------|--------|
| `neogo` | `mcp.neogo.app` | **Gateway (required)** — agents, playbooks, skills. Authorize first. |
| `composio` | `connect.composio.dev/mcp` | Hub (Google Ads, Google Workspace, automation…) |
| `kairogen` | `mcp.kairogen.ai/mcp` | Media generation (image/video/audio) |
| `higgsfield` | `mcp.higgsfield.ai/mcp` | Media + site build/deploy |
| `facebook-ads` | `mcp.facebook.com/ads` | Meta Ads |
| `metricool` | `ai.metricool.com/mcp` | Social scheduling + analytics |
| `wix` | `mcp.wix.com/mcp` | Sites + eCommerce |
| `okx` | `web3.okx.com/api/v1/onchainos-mcp` | Crypto trading |
| `alpaca` | `alpaca.markets/mcp-server` | Stocks/ETF/options trading |

**Auth is lazy.** When the plugin is enabled, the connectors are registered but
**none logs you in automatically** — each remote server is marked *needs
authentication* until you authorize it in `/mcp`. Authorize `neogo` first (it's
the gateway); authorize the others only when you want to use them. Nothing
bombards you with logins on install.

> Third-party connectors are curated defaults; connecting each one uses **your
> own account** (BYO). You can also add your own connectors alongside these.

## Development

```bash
./scripts/commit.sh feat  "add new capability"
./scripts/commit.sh major "breaking restructure"
./scripts/commit.sh docs  "update readme"
```

## Changelog

> Mantido manualmente — o `commit.sh` versiona `VERSION` e `plugin.json`, mas não edita esta seção.

### v1.1.0
- **Connector pack** no `.mcp.json`: além do `neogo` (gateway), 8 conectores de
  terceiros — `composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`,
  `wix`, `okx`, `alpaca` — cobrindo os casos de uso. Todos remotos (`type: url`).
- **Lazy-auth:** conectores são registrados mas nenhum autentica sozinho (ficam
  *needs auth* até o usuário autorizar em `/mcp`); `neogo` é o primeiro a autorizar.
  Conectores são declaração (não-IP), por isso cabem no plugin. Ver seção *Connectors*.

### v1.0.3
- `SKILL.md` alinhado ao modelo **flows são skills**: "agent/flow" → "agent/skill"
  (um procedimento multi-step é uma skill servida por `get_skill`, sem motor de workflow).

### v1.0.2
- `SKILL.md`: o host **encarna** a persona Neo servida pelo playbook (`get_playbook`),
  não apenas chama tools — alinha ao Épico 3 (persona Neo no host).

### v1.0.1
- README: adiciona `LICENSE` ao diagrama de estrutura + nota de que o changelog é
  mantido manualmente (o `commit.sh` não edita esta seção).

### v1.0.0
- Initial release. Thin gateway: a single `NeoSkill` entry point plus the MCP
  connector (OAuth 2.1 + PKCE) to `mcp.neogo.app`.
- The operating protocol and utilities are served on demand by the server
  (`get_playbook`, `get_skill`) — the plugin stays tiny and always current.
