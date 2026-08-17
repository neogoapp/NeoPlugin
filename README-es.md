<div align="center">

<img src="https://neogo.app/brand/logo.png" alt="NeoGoApp" width="120" />

<p align="center">
<a href="README.md"><img src="https://img.shields.io/badge/%F0%9F%87%BA%F0%9F%87%B8_English-1c1c1c?style=for-the-badge&labelColor=0a0a0a" alt="English" /></a>
<a href="README-ptbr.md"><img src="https://img.shields.io/badge/%F0%9F%87%A7%F0%9F%87%B7_Portugu%C3%AAs-1c1c1c?style=for-the-badge&labelColor=0a0a0a" alt="Português" /></a>
<a href="README-es.md"><img src="https://img.shields.io/badge/%F0%9F%87%AA%F0%9F%87%B8_Espa%C3%B1ol-00ff88?style=for-the-badge&labelColor=0a0a0a" alt="Español" /></a>
</p>

# NeoPlugin

### Tu Claude ya responde. Ahora haz que **trabaje**.

**NeoPlugin convierte el Claude que ya pagas en la puerta de entrada de un equipo que
entrega — campañas, contenido, investigación, publicación — mientras hablas con un solo
agente.**

<p>
<a href="https://github.com/neogoapp/NeoPlugin/releases/latest"><img src="https://img.shields.io/badge/Instalar%20el%20plugin-neoplugin.zip-00ff88?style=for-the-badge&labelColor=0a0a0a" alt="Instalar el plugin" /></a>
&nbsp;
<a href="https://neogo.app"><img src="https://img.shields.io/badge/Ver%20lo%20que%20hace%20Neo-neogo.app-0a0a0a?style=for-the-badge&labelColor=0a0a0a" alt="Ver lo que hace Neo en neogo.app" /></a>
</p>

<sub>Se ejecuta en tu propia máquina, con tu propia cuenta de Anthropic (BYO)</sub>

</div>

---

## Lo único que cambia este plugin

Claude es excelente respondiendo. Se detiene cuando empieza el trabajo — la campaña todavía
hay que lanzarla, el post todavía hay que publicarlo, el informe todavía tiene que salir del
chat.

Neo es la diferencia: **dices lo que quieres, con tus palabras, y vuelve hecho.** Detrás,
un especialista toma la tarea — medios pagos, social, contenido, ventas, comercio —, hace el
trabajo con tus propios conectores y te reporta a través de Neo. Nunca gestionas al equipo.
Hablas con un agente.

<table>
<tr><td width="50%" valign="top">

**Sin Neo**

- Preguntas, Claude explica
- Copias, pegas y lo haces tú
- Cada herramienta en su pestaña
- Cada conversación empieza de cero

</td><td width="50%" valign="top">

**Con Neo**

- Pides, Neo entrega
- Los especialistas ejecutan con tus conectores
- Un solo punto de contacto para todo
- Te conoce, y recuerda

</td></tr>
</table>

<div align="center">
<h3><a href="https://neogo.app">→ Mira a Neo trabajando, en neogo.app</a></h3>
</div>

---

## Qué es este repositorio

La **puerta** — no el taller.

Este plugin es lo que pone a Neo dentro de la app de Claude y de claude.ai: la skill `neo` y
el conector MCP `neogo`, por OAuth 2.1 + PKCE. El trabajo de verdad ocurre en otro lugar: en
**tu propio contenedor**, con **tu propia cuenta de Anthropic**, al que llegas por la terminal
de tu dashboard.

| Escribes | Qué pasa |
|---|---|
| `/neo` | Hablas con Neo — sobre NeoGo, tu cuenta, tu conexión, tu instalación |
| `/neo-login-code` | Entrega el código del segundo factor para completar el acceso al dashboard |
| `/neo-link-install` | Entrega el comando de instalación para tu máquina |

> Todo lo que le pides a NeoGo **hacer** ocurre en tu propio Neo, por la terminal del
> dashboard — no aquí. Este plugin no instala nada en él: los dos están separados, y cada uno
> viene con lo que necesita.

<div align="center">
<b><a href="https://neogo.app">Mira todo lo que hace Neo → neogo.app</a></b>
</div>

---

## Instalación

<table>
<tr><td width="60%" valign="top">

1. **Descarga** `neoplugin.zip` — desde tu
   [dashboard](https://neogo.app/dashboard), desde el enlace del onboarding, o desde
   [Releases](https://github.com/neogoapp/NeoPlugin/releases/latest). Es el mismo archivo.
2. Abre Claude → **Customize → Plugins → Add → Upload plugin**
3. Selecciona el ZIP
4. En tu primera conversación con Neo, Claude te pide autorizar la conexión
5. Autoriza — y Neo está dentro.

</td><td width="40%" valign="top">

**Vas a necesitar**

- La app de Claude o claude.ai
- Una cuenta [neogo.app](https://neogo.app) con suscripción activa
- Nada más — la autenticación es automática, sin tokens que configurar

</td></tr>
</table>

<div align="center">
<h3><a href="https://neogo.app">→ Crea tu cuenta en neogo.app</a></h3>
<sub>El plugin es la puerta — la cuenta es lo que la abre.</sub>
</div>

---

<details>
<summary><b>Detalles técnicos</b> — conector, herramientas y estructura del repositorio</summary>

<br>

### Conector MCP

`mcp.neogo.app`, por OAuth 2.1 + PKCE. Claude conduce el flujo de forma transparente — no hay
tokens que configurar a mano.

| Herramienta | Descripción |
|------|-------------|
| `get_install_link` | Onboarding — el instalador para tu sistema |
| `get_plugin_manifest` | Onboarding — qué está disponible |
| `get_login_code` | El segundo factor del acceso, entregado dentro de Claude |

Son las herramientas de la puerta: conectar, suscribirse, entrar, instalar.

### Estructura

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Manifiesto del plugin
├── .mcp.json               # Un conector: neogo (mcp.neogo.app)
├── skills/
│   ├── neo/                # Neo: conecta, presenta, atiende, delega
│   ├── neo-login-code/     # Atajo: el código del segundo factor
│   └── neo-link-install/   # Atajo: el comando de instalación
├── scripts/
│   └── commit.sh           # Ayudante de commit versionado
├── LICENSE
└── VERSION
```

### Desarrollo

```bash
./scripts/commit.sh feat  "add new capability"
./scripts/commit.sh major "breaking restructure"
./scripts/commit.sh docs  "update readme"
```

</details>

<details>
<summary><b>Changelog</b></summary>

<br>

> Mantenido a mano — `commit.sh` versiona `VERSION` y `plugin.json`, pero no edita esta sección.

### v1.13.0
- **Dos skills nuevas, de acción:** `/neo-login-code` (el código del segundo factor) y
  `/neo-link-install` (el comando de instalación). Cada una llama a la herramienta correcta y
  entrega el resultado, sin pasar por una conversación.
- **Por qué el prefijo `neo-`:** el nombre de la skill es lo que el usuario escribe, y el menú
  filtra por texto — con el prefijo, escribir `/neo` lista las tres y él elige entre hablar con
  Neo o pedir la acción. (`:` no se acepta en el nombre de una skill: la spec permite solo
  minúsculas, números y guiones.)

### v1.12.0
- **El plugin es de claude.ai — app y web.** Ahí es donde sirve: la puerta de entrada a NeoGo,
  donde el usuario lo conoce, se suscribe y gestiona la cuenta. El trabajo se queda en el
  contenedor, alcanzado por la terminal del dashboard.
- **Queda solo lo esencial: la skill `neo` y el conector `neogo`.** El *connector pack* de
  terceros (`composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`, `okx`,
  `alpaca`) **sale** del `.mcp.json`: esos conectores pertenecen al entorno de trabajo del
  usuario, que ya viene servido con ellos.
- **README y skill sin el mundo antiguo:** sale la instalación por `git clone` y la mención al
  Remote Control — el acceso al Neo del usuario es la terminal del dashboard.

### v1.4.1
- **Identificadores en minúsculas, por spec.** El `name` del `plugin.json` exige **kebab-case**
  y el `name` de la skill exige **solo minúsculas, números y guiones** (docs oficiales de
  plugins y de Agent Skills). Los valores quedaron: plugin `neoplugin` · carpeta de la skill
  `neo` · `name` de la skill `neo`. El usuario sigue viendo "Neo" — eso viene de la persona en
  el `SKILL.md`, no del identificador.

### v1.3.1
- **Corrección:** el plugin describía un modo de trabajo heredado de la versión anterior, en el
  que él mismo conducía las tareas. No es así: el usuario comanda a su propio Neo directamente.
  Entra la regla de **redirección** — los pedidos de trabajo van a donde está el Neo del
  usuario.

### v1.2.1
- Renombra la skill `neogoskill` → **`neo`**, alineando con el nombre que la arquitectura ya
  usaba.

### v1.2.0
- **El plugin pasa a llevar el Neo externo** — persona propia, que nace sabiendo quién es.
- **Rol explicitado:** Neo es la puerta de entrada. Presenta NeoGo a quien todavía no es
  usuario y es el punto de contacto de quien ya lo es (conexión, cuenta e instalación).
- **El plugin tiene tono, no método.** Lo que NeoGo sabe hacer no vive aquí.

### v1.1.0
- **Connector pack** en el `.mcp.json`: además de `neogo` (gateway), 8 conectores de terceros —
  `composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`, `okx`, `alpaca` —
  cubriendo los casos de uso. Todos remotos (`type: url`).
- **Lazy-auth:** los conectores se registran pero ninguno se autentica solo — cada uno espera
  autorización hasta que el usuario quiera usarlo; `neogo` es el primero en autorizarse.

### v1.0.3
- `SKILL.md`: ajuste de vocabulario, alineando los términos a lo que ve el usuario.

### v1.0.2
- `SKILL.md`: el asistente **encarna** a Neo, en vez de solo llamar herramientas.

### v1.0.1
- README: agrega `LICENSE` al diagrama de estructura + nota de que el changelog se mantiene
  manualmente (`commit.sh` no edita esta sección).

### v1.0.0
- Primera versión. Gateway mínimo: un único punto de entrada `neo` más el conector MCP
  (OAuth 2.1 + PKCE) hacia `mcp.neogo.app`.
- Lo que NeoGo sabe hacer se sirve bajo demanda — el plugin se mantiene pequeño y siempre al
  día.

</details>

---

<div align="center">

**Neo trabaja para ti.**

<h3><a href="https://neogo.app">neogo.app</a></h3>

</div>
