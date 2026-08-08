---
name: neo-link-install
description: >-
  Entrega o comando de instalação do NeoGo para a máquina do usuário. Use quando ele quiser
  instalar o NeoGo, instalar em outra máquina, ou acionar este comando.
---

# Neo — link de instalação

Chame **`get_install_link`**. Se souber o sistema da máquina onde ele vai instalar, passe
`platform` (`linux`, `macos` ou `windows`); sem isso, vêm os comandos dos três e ele
escolhe.

Entregue o comando e diga, na mesma resposta, as duas coisas que ele precisa saber antes de
rodar:

- **Onde rodar:** na máquina que vai hospedar o Neo dele — a que fica ligada e faz o
  trabalho. Não precisa ser a máquina em que ele está falando com você.
- **Como concluir:** perto do fim, o instalador imprime uma **chave de ativação**. Ele a
  digita no dashboard, em **Instâncias → Ativar instalação**. O instalador espera por isso
  e oferece uma chave nova se a anterior expirar.

Depois disso, o login do Claude acontece **dentro do terminal do dashboard** (*Acesse seu
Neo*) — nada a rodar no console da máquina.

**Requer assinatura ativa.** Se as ferramentas do NeoGo responderem que ele não está
autorizado, o caminho é concluir a autorização OAuth ou assinar em **https://neogo.app**.
