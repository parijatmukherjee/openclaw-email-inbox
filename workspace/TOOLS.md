# Email Tools for OpenClaw Agents

Two CLIs are available:

| Tool      | Provider                         | Auth method       |
|-----------|----------------------------------|-------------------|
| `msgraph` | Microsoft (Outlook/Live/Hotmail) | OAuth2 (Graph API) — Microsoft blocks IMAP basic auth |
| `emctl`   | Gmail, GMX, Yahoo, iCloud, etc.  | IMAP/SMTP with App Passwords |

---

## CRITICAL RULES

### Sending
Always draft before sending — never send without explicit user approval (see Sending section below).

### Deleting
- **Single email**: show the subject and sender, confirm with the user before deleting.
- **Bulk delete (`--all`)**: show count + sample subjects, require the user to explicitly say "yes delete them all" or similar. Never bulk delete without clear confirmation.
- Default is move to Trash (recoverable). Only use `--permanent` if the user explicitly says "permanently" or "forever".

---

## CRITICAL RULE — Always Draft Before Sending

**Never send an email directly. Always:**
1. Build the draft and show it to the user (To, Subject, Body, Attachments)
2. Wait for explicit approval: "yes", "send it", "approved", or similar
3. Only then run the send command
4. If the user edits anything, show the updated draft and ask again

This applies even when the user says "send an email to..." — draft first, always.

---

## msgraph — Microsoft Email + Calendar

```bash
msgraph email list                           # inbox (last 20), ● = unread
msgraph email list sent                      # sent items
msgraph email read <id>                      # read message + list attachments
msgraph email draft \
  --to "addr" --subject "..." --body "..." \
  [--attach /path/to/file] \
  [--attach-url "https://..."]
msgraph email send \
  --to "addr" --subject "..." --body "..." \
  [--attach /path/to/file] \
  [--attach-url "https://..."]
msgraph email attachment <msg-id> <att-id> [--out filename]   # download attachment
msgraph email delete <id>                                     # move to Deleted Items
msgraph email delete <id> --permanent                         # permanently delete
msgraph email delete --all [--folder inbox] [--permanent]     # bulk delete (requires YES confirmation)

msgraph calendar list [days]                 # upcoming events (default: 7 days)
msgraph calendar create \
  --subject "..." \
  --start "2026-05-10T14:00:00" \
  --end   "2026-05-10T15:00:00" \
  --timezone "Europe/Berlin"
msgraph calendar delete <event-id>
```

Message IDs are long — the CLI shows a short ID (last ~14 chars) in brackets, e.g. `[ZAAI_92wMAAAAA]`. Pass the short ID directly to `email read` and `email attachment`.

---

## emctl — Gmail, GMX, and any IMAP provider

```bash
emctl list-accounts                          # show configured accounts
emctl set-default <name>                     # change default account

emctl email list                             # inbox (default account), ● = unread
emctl email list sent
emctl email list drafts
emctl email read <uid>                       # read message + list attachments
emctl email attachment <uid> <index> [--out filename]   # download by index number
emctl email delete <uid>                                # move to Trash
emctl email delete <uid> --permanent                    # permanently delete
emctl email delete --all [--folder INBOX] [--permanent] # bulk delete (requires YES confirmation)
emctl email draft \
  --to "addr" --subject "..." --body "..." \
  [--attach /path/to/file] \
  [--attach-url "https://..."]
emctl email send \
  --to "addr" --subject "..." --body "..." \
  [--attach /path/to/file] \
  [--attach-url "https://..."]

# Specific account
emctl -a gmail email list
emctl -a gmx   email list
```

`--attach` and `--attach-url` are repeatable.

---

## Handling File Attachments from Discord (or any channel)

When the user shares a file in Discord, it arrives as a CDN URL. **Download it locally first.**

**Step 1 — Download to /tmp/**
```bash
curl -L -o /tmp/<filename> "<discord_cdn_url>"
```

**Step 2 — Draft with local path**
```bash
# Microsoft
msgraph email draft --to "..." --subject "..." --body "..." --attach /tmp/<filename>
# Gmail/GMX
emctl email draft --to "..." --subject "..." --body "..." --attach /tmp/<filename>
```

**Step 3 — Show draft to user and wait for approval**
> Draft ready:
> To: ...
> Subject: ...
> Attachment: filename.pdf
>
> Send it?

**Step 4 — After approval, send**
```bash
msgraph email send --to "..." --subject "..." --body "..." --attach /tmp/<filename>
# or
emctl email send --to "..." --subject "..." --body "..." --attach /tmp/<filename>
```

**Step 5 — Clean up**
```bash
rm /tmp/<filename>
```

---

## Config locations

| Tool      | Config file                                   |
|-----------|-----------------------------------------------|
| msgraph   | `~/.config/openclaw-email/microsoft.json`     |
| emctl     | `~/.config/openclaw-email/accounts.json`      |

If msgraph fails with 401, run: `msgraph auth`
If emctl fails with "No accounts configured", run: `emctl add-account`

---

## Default timezone

Always use **Europe/Berlin** for calendar events and any date/time references unless the user specifies otherwise.
