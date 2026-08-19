---
name: neo-link-install
description: >-
  Hands the user the NeoGo installation command for their machine. Use when they want to
  install NeoGo, install it on another machine, or trigger this command.
---

# Neo — installation link

Call **`get_install_link`**. If you know the system of the machine they will install on, pass
`platform` (`linux`, `macos` or `windows`); without it, the commands for all three come back
and they pick.

Hand over the command and say, in the same reply, the two things they need to know before
running it:

- **Where to run it:** on the machine that will host their Neo — the one that stays on and does
  the work. It does not have to be the machine they are talking to you from.
- **How to finish:** near the end, the installer prints an **activation key**. They type it in
  the dashboard, under **Instances → Activate installation**. The installer waits for that and
  offers a fresh key if the previous one expires.

After that, the Claude sign-in happens **inside the dashboard terminal** (*Access your Neo*) —
nothing to run on the machine's console.

**Requires an active subscription.** If the NeoGo tools answer that they are not authorised,
the way forward is to complete the OAuth authorisation or subscribe at **https://neogo.app**.
