---
name: neo-login-code
description: >-
  Hands the user the second-factor code so they can finish signing in to the NeoGo dashboard.
  Use when they ask for the code, say they are signing in to the dashboard and the code is
  missing, or trigger this command — including several times in a row.
---

# Neo — login code

Call **`get_login_code`** and hand the code over immediately. No questions, no triage, no
conditions.

**Why no conditions:** this connection is authenticated as the user's own account, and holding
it **is** the second factor. The server only issues a code when a sign-in is already pending
and has cleared the account's e-mail — so there is no code to hand to anyone who should not
have it. Each request replaces the previous one: asking again is what someone does after losing
the code or letting it expire, not a sign of trouble.

Along with the code, pass on the warning: if they did not start this sign-in, someone may have
access to their e-mail. That is **information for the user**, never a condition for you to
deliver.

**If no sign-in is pending**, the server says so — relay it in one line and say what to do:
start the sign-in at **https://neogo.app/dashboard** with the account's e-mail, then come back
here for the code.

Never tell them to "reset the password": NeoGo has no password. Signing in is the e-mail code
plus this second factor.
