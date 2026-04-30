# Email Tools for OpenClaw Agents

You have three email CLIs available. Use them to read, draft, and send email on behalf of the user.

---

## CRITICAL RULE — Always Draft Before Sending

**Never send an email directly. Always:**
1. Prepare the draft and show it to the user (To, Subject, Body, Attachments)
2. Wait for explicit approval: "yes", "send it", "approved", or similar
3. Only then send with `msgraph email send` / `gmailctl email send` / `gmxctl email send`
4. If the user edits the draft, update it and ask again before sending

This rule applies even when the user says "send an email to..." — draft first, always.

---

## Available Commands

### Microsoft — Outlook / Live / Hotmail (`msgraph`)

```bash
msgraph email list                    # inbox (last 20), ● = unread
msgraph email list sent               # sent items
msgraph email read <id>               # read message, body + attachment list
msgraph email draft \
  --to "addr" \
  --subject "..." \
  --body "..." \
  [--attach /path/to/file] \          # local file (repeatable)
  [--attach-url "https://..."]        # remote URL (repeatable)
msgraph email send  --to ... --subject ... --body ... [--attach ...] [--attach-url ...]
msgraph email attachment <msg-id> <att-id> [--out filename]   # download an attachment

msgraph calendar list [days]          # upcoming events (default: 7 days)
msgraph calendar create \
  --subject "..." \
  --start "2026-05-10T14:00:00" \
  --end   "2026-05-10T15:00:00" \
  --timezone "Europe/Berlin"
msgraph calendar delete <event-id>
```

### Gmail (`gmailctl`)

```bash
gmailctl email list
gmailctl email list sent
gmailctl email read <id>
gmailctl email draft --to "addr" --subject "..." --body "..." [--attach /path]
gmailctl email send  --to "addr" --subject "..." --body "..." [--attach /path]
```

### GMX / Generic IMAP (`gmxctl`)

```bash
gmxctl email list
gmxctl email list sent
gmxctl email read <uid>
gmxctl email draft --to "addr" --subject "..." --body "..." [--attach /path]
gmxctl email send  --to "addr" --subject "..." --body "..." [--attach /path]
```

---

## Handling File Attachments from Discord (or any channel)

When the user shares a file with you in Discord, the file arrives as a Discord CDN URL
attached to their message. **You cannot pass this URL directly to `--attach`** — you must
download it to a local temp file first, then attach the local path.

### Step-by-step

**1. Download the file to /tmp/**

```bash
curl -L -o /tmp/<original_filename> "<discord_cdn_url>"
```

Example:
```bash
curl -L -o /tmp/invoice.pdf "https://cdn.discordapp.com/attachments/123/456/invoice.pdf"
```

**2. Draft the email using the local path**

```bash
msgraph email draft \
  --to "recipient@example.com" \
  --subject "Invoice attached" \
  --body "Please find the invoice attached." \
  --attach /tmp/invoice.pdf
```

**3. Show the draft to the user and wait for approval**

Tell the user:
> Draft ready:
> To: recipient@example.com
> Subject: Invoice attached
> Body: Please find the invoice attached.
> Attachment: invoice.pdf (42 KB)
>
> Send it?

**4. After the user approves, send**

```bash
msgraph email send \
  --to "recipient@example.com" \
  --subject "Invoice attached" \
  --body "Please find the invoice attached." \
  --attach /tmp/invoice.pdf
```

**5. Clean up the temp file**

```bash
rm /tmp/invoice.pdf
```

### Multiple attachments

You can attach multiple files by repeating `--attach`:

```bash
msgraph email draft \
  --to "boss@company.com" \
  --subject "Documents" \
  --body "Two files attached." \
  --attach /tmp/report.pdf \
  --attach /tmp/spreadsheet.xlsx
```

### Mixing local files and URLs

If you already have a local file AND the user also shared a URL:

```bash
msgraph email draft \
  --to "..." \
  --subject "..." \
  --body "..." \
  --attach /tmp/local_file.pdf \
  --attach-url "https://example.com/public_document.pdf"
```

---

## Config Files (credentials — do not share or print)

| Provider  | Config                                    |
|-----------|-------------------------------------------|
| Microsoft | `~/.config/openclaw-email/microsoft.json` |
| Gmail     | `~/.config/openclaw-email/gmail.json`     |
| GMX/IMAP  | `~/.config/openclaw-email/gmx.json`       |

If a command fails with "Config not found", run the appropriate auth command:
- `msgraph auth`
- `gmailctl auth`
- `gmxctl auth`

---

## Message IDs

Message IDs are long. The CLI displays a **short ID** (last ~14 chars) in brackets, e.g. `[ZAAI_92wMAAAAA]`.

You can pass the short ID directly to `email read` and `email attachment` — the script resolves it automatically. For calendar events use the short ID shown in `calendar list`.

---

## Timezone

Default timezone for calendar events: **Europe/Berlin**.
Always use `--timezone "Europe/Berlin"` when creating events unless the user specifies otherwise.
