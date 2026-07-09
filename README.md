# NeoPlugin

Claude Plugin that connects Claude to Neo — your AI agent running outside the Matrix.

## What it does

NeoGo runs on the user's own machine, with their own Anthropic account (BYO).

With NeoGo you:

- (detalhes de funcionamento interno removidos)
- (detalhes de funcionamento interno removidos)

Authentication is automatic via **OAuth 2.1 + PKCE** — no token configuration.

## How it works

The same plugin runs in two roles, and the server tells you which you are (by your token):

- (detalhes de funcionamento interno removidos)
- (detalhes de funcionamento interno removidos)

NeoGo runs on the user's own machine, with their own Anthropic account (BYO).

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

Tools:

| Tool | Description |
|------|-------------|



## Structure

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest (v1.0.0)
├── .mcp.json               # MCP connector → mcp.neogo.app (OAuth 2.1) — host
├── skills/
│   └── neogoskill/
│       └── SKILL.md        # Neo: the entry point
├── scripts/
│   └── commit.sh           # Versioned commit helper
└── VERSION                 # Current plugin version
```

## Development

```bash
./scripts/commit.sh feat  "add new capability"
./scripts/commit.sh major "breaking restructure"
./scripts/commit.sh docs  "update readme"
```

## Changelog

### v1.0.0
- Initial release. Thin gateway: a single `neogoskill` entry point plus the MCP
  connector (OAuth 2.1 + PKCE) to `mcp.neogo.app`.
- The operating protocol and utilities are served on demand by the server
  NeoGo runs on the user's own machine, with their own Anthropic account (BYO).
