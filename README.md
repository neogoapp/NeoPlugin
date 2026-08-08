# NeoPlugin

Claude Plugin that connects Claude to Neo — your AI agent running outside the Matrix.

## What it does

NeoPlugin is the **way in** to NeoGo, for the **Claude app and claude.ai**. It carries two
things and nothing else:

- the **`neo` skill** — the assistant the user talks to;
- the **`neogo` MCP connector** (`mcp.neogo.app`), over OAuth 2.1 + PKCE.

Neo's job here is to get the user connected and keep them connected:

- **Not a NeoGo user yet?** Neo explains what it is in terms of what *they* do, and points
  them to sign up. Honestly — no invented capabilities, no manufactured urgency.
- **Already a user?** Neo is their point of contact: it owns the problem when something is
  off (installation not running, connection unauthorized, subscription lapsed).

With NeoGo you:

- **Run multi-agent workflows** in natural language on **your own container** — on your
  machine, with **your own Anthropic account** (BYO). No central LLM proxy, no platform
  API keys.
- (detalhes de funcionamento interno removidos)

Authentication is automatic via **OAuth 2.1 + PKCE** — no token configuration.

## Where the work happens

This plugin is the **door, not the workshop**.

The actual work — campaigns, research, publishing, files — happens in the user's own
container, through the **terminal in the dashboard** (*Access your Neo*). That Neo has the
the user's connectors and the user's files are. Neo here recognizes
that request and takes the user there, instead of delivering a lesser version of it.

The container installs **nothing from this plugin**: its connectors come from the NeoGo
server, already resolved for the environment it runs in.

## Installation

NeoPlugin is a **public plugin**. Get `neoplugin.zip` from any of these — they all point to
the same file:

- the **onboarding** link (shown when you sign in at neogo.app without the plugin yet),
- your [**NeoGo dashboard**](https://neogo.app/dashboard),
- this repo's [**Releases**](https://github.com/neogoapp/NeoPlugin/releases/latest)
  (`neoplugin.zip`).

1. Download `neoplugin.zip` from any source above
2. Open Claude → **Customize → Plugins → Add → Upload plugin**
3. Select the ZIP file
4. On your first Neo conversation, Claude will prompt you to authorize the connection via
   neogo.app
5. Authorize → connection established

> **Subscription required.** A neogo.app account with an active subscription. If a NeoGo
> tool reports you're unauthorized, complete the OAuth prompt or subscribe at
> https://neogo.app.

## MCP Connector

The connector at `mcp.neogo.app` uses OAuth 2.1 + PKCE. Claude handles the auth flow
transparently — no manual token setup.

Tools available here:

| Tool | Description |
|------|-------------|
| `get_install_link` | Onboarding — the installer for the user's OS |
| `get_plugin_manifest` | Onboarding — what is available |
| `get_login_code` | The second factor of the login, delivered in Claude |

These are the tools of the door: connect, subscribe, sign in, install.
NeoGo runs on the user's own machine, with their own Anthropic account (BYO).
commands their Neo directly, through the terminal in the dashboard.

## Structure

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── .mcp.json               # One connector: neogo (mcp.neogo.app)
├── skills/
│   └── neo/
│       └── SKILL.md        # Neo: connects, sells, supports, delegates
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

### v1.12.0
- **O plugin é do claude.ai — app e web.** É lá que ele serve: a porta de entrada do NeoGo,
  onde o usuário conhece, assina e cuida da conta. O trabalho fica no container, alcançado
  pelo terminal do dashboard.
- **Fica só o essencial: a skill `neo` e o conector `neogo`.** O *connector pack* de
  terceiros (`composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`,
  `okx`, `alpaca`) **sai** do `.mcp.json` — esses conectores são do ambiente de trabalho, e
  o container os recebe da lista global do servidor, já com o endereço do ambiente dele.
  Mantê-los aqui duplicava a mesma declaração em dois lugares que se atualizam por
  caminhos diferentes.
- **README e skill sem o mundo antigo:** sai a instalação por `git clone` no Claude Code e a
  menção ao Remote Control (o acesso ao container é o terminal do dashboard).

### v1.4.1
- **Identificadores em minúsculas, por spec.** O `name` do `plugin.json` exige **kebab-case**
  e o `name` da skill exige **apenas minúsculas, números e hífens** (docs oficiais de plugins
  e de Agent Skills). Os valores viraram: plugin `neoplugin` · pasta da skill `neo` ·
  `name` da skill `neo`. O usuário continua vendo "Neo" — isso vem da persona no `SKILL.md`,
  não do identificador.

### v1.3.1
- (detalhes de funcionamento interno removidos)
  v2, que a **D5 revogou** — o usuário comanda o claude-code direto por Remote Control, sem
  round-trip via MCP. Removidas as tools de fila e o "delegue, não execute"; entra a regra de
  **redirecionamento** (D38): o Neo age na sessão Code que alcança o container, e redireciona
  quando invocado em qualquer outro canal.

### v1.2.1
- Renomeia a skill `neogoskill` → **`neo`**, alinhando ao nome que a arquitetura já usava.

### v1.2.0
- **O plugin passa a carregar o Neo externo** — persona própria, sem IP. Antes ele buscava a
  NeoGo runs on the user's own machine, with their own Anthropic account (BYO).
- **Papel explicitado:** Neo é a porta de entrada. Vende o NeoGo a quem ainda não é usuário
  e é o ponto de contato de quem já é (resolve conexão, conta e container).
- **Sem conhecimento de domínio no plugin.** O que o NeoGo sabe fazer não mora aqui.
  servidos pelo servidor e rodam no container. O plugin tem tom, não método.
- (detalhes de funcionamento interno removidos)
  por onde se está.

### v1.1.0
- **Connector pack** no `.mcp.json`: além do `neogo` (gateway), 8 conectores de
  terceiros — `composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`,
  `wix`, `okx`, `alpaca` — cobrindo os casos de uso. Todos remotos (`type: url`).
- **Lazy-auth:** conectores são registrados mas nenhum autentica sozinho (ficam
  *needs auth* até o usuário autorizar em `/mcp`); `neogo` é o primeiro a autorizar.
  Conectores são declaração (não-IP), por isso cabem no plugin. Ver seção *Connectors*.

### v1.0.3
- `SKILL.md`: ajuste de vocabulário, alinhando os termos ao que o usuário vê.
  NeoGo runs on the user's own machine, with their own Anthropic account (BYO).

### v1.0.2
- (detalhes de funcionamento interno removidos)
  não apenas chama tools — alinha ao Épico 3 (persona Neo no host).

### v1.0.1
- README: adiciona `LICENSE` ao diagrama de estrutura + nota de que o changelog é
  mantido manualmente (o `commit.sh` não edita esta seção).

### v1.0.0
- Initial release. Thin gateway: a single `neo` entry point plus the MCP
  connector (OAuth 2.1 + PKCE) to `mcp.neogo.app`.
- The operating protocol and utilities are served on demand by the server
  NeoGo runs on the user's own machine, with their own Anthropic account (BYO).
