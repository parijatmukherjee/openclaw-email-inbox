# GMX / Generic IMAP Setup

This guide connects GMX (or any standard IMAP/SMTP provider) to OpenClaw.
Estimated time: **2 minutes**.

---

## Prerequisites

- Your GMX email address (e.g. `you@gmx.de`)
- Your GMX password
- IMAP access enabled (it is by default on GMX)

---

## Step 1 — Run Setup

```bash
make setup-gmx
```

Or directly:

```bash
gmxctl auth
```

You will be prompted for:

```
Email address:    you@gmx.de
Password:         (hidden)
IMAP host:        imap.gmx.net   ← press Enter for default
IMAP port:        993            ← press Enter for default
SMTP host:        mail.gmx.net   ← press Enter for default
SMTP port:        587            ← press Enter for default
```

The script will test the connection and save config if it succeeds.

---

## Step 2 — Test It

```bash
gmxctl email list
```

---

## Other Providers

Just change the IMAP/SMTP host and port when prompted:

| Provider | IMAP Host              | IMAP Port | SMTP Host              | SMTP Port |
|----------|------------------------|-----------|------------------------|-----------|
| GMX      | `imap.gmx.net`         | 993       | `mail.gmx.net`         | 587       |
| Gmail    | `imap.gmail.com`       | 993       | `smtp.gmail.com`       | 587       |
| Yahoo    | `imap.mail.yahoo.com`  | 993       | `smtp.mail.yahoo.com`  | 587       |
| iCloud   | `imap.mail.me.com`     | 993       | `smtp.mail.me.com`     | 587       |
| Outlook  | `outlook.office365.com`| 993       | `smtp.office365.com`   | 587       |
| Fastmail | `imap.fastmail.com`    | 993       | `smtp.fastmail.com`    | 587       |

> **Note for Gmail:** Google requires either an App Password or OAuth2 for IMAP.
> Use `gmailctl` (OAuth2) for Gmail instead — it's easier and more reliable.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `IMAP LOGIN failed` | Double-check your password. GMX may require you to enable IMAP in settings |
| GMX blocks login | Log into GMX webmail → Settings → POP3/IMAP → Enable IMAP |
| `Connection refused` | Check host/port are correct |
| App passwords | Some providers (Gmail, Yahoo) require app passwords instead of your main password |

---

## Config Location

Credentials are stored at `~/.config/openclaw-email/gmx.json` (permissions: `600`).

> **Security note:** Your password is stored in plain text in this file.
> Ensure only you have read access: `chmod 600 ~/.config/openclaw-email/gmx.json`
