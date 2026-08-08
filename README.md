# NeoPlugin

Claude Plugin that connects Claude to Neo — your AI agent running outside the Matrix.

## What it does

NeoPlugin is the **way in** to NeoGo, for the **Claude app and claude.ai**. It carries two
things and nothing else:

- the **`neo` skills** — Neo, the assistant the user talks to, plus two shortcuts for the
  things people ask for by name;
- the **`neogo` MCP connector** (`mcp.neogo.app`), over OAuth 2.1 + PKCE.

| Skill | What it does |
|-------|--------------|
| `/neo` | Talk to Neo — about NeoGo, the account, the connection, the installation |
| `/neo-login-code` | Hands over the second-factor code to finish signing in to the dashboard |
| `/neo-link-install` | Hands over the install command for the user's machine |

Typing `/neo` lists the three, so the user chooses between talking and acting.

Neo's job here is to get the user connected and keep them connected:

- **Not a NeoGo user yet?** Neo explains what it is in terms of what *they* do, and points
  them to sign up. Honestly — no invented capabilities, no manufactured urgency.
- **Already a user?** Neo is their point of contact: it owns the problem when something is
  off (installation not running, connection unauthorized, subscription lapsed).

With NeoGo you:

- **Run multi-agent workflows** in natural language on **your own container** — on your
  machine, with **your own Anthropic account** (BYO). No central LLM proxy, no platform
  API keys.

Authentication is automatic via **OAuth 2.1 + PKCE** — no token configuration.

## Where the work happens

This plugin is the **door, not the workshop**.

The actual work — campaigns, research, publishing, files — happens in the user's own
container, through the **terminal in the dashboard** (*Access your Neo*). That is where the
user's connectors and files are, and where Neo has everything it needs to deliver. Neo here
recognizes that request and takes the user there, instead of delivering a lesser version
of it.

This plugin installs nothing in the user's Neo — the two are separate, and each one comes
with what it needs.

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

These are the tools of the door: connect, subscribe, sign in, install. Everything the user
asks NeoGo to *do* happens in their own Neo, through the terminal in the dashboard.

## Structure

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── .mcp.json               # One connector: neogo (mcp.neogo.app)
├── skills/
│   ├── neo/
│   │   └── SKILL.md        # Neo: connects, sells, supports, delegates
│   ├── neo-login-code/
│   │   └── SKILL.md        # Shortcut: the second-factor code
│   └── neo-link-install/
│       └── SKILL.md        # Shortcut: the install command
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

### v1.13.0
- **Duas skills novas, de ação:** `/neo-login-code` (o código do segundo fator) e
  `/neo-link-install` (o comando de instalação). Cada uma chama a ferramenta certa e
  entrega o resultado, sem passar por uma conversa.
- **Por que o prefixo `neo-`:** o nome da skill é o que o usuário digita, e o menu filtra
  por texto — com o prefixo, digitar `/neo` lista as três e ele escolhe entre falar com o
  Neo ou pedir a ação. (`:` não é aceito no nome de uma skill: a spec permite apenas
  minúsculas, números e hífens.)

### v1.12.0
- **O plugin é do claude.ai — app e web.** É lá que ele serve: a porta de entrada do NeoGo,
  onde o usuário conhece, assina e cuida da conta. O trabalho fica no container, alcançado
  pelo terminal do dashboard.
- **Fica só o essencial: a skill `neo` e o conector `neogo`.** O *connector pack* de
  terceiros (`composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`,
  `okx`, `alpaca`) **sai** do `.mcp.json`: esses conectores pertencem ao ambiente de
  trabalho do usuário, que já vem servido com eles.
- **README e skill sem o mundo antigo:** sai a instalação por `git clone` e a menção ao
  Remote Control — o acesso ao Neo do usuário é o terminal do dashboard.

### v1.4.1
- **Identificadores em minúsculas, por spec.** O `name` do `plugin.json` exige **kebab-case**
  e o `name` da skill exige **apenas minúsculas, números e hífens** (docs oficiais de plugins
  e de Agent Skills). Os valores viraram: plugin `neoplugin` · pasta da skill `neo` ·
  `name` da skill `neo`. O usuário continua vendo "Neo" — isso vem da persona no `SKILL.md`,
  não do identificador.

### v1.3.1
- **Correção:** o plugin descrevia um modo de trabalho herdado da versão anterior, em que ele
  próprio conduzia as tarefas. Não é assim: o usuário comanda o Neo dele diretamente. Entra
  a regra de **redirecionamento** — pedidos de trabalho vão para onde o Neo do usuário está.

### v1.2.1
- Renomeia a skill `neogoskill` → **`neo`**, alinhando ao nome que a arquitetura já usava.

### v1.2.0
- **O plugin passa a carregar o Neo externo** — persona própria, que nasce sabendo quem é.
- **Papel explicitado:** Neo é a porta de entrada. Apresenta o NeoGo a quem ainda não é
  usuário e é o ponto de contato de quem já é (conexão, conta e instalação).
- **O plugin tem tom, não método.** O que o NeoGo sabe fazer não mora aqui.

### v1.1.0
- **Connector pack** no `.mcp.json`: além do `neogo` (gateway), 8 conectores de
  terceiros — `composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`,
  `wix`, `okx`, `alpaca` — cobrindo os casos de uso. Todos remotos (`type: url`).
- **Lazy-auth:** conectores são registrados mas nenhum autentica sozinho — cada um fica
  aguardando autorização até o usuário quiser usá-lo; `neogo` é o primeiro a autorizar.

### v1.0.3
- `SKILL.md`: ajuste de vocabulário, alinhando os termos ao que o usuário vê.

### v1.0.2
- `SKILL.md`: o assistente **encarna** o Neo, em vez de apenas chamar ferramentas.

### v1.0.1
- README: adiciona `LICENSE` ao diagrama de estrutura + nota de que o changelog é
  mantido manualmente (o `commit.sh` não edita esta seção).

### v1.0.0
- Initial release. Thin gateway: a single `neo` entry point plus the MCP
  connector (OAuth 2.1 + PKCE) to `mcp.neogo.app`.
- What NeoGo knows how to do is served on demand — the plugin stays tiny and always current.
