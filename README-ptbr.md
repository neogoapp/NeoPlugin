<div align="center">

<img src="https://neogo.app/brand/logo.png" alt="NeoGoApp" width="120" />

<p align="center">
<a href="README.md"><img src="https://img.shields.io/badge/%F0%9F%87%BA%F0%9F%87%B8_English-1c1c1c?style=for-the-badge&labelColor=0a0a0a" alt="English" /></a>
<a href="README-ptbr.md"><img src="https://img.shields.io/badge/%F0%9F%87%A7%F0%9F%87%B7_Portugu%C3%AAs-00ff88?style=for-the-badge&labelColor=0a0a0a" alt="Português" /></a>
<a href="README-es.md"><img src="https://img.shields.io/badge/%F0%9F%87%AA%F0%9F%87%B8_Espa%C3%B1ol-1c1c1c?style=for-the-badge&labelColor=0a0a0a" alt="Español" /></a>
</p>

# NeoPlugin

### Seu Claude já responde. Agora faça ele **trabalhar**.

**O NeoPlugin transforma o Claude que você já paga na porta de entrada de um time que
entrega — campanhas, conteúdo, pesquisa, publicação — enquanto você fala com um agente só.**

<p>
<a href="https://github.com/neogoapp/NeoPlugin/releases/latest"><img src="https://img.shields.io/badge/Instalar%20o%20plugin-neoplugin.zip-00ff88?style=for-the-badge&labelColor=0a0a0a" alt="Instalar o plugin" /></a>
&nbsp;
<a href="https://neogo.app"><img src="https://img.shields.io/badge/Ver%20o%20que%20o%20Neo%20faz-neogo.app-0a0a0a?style=for-the-badge&labelColor=0a0a0a" alt="Ver o que o Neo faz em neogo.app" /></a>
</p>

<sub>Roda na sua própria máquina, com a sua própria conta Anthropic (BYO)</sub>

</div>

---

## A única coisa que este plugin muda

O Claude é excelente em responder. Ele para quando o trabalho começa — a campanha ainda
precisa subir, o post ainda precisa ser publicado, o relatório ainda precisa sair do chat.

O Neo é a diferença: **você diz o que quer, com as suas palavras, e volta pronto.** Nos
bastidores um especialista assume a tarefa — mídia paga, social, conteúdo, vendas, comércio
—, faz o trabalho com os seus conectores e reporta a você pelo Neo. Você nunca gerencia o
time. Você fala com um agente.

<table>
<tr><td width="50%" valign="top">

**Sem o Neo**

- Você pergunta, o Claude explica
- Você copia, cola e faz você mesmo
- Cada ferramenta na sua aba
- Toda conversa começa do zero

</td><td width="50%" valign="top">

**Com o Neo**

- Você pede, o Neo entrega
- Especialistas executam com os seus conectores
- Um ponto de contato para tudo
- Ele conhece você, e lembra

</td></tr>
</table>

<div align="center">
<h3><a href="https://neogo.app">→ Veja o Neo trabalhando, em neogo.app</a></h3>
</div>

---

## O que é este repositório

A **porta** — não a oficina.

Este plugin é o que coloca o Neo dentro do app do Claude e do claude.ai: a skill `neo` e o
conector MCP `neogo`, por OAuth 2.1 + PKCE. O trabalho de verdade acontece em outro lugar: no
**seu próprio container**, com a **sua própria conta Anthropic**, alcançado pelo terminal do
seu dashboard.

| Você digita | O que acontece |
|---|---|
| `/neo` | Fala com o Neo — sobre o NeoGo, sua conta, sua conexão, sua instalação |
| `/neo-login-code` | Entrega o código do segundo fator para concluir o login no dashboard |
| `/neo-link-install` | Entrega o comando de instalação para a sua máquina |

> Tudo o que você pede ao NeoGo para **fazer** acontece no seu próprio Neo, pelo terminal do
> dashboard — não aqui. Este plugin não instala nada nele: os dois são separados, e cada um
> vem com o que precisa.

<div align="center">
<b><a href="https://neogo.app">Veja tudo o que o Neo faz → neogo.app</a></b>
</div>

---

## Instalação

<table>
<tr><td width="60%" valign="top">

1. **Baixe** o `neoplugin.zip` — pelo seu
   [dashboard](https://neogo.app/dashboard), pelo link do onboarding, ou pelas
   [Releases](https://github.com/neogoapp/NeoPlugin/releases/latest). É o mesmo arquivo.
2. Abra o Claude → **Customize → Plugins → Add → Upload plugin**
3. Selecione o ZIP
4. Na sua primeira conversa com o Neo, o Claude pede para você autorizar a conexão
5. Autorize — e o Neo está dentro.

</td><td width="40%" valign="top">

**Você vai precisar de**

- O app do Claude ou o claude.ai
- Uma conta [neogo.app](https://neogo.app) com assinatura ativa
- Nada além disso — a autenticação é automática, sem token para configurar

</td></tr>
</table>

<div align="center">
<h3><a href="https://neogo.app">→ Crie sua conta em neogo.app</a></h3>
<sub>O plugin é a porta — a conta é o que a abre.</sub>
</div>

---

<details>
<summary><b>Detalhes técnicos</b> — conector, ferramentas e estrutura do repositório</summary>

<br>

### Conector MCP

`mcp.neogo.app`, por OAuth 2.1 + PKCE. O Claude conduz o fluxo de forma transparente — não há
token para configurar à mão.

| Ferramenta | Descrição |
|------|-------------|
| `get_install_link` | Onboarding — o instalador para o seu sistema |
| `get_plugin_manifest` | Onboarding — o que está disponível |
| `get_login_code` | O segundo fator do login, entregue dentro do Claude |

São as ferramentas da porta: conectar, assinar, entrar, instalar.

### Estrutura

```
NeoPlugin/
├── .claude-plugin/
│   └── plugin.json         # Manifesto do plugin
├── .mcp.json               # Um conector: neogo (mcp.neogo.app)
├── skills/
│   ├── neo/                # Neo: conecta, apresenta, atende, delega
│   ├── neo-login-code/     # Atalho: o código do segundo fator
│   └── neo-link-install/   # Atalho: o comando de instalação
├── scripts/
│   └── commit.sh           # Auxiliar de commit versionado
├── LICENSE
└── VERSION
```

### Desenvolvimento

```bash
./scripts/commit.sh feat  "add new capability"
./scripts/commit.sh major "breaking restructure"
./scripts/commit.sh docs  "update readme"
```

</details>

<details>
<summary><b>Changelog</b></summary>

<br>

> Mantido à mão — o `commit.sh` versiona `VERSION` e `plugin.json`, mas não edita esta seção.

### v1.13.0
- **Duas skills novas, de ação:** `/neo-login-code` (o código do segundo fator) e
  `/neo-link-install` (o comando de instalação). Cada uma chama a ferramenta certa e entrega o
  resultado, sem passar por uma conversa.
- **Por que o prefixo `neo-`:** o nome da skill é o que o usuário digita, e o menu filtra por
  texto — com o prefixo, digitar `/neo` lista as três e ele escolhe entre falar com o Neo ou
  pedir a ação. (`:` não é aceito no nome de uma skill: a spec permite apenas minúsculas,
  números e hífens.)

### v1.12.0
- **O plugin é do claude.ai — app e web.** É lá que ele serve: a porta de entrada do NeoGo,
  onde o usuário conhece, assina e cuida da conta. O trabalho fica no container, alcançado
  pelo terminal do dashboard.
- **Fica só o essencial: a skill `neo` e o conector `neogo`.** O *connector pack* de terceiros
  (`composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`, `okx`, `alpaca`)
  **sai** do `.mcp.json`: esses conectores pertencem ao ambiente de trabalho do usuário, que já
  vem servido com eles.
- **README e skill sem o mundo antigo:** sai a instalação por `git clone` e a menção ao Remote
  Control — o acesso ao Neo do usuário é o terminal do dashboard.

### v1.4.1
- **Identificadores em minúsculas, por spec.** O `name` do `plugin.json` exige **kebab-case** e
  o `name` da skill exige **apenas minúsculas, números e hífens** (docs oficiais de plugins e de
  Agent Skills). Os valores viraram: plugin `neoplugin` · pasta da skill `neo` · `name` da skill
  `neo`. O usuário continua vendo "Neo" — isso vem da persona no `SKILL.md`, não do
  identificador.

### v1.3.1
- **Correção:** o plugin descrevia um modo de trabalho herdado da versão anterior, em que ele
  próprio conduzia as tarefas. Não é assim: o usuário comanda o Neo dele diretamente. Entra a
  regra de **redirecionamento** — pedidos de trabalho vão para onde o Neo do usuário está.

### v1.2.1
- Renomeia a skill `neogoskill` → **`neo`**, alinhando ao nome que a arquitetura já usava.

### v1.2.0
- **O plugin passa a carregar o Neo externo** — persona própria, que nasce sabendo quem é.
- **Papel explicitado:** Neo é a porta de entrada. Apresenta o NeoGo a quem ainda não é usuário
  e é o ponto de contato de quem já é (conexão, conta e instalação).
- **O plugin tem tom, não método.** O que o NeoGo sabe fazer não mora aqui.

### v1.1.0
- **Connector pack** no `.mcp.json`: além do `neogo` (gateway), 8 conectores de terceiros —
  `composio`, `kairogen`, `higgsfield`, `facebook-ads`, `metricool`, `wix`, `okx`, `alpaca` —
  cobrindo os casos de uso. Todos remotos (`type: url`).
- **Lazy-auth:** conectores são registrados mas nenhum autentica sozinho — cada um fica
  aguardando autorização até o usuário quiser usá-lo; `neogo` é o primeiro a autorizar.

### v1.0.3
- `SKILL.md`: ajuste de vocabulário, alinhando os termos ao que o usuário vê.

### v1.0.2
- `SKILL.md`: o assistente **encarna** o Neo, em vez de apenas chamar ferramentas.

### v1.0.1
- README: adiciona `LICENSE` ao diagrama de estrutura + nota de que o changelog é mantido
  manualmente (o `commit.sh` não edita esta seção).

### v1.0.0
- Primeira versão. Gateway enxuto: um único ponto de entrada `neo` mais o conector MCP
  (OAuth 2.1 + PKCE) para `mcp.neogo.app`.
- O que o NeoGo sabe fazer é servido sob demanda — o plugin fica pequeno e sempre atual.

</details>

---

<div align="center">

**O Neo trabalha para você.**

<h3><a href="https://neogo.app">neogo.app</a></h3>

</div>
