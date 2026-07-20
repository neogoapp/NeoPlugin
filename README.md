# NeoPlugin

Claude Plugin that connects Claude to Neo — your AI agent running outside the Matrix.

## What it does

NeoPlugin is the **way in** to NeoGo. It adds one MCP connector and one small skill
(`NeoSkill`), and it carries **Neo** — the assistant the user talks to.

Neo's job here is to get the user connected and keep them connected:

- **Not a NeoGo user yet?** Neo explains what it is in terms of what *they* do, and points
  them to sign up. Honestly — no invented capabilities, no manufactured urgency.
- **Already a user?** Neo is their point of contact: it does the work in the container and
  owns the problem when something is off (container not running, connection unauthorized,
  subscription lapsed, connector missing).

With NeoGo you:

- **Run multi-agent workflows** in natural language on **your own container** — on your
  machine, with **your own Anthropic account** (BYO). No central LLM proxy, no platform
  API keys.
- **Use NeoGo utilities on demand** (e.g. `html2pdf`) fetched from the server when needed.

Authentication is automatic via **OAuth 2.1 + PKCE** — no token configuration.

## How it works

The plugin is deliberately thin, and it holds **no domain knowledge**. The specialists, the
routing and the procedures are served by the NeoGo server and run in the container — new
behavior ships on the server, not in a plugin update.

The user reaches Neo in the **Code session** that connects to their container (Remote
Control). Invoked in any other channel, Neo redirects them there.

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

Tools available to the plugin:

| Tool | Description |
|------|-------------|
| `get_install_link` | Onboarding — the installer for the user's OS |
| `get_plugin_manifest` | Onboarding — what is available |
| `get_login_code` | The second factor of the login, delivered in Claude |

The IP tools (specialists, skills, flows) are **not** available here — they require the
proof that only the container has. There is **no task queue**: inside the container the user
commands Claude directly through Remote Control.

## Structure

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── .mcp.json               # MCP connectors: neogo (gateway) + connector pack (see Connectors)
├── skills/
│   └── NeoSkill/
│       └── SKILL.md        # Neo: connects, sells, supports, delegates
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

### v1.3.1
- **Correção:** o plugin descrevia um modelo de fila (`submit_task`/`task_status`) herdado da
  v2, que a **D5 revogou** — o usuário comanda o claude-code direto por Remote Control, sem
  round-trip via MCP. Removidas as tools de fila e o "delegue, não execute"; entra a regra de
  **redirecionamento** (D38): o Neo age na sessão Code que alcança o container, e redireciona
  quando invocado em qualquer outro canal.

### v1.2.1
- Renomeia a skill `neogoskill` → **`NeoSkill`** e o plugin `neo` → **`Neo`**, alinhando ao
  nome que a arquitetura já usava.

### v1.2.0
- **O plugin passa a carregar o Neo externo** — persona própria, sem IP. Antes ele buscava a
  persona do servidor via `get_playbook`; agora nasce sabendo quem é.
- **Papel explicitado:** Neo é a porta de entrada. Vende o NeoGo a quem ainda não é usuário
  e é o ponto de contato de quem já é (resolve conexão, conta e container).
- **Sem conhecimento de domínio no plugin.** Especialistas, roteamento e procedimentos são
  servidos pelo servidor e rodam no container. O plugin tem tom, não método.
- `get_playbook` sai das tools do plugin: o papel não é descoberto em runtime, é determinado
  por onde se está.

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
