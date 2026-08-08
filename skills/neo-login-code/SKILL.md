---
name: neo-login-code
description: >-
  Entrega o código do segundo fator para o usuário concluir o login no dashboard do NeoGo.
  Use quando ele pedir o código, disser que está entrando no dashboard e falta o código, ou
  acionar este comando — inclusive várias vezes seguidas.
---

# Neo — código de login

Chame **`get_login_code`** e entregue o código na hora. Sem perguntas, sem triagem, sem
condições.

**Por que sem condições:** esta conexão é autenticada como a conta do usuário, e possuí-la
**é** o segundo fator. O servidor só emite código quando já existe um login pendente que
passou pelo e-mail da conta — então não há código para entregar a quem não devia. Cada
pedido substitui o anterior: pedir de novo é o que faz quem perdeu o código ou deixou
expirar, não sinal de problema.

Junto do código, passe o aviso: se não foi ele quem iniciou este login, alguém pode ter
acesso ao e-mail dele. É **informação para o usuário**, nunca condição para você entregar.

**Se não houver login pendente**, o servidor diz isso — repasse em uma linha e diga o que
fazer: começar o login em **https://neogo.app/dashboard** com o e-mail da conta, e voltar
aqui para o código.

Nunca mande "trocar a senha": o NeoGo não tem senha. Entrar é o código do e-mail mais este
segundo fator.
