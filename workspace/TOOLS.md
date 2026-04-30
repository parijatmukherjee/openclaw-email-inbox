# Email Tools for OpenClaw Agents

You have one unified email CLI: `emctl`. It works with any IMAP/SMTP provider
(Microsoft Outlook/Live, Gmail, GMX, Yahoo, etc.) using App Passwords.

---

## CRITICAL RULE — Always Draft Before Sending

**Never send an email directly. Always:**
1. Build the draft and show it to the user (To, Subject, Body, Attachments)
2. Wait for explicit approval: "yes", "send it", "approved", or similar
3. Only then send with `emctl email send`
4. If the user edits anything, show the updated draft and ask again

This applies even when the user says "send an email to..." — draft first, always.

---

## Commands

```bash
# Account management
emctl list-accounts                        # show all configured accounts
emctl add-account                          # add a new account interactively
emctl set-default <name>                   # change default account

# Email — uses default account
emctl email list                           # inbox (last 20), ● = unread
emctl email list sent                      # sent items
emctl email list drafts                    # drafts folder
emctl email read <uid>                     # read message + list attachments
emctl email attachment <uid> <index> [--out filename]  # download attachment
emctl email draft --to ADDR --subject "..." --body "..." [--attach FILE] [--attach-url URL]
emctl email send  --to ADDR --subject "..." --body "..." [--attach FILE] [--attach-url URL]

# Email — specific account
emctl -a gmail    email list
emctl -a microsoft email list
emctl -a gmx      email list
```

`--attach` and `--attach-url` are repeatable: `--attach a.pdf --attach b.pdf`

---

## Handling File Attachments from Discord (or any channel)

When the user shares a file with you in Discord, it arrives as a Discord CDN URL.
**You must download it locally first — do not pass the URL to --attach.**

### Step-by-step

**1. Download to /tmp/**
```bash
curl -L -o /tmp/<filename> "<discord_cdn_url>"
```

**2. Draft with the local path**
```bash
emctl email draft \
  --to "recipient@example.com" \
  --subject "..." \
  --body "..." \
  --attach /tmp/<filename>
```

**3. Show the draft to the user**
> Draft ready:
> To: recipient@example.com
> Subject: ...
> Attachment: filename.pdf
>
> Send it?

**4. After approval, send**
```bash
emctl email send \
  --to "recipient@example.com" \
  --subject "..." \
  --body "..." \
  --attach /tmp/<filename>
```

**5. Clean up**
```bash
rm /tmp/<filename>
```

For files from any other source that gives you a real public URL (not Discord):
```bash
emctl email draft --to "..." --subject "..." --body "..." --attach-url "https://..."
```

---

## Config

Accounts are stored at `~/.config/openclaw-email/accounts.json` (chmod 600).

If a command fails with "No accounts configured", run:
```bash
emctl add-account
```

---

## Message UIDs

The `email list` output shows a numeric UID in brackets, e.g. `[  142]`.
Pass that number directly to `email read` and `email attachment`.

UIDs are per-folder. A UID from `email list sent` won't work with `email read`
(which searches INBOX). For non-inbox messages, note the folder context.

---

## Notes

- Default timezone for any date references: **Europe/Berlin**
- Microsoft calendar is not available via IMAP — email only
- If login fails, the user likely needs to generate/regenerate their App Password
