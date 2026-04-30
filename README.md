# openclaw-email-inbox

Unified email integration for [OpenClaw](https://openclaw.dev) agents via IMAP/SMTP.

One script — `emctl` — connects any email provider using App Passwords.
No OAuth flows, no cloud project setup, no token management.

Supports: **Microsoft (Outlook/Live/Hotmail)**, **Gmail**, **GMX**, **Yahoo**, **iCloud**, **Fastmail**, and any IMAP/SMTP provider.

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

Make sure `~/.local/bin` is in your PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
# Add to ~/.bashrc or ~/.zshrc to make it permanent
```

### 3. Add your email accounts

```bash
make add-account
```

Run this once per email account. You'll need an **App Password** — see [setup/app-passwords.md](setup/app-passwords.md) for instructions for each provider.

### 4. Set up the OpenClaw agent

```bash
make workspace
```

Copies `workspace/TOOLS.md` into your OpenClaw workspace so your agent knows the available commands.

### 5. Check everything

```bash
make check
```

---

## Usage

```bash
# List all configured accounts
emctl list-accounts

# Read inbox (default account)
emctl email list

# Read inbox of a specific account
emctl -a gmail    email list
emctl -a microsoft email list

# Read a message
emctl email read 142

# Save a draft
emctl email draft \
  --to "friend@example.com" \
  --subject "Hello" \
  --body "How are you?"

# Send (after drafting and reviewing)
emctl email send \
  --to "friend@example.com" \
  --subject "Hello" \
  --body "How are you?"

# Attach a local file
emctl email send --to "..." --subject "..." --body "..." --attach /path/to/file.pdf

# Attach from a URL (e.g. a public download link)
emctl email send --to "..." --subject "..." --body "..." --attach-url "https://..."

# Download an attachment from a received email
emctl email read 142          # shows attachment list with index numbers
emctl email attachment 142 0  # downloads attachment at index 0
emctl email attachment 142 0 --out report.pdf  # save with custom name
```

---

## Adding More Accounts

```bash
make add-account
```

Or directly:
```bash
emctl add-account
```

To change the default account:
```bash
emctl set-default gmail
```

---

## Agent Setup

The `workspace/TOOLS.md` file in this repo is written for OpenClaw agents. It covers:
- All `emctl` commands
- How to handle Discord file attachments (download to `/tmp/` first)
- The draft-approval workflow (always draft, never send without user confirmation)
- How to look up message UIDs

After running `make workspace`, restart your OpenClaw agent to load the new instructions.

---

## App Passwords

Each provider has a slightly different flow for generating App Passwords.
See [setup/app-passwords.md](setup/app-passwords.md) for step-by-step instructions for:

- Microsoft (Outlook / Live / Hotmail)
- Gmail
- GMX
- Yahoo
- iCloud
- Fastmail

---

## Requirements

- Python 3.8+
- No external packages (uses only stdlib)

---

## Config

All accounts are stored in `~/.config/openclaw-email/accounts.json` with `chmod 600`.

```json
{
  "default": "microsoft",
  "accounts": {
    "microsoft": {
      "username": "you@live.com",
      "password": "app-password-here",
      "imap_host": "outlook.office365.com",
      "imap_port": 993,
      "smtp_host": "smtp.office365.com",
      "smtp_port": 587
    },
    "gmail": {
      "username": "you@gmail.com",
      "password": "app-password-here",
      "imap_host": "imap.gmail.com",
      "imap_port": 993,
      "smtp_host": "smtp.gmail.com",
      "smtp_port": 587
    }
  }
}
```

---

## Note on Microsoft Calendar

This repo handles **email only** via IMAP. Microsoft Calendar (previously available via the Graph API) is not included. If you need calendar support, it requires a separate OAuth2 integration.

---

## License

MIT
