<div align="center">

<img src="https://neogo.app/brand/logo.png" alt="NeoGoApp" width="120" />

<p align="center">
<a href="README.md"><img src="https://img.shields.io/badge/%F0%9F%87%BA%F0%9F%87%B8_English-00ff88?style=for-the-badge&labelColor=0a0a0a" alt="English" /></a>
<a href="README-ptbr.md"><img src="https://img.shields.io/badge/%F0%9F%87%A7%F0%9F%87%B7_Portugu%C3%AAs-1c1c1c?style=for-the-badge&labelColor=0a0a0a" alt="Português" /></a>
<a href="README-es.md"><img src="https://img.shields.io/badge/%F0%9F%87%AA%F0%9F%87%B8_Espa%C3%B1ol-1c1c1c?style=for-the-badge&labelColor=0a0a0a" alt="Español" /></a>
</p>

# NeoPlugin

### Your Claude already answers. Now make it **work**.

**NeoPlugin turns the Claude you already pay for into the front door of a team that
delivers — campaigns, content, research, publishing — while you talk to one single agent.**

<p>
<a href="https://github.com/neogoapp/NeoPlugin/releases/latest"><img src="https://img.shields.io/badge/Install%20the%20plugin-neoplugin.zip-00ff88?style=for-the-badge&labelColor=0a0a0a" alt="Install the plugin" /></a>
&nbsp;
<a href="https://neogo.app"><img src="https://img.shields.io/badge/See%20what%20Neo%20does-neogo.app-0a0a0a?style=for-the-badge&labelColor=0a0a0a" alt="See what Neo does at neogo.app" /></a>
</p>

<sub>Runs on your own machine, with your own Anthropic account (BYO)</sub>

</div>

---

## The one thing this plugin changes

Claude is brilliant at answering. It stops when the work starts — the campaign still needs
launching, the post still needs publishing, the report still needs to leave the chat.

Neo is the difference: **you say what you want, in your own words, and it comes back done.**
Behind the scenes a specialist takes the task — paid media, social, content, sales, commerce
— does the work with your own connectors, and reports back to you through Neo. You never
manage the team. You talk to one agent.

<table>
<tr><td width="50%" valign="top">

**Without Neo**

- You ask, Claude explains
- You copy, paste, and do it yourself
- Each tool in its own tab
- Every conversation starts from zero

</td><td width="50%" valign="top">

**With Neo**

- You ask, Neo delivers
- Specialists execute with your connectors
- One point of contact for everything
- It knows you, and remembers

</td></tr>
</table>

<div align="center">
<h3><a href="https://neogo.app">→ See Neo working, at neogo.app</a></h3>
</div>

---

## What this repository is

The **door** — not the workshop.

This plugin is what puts Neo inside the Claude app and claude.ai: the `neo` skill and the
`neogo` MCP connector, over OAuth 2.1 + PKCE. The actual work runs somewhere else: in **your
own container**, with **your own Anthropic account**, reached through the terminal in your
dashboard.

| You type | What happens |
|---|---|
| `/neo` | Talk to Neo — about NeoGo, your account, your connection, your installation |
| `/neo-login-code` | Hands over the second-factor code to finish signing in to the dashboard |
| `/neo-link-install` | Hands over the install command for your machine |

> Everything you ask NeoGo to **do** happens in your own Neo, through the dashboard terminal
> — not here. This plugin installs nothing in it: the two are separate, and each one comes
> with what it needs.

<div align="center">
<b><a href="https://neogo.app">See what Neo does, in full → neogo.app</a></b>
</div>

---

## Install

<table>
<tr><td width="60%" valign="top">

1. **Download** `neoplugin.zip` — from your
   [dashboard](https://neogo.app/dashboard), from the onboarding link, or from
   [Releases](https://github.com/neogoapp/NeoPlugin/releases/latest). All the same file.
2. Open Claude → **Customize → Plugins → Add → Upload plugin**
3. Select the ZIP
4. On your first conversation with Neo, Claude asks you to authorize the connection
5. Authorize — and Neo is in.

</td><td width="40%" valign="top">

**You will need**

- The Claude app or claude.ai
- A [neogo.app](https://neogo.app) account with an active subscription
- Nothing else — auth is automatic, no tokens to configure

</td></tr>
</table>

<div align="center">
<h3><a href="https://neogo.app">→ Get your account at neogo.app</a></h3>
<sub>The plugin is the door — the account is what opens it.</sub>
</div>

---

<details>
<summary><b>Technical details</b> — connector, tools and repository structure</summary>

<br>

### MCP connector

`mcp.neogo.app`, over OAuth 2.1 + PKCE. Claude handles the flow transparently — there is no
manual token setup.

| Tool | Description |
|------|-------------|
| `get_install_link` | Onboarding — the installer for your OS |
| `get_plugin_manifest` | Onboarding — what is available |
| `get_login_code` | The second factor of the login, delivered inside Claude |

These are the tools of the door: connect, subscribe, sign in, install.

### Structure

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── .mcp.json               # One connector: neogo (mcp.neogo.app)
├── skills/
│   ├── neo/                # Neo: connects, presents, supports, delegates
│   ├── neo-login-code/     # Shortcut: the second-factor code
│   └── neo-link-install/   # Shortcut: the install command
├── scripts/
│   └── commit.sh           # Versioned commit helper
├── LICENSE
└── VERSION
```

### Development

```bash
./scripts/commit.sh feat  "add new capability"
./scripts/commit.sh major "breaking restructure"
./scripts/commit.sh docs  "update readme"
```

</details>

<details>
<summary><b>Changelog</b></summary>

<br>

> Kept by hand — `commit.sh` bumps `VERSION` and `plugin.json`, but does not touch this section.

### v1.13.0
- **Two new action skills:** `/neo-login-code` (the second-factor code) and
  `/neo-link-install` (the install command). Each one calls the right tool and hands back the
  result, without going through a conversation.
- **Why the `neo-` prefix:** the skill name is what the user types, and the menu filters by
  text — with the prefix, typing `/neo` lists all three and they choose between talking to Neo
  and asking for the action. (`:` is not accepted in a skill name: the spec allows only
  lowercase letters, digits and hyphens.)

### v1.12.0
- **The plugin belongs to claude.ai — app and web.** That is where it serves: the front door
  to NeoGo, where the user meets it, subscribes and manages the account. The work stays in the
  container, reached through the dashboard terminal.
- **Only the essential stays: the `neo` skill and the `neogo` connector.** The third-party
  *connector pack* (`composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`,
  `okx`, `alpaca`) **leaves** `.mcp.json`: those connectors belong to the user's working
  environment, which already comes served with them.
- **README and skill without the old world:** the `git clone` install and the Remote Control
  mention are gone — the way to the user's Neo is the dashboard terminal.

### v1.4.1
- **Lowercase identifiers, by spec.** `plugin.json`'s `name` requires **kebab-case** and a
  skill's `name` allows **only lowercase letters, digits and hyphens** (official plugin and
  Agent Skills docs). The values became: plugin `neoplugin` · skill folder `neo` · skill
  `name` `neo`. The user still sees "Neo" — that comes from the persona in `SKILL.md`, not
  from the identifier.

### v1.3.1
- **Fix:** the plugin described a way of working inherited from the previous version, in which
  it ran the tasks itself. That is not how it works: the user commands their own Neo directly.
  Enter the **redirection** rule — requests for work go where the user's Neo is.

### v1.2.1
- Renames the `neogoskill` skill to **`neo`**, matching the name the architecture already used.

### v1.2.0
- **The plugin now carries the external Neo** — a persona of its own, born knowing who it is.
- **Role made explicit:** Neo is the front door. It introduces NeoGo to whoever is not a user
  yet, and is the point of contact for whoever already is (connection, account, installation).
- **The plugin has tone, not method.** What NeoGo knows how to do does not live here.

### v1.1.0
- **Connector pack** in `.mcp.json`: besides `neogo` (the gateway), 8 third-party connectors —
  `composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`, `okx`, `alpaca` —
  covering the use cases. All remote (`type: url`).
- **Lazy auth:** connectors are registered but none authenticates on its own — each waits for
  authorization until the user wants it; `neogo` is the first to be authorized.

### v1.0.3
- `SKILL.md`: vocabulary tuned to match the words the user sees.

### v1.0.2
- `SKILL.md`: the assistant **becomes** Neo, instead of merely calling tools.

### v1.0.1
- README: adds `LICENSE` to the structure diagram, plus a note that the changelog is kept by
  hand (`commit.sh` does not edit this section).

### v1.0.0
- Initial release. Thin gateway: a single `neo` entry point plus the MCP connector
  (OAuth 2.1 + PKCE) to `mcp.neogo.app`.
- What NeoGo knows how to do is served on demand — the plugin stays tiny and always current.

</details>

---

<div align="center">

**Neo works for you.**

<h3><a href="https://neogo.app">neogo.app</a></h3>

</div>
