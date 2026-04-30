# openclaw-email-inbox

Email and calendar integration for [OpenClaw](https://openclaw.dev) agents.

Connect your AI agent to **Microsoft (Outlook/Live/Hotmail)**, **Gmail**, and **GMX** (or any IMAP provider) — with a built-in draft-approval gate so the agent always asks before sending.

---

## What's Included

| Script      | Provider                          | Protocol         |
|-------------|-----------------------------------|------------------|
| `msgraph`   | Microsoft (Outlook/Live/Hotmail)  | Microsoft Graph API (OAuth2) |
| `gmailctl`  | Gmail                             | Gmail API (OAuth2) |
| `gmxctl`    | GMX, Yahoo, iCloud, Fastmail, etc | IMAP / SMTP      |

All scripts follow the same interface: `list`, `read`, `draft`, `send`.

---

## Quick Start

### 1. Clone

```bash
git clone https://github.com/parijatmukherjee/openclaw-email-inbox.git
cd openclaw-email-inbox
```

### 2. Install

```bash
make install
```

This copies the scripts to `~/.local/bin`. Make sure it's in your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
# Add to ~/.bashrc or ~/.zshrc to make permanent
```

### 3. Connect your accounts

Run only the providers you need:

```bash
make setup-microsoft   # Outlook / Live / Hotmail
make setup-gmail       # Gmail
make setup-gmx         # GMX or any IMAP provider
```

Each command walks you through the setup interactively.

### 4. Add to OpenClaw workspace

```bash
make workspace
```

This copies `workspace/TOOLS.md` into your OpenClaw workspace (`~/.openclaw/workspace/TOOLS.md`) so your agent knows what commands are available.

### 5. Check everything

```bash
make check
```

---

## Usage Examples

### Read email

```bash
msgraph email list            # Microsoft inbox
gmailctl email list           # Gmail inbox
gmxctl email list             # GMX inbox

msgraph email read AAMkAGI... # read a specific message
```

### Draft + send (with agent approval gate)

```bash
# Save as draft first
msgraph email draft --to "friend@example.com" --subject "Hello" --body "..."

# Send only after user confirms
msgraph email send --to "friend@example.com" --subject "Hello" --body "..."
```

### Calendar (Microsoft)

```bash
msgraph calendar list            # next 7 days
msgraph calendar list 14         # next 14 days

msgraph calendar create \
  --subject "Team meeting" \
  --start "2026-05-10T14:00:00" \
  --end   "2026-05-10T15:00:00" \
  --timezone "Europe/Berlin"

msgraph calendar delete <event-id>
```

---

## Agent Setup Guide

If you're configuring this for an OpenClaw agent (like Dobby), paste this into your agent's `TOOLS.md` or point it to `workspace/TOOLS.md`:

```
msgraph email list            — list Microsoft inbox
gmailctl email list           — list Gmail inbox
gmxctl email list             — list GMX inbox
```

The `workspace/TOOLS.md` file in this repo is ready to copy directly.

**Important rule to add to your agent's `SOUL.md`:**

```
Always draft emails first. Never send without explicit user approval.
1. Prepare draft (To, Subject, Body) and show to user.
2. Wait for confirmation: "yes", "send it", "approved".
3. Send only after explicit approval.
4. If edited, re-confirm before sending.
```

---

## Detailed Setup Guides

- [Microsoft (Outlook/Live)](setup/microsoft.md)
- [Gmail](setup/gmail.md)
- [GMX / Generic IMAP](setup/gmx.md)

---

## Requirements

- Python 3.8+
- No external packages required (uses only stdlib)

---

## Config Files

| Provider  | Config Path                               | Auth Method     |
|-----------|-------------------------------------------|-----------------|
| Microsoft | `~/.config/openclaw-email/microsoft.json` | OAuth2 tokens   |
| Gmail     | `~/.config/openclaw-email/gmail.json`     | OAuth2 tokens   |
| GMX/IMAP  | `~/.config/openclaw-email/gmx.json`       | Username + password |

All files are created with `chmod 600` (owner-read-only).

---

## Re-authenticate

If tokens expire, just re-run the auth command:

```bash
msgraph auth    # Microsoft
gmailctl auth   # Gmail
gmxctl auth     # GMX (re-enter password)
```

---

## License

MIT
