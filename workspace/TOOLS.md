# TOOLS.md — Email Inbox for OpenClaw

This workspace gives your OpenClaw agent access to email and calendar
across Microsoft (Outlook/Live/Hotmail), Gmail, and GMX / generic IMAP.

---

## Available Commands

### Microsoft (Outlook / Live / Hotmail)

```
msgraph auth                                    # first-time login
msgraph email list                              # inbox (last 20)
msgraph email list sent                         # sent items
msgraph email read <id>                         # read a message
msgraph email draft --to addr --subject "..." --body "..."   # save draft
msgraph email send  --to addr --subject "..." --body "..."   # send email
msgraph calendar list                           # next 7 days
msgraph calendar list 14                        # next 14 days
msgraph calendar create --subject "..." --start "2026-05-01T10:00:00" --end "2026-05-01T11:00:00" --timezone "Europe/Berlin"
msgraph calendar delete <id>
```

### Gmail

```
gmailctl auth                                   # first-time login
gmailctl email list                             # inbox (last 20)
gmailctl email list sent                        # sent items
gmailctl email read <id>                        # read a message
gmailctl email draft --to addr --subject "..." --body "..."
gmailctl email send  --to addr --subject "..." --body "..."
```

### GMX / Generic IMAP

```
gmxctl auth                                     # first-time setup (saves credentials)
gmxctl email list                               # inbox (last 20)
gmxctl email list sent                          # sent items
gmxctl email read <uid>                         # read a message
gmxctl email draft --to addr --subject "..." --body "..."
gmxctl email send  --to addr --subject "..." --body "..."
```

---

## Email Rules (Agent)

**Always draft before sending. Never send without explicit human approval.**

1. When asked to send an email — prepare the draft (To, Subject, Body) and show it to the user.
2. Wait for explicit approval: "yes", "send it", "approved", or similar.
3. Only send after clear confirmation.
4. If edited or rejected, update draft and ask again.

This applies even when the user explicitly says "send an email" — draft first, always.

---

## Config Files

| Provider  | Config Path                               |
|-----------|-------------------------------------------|
| Microsoft | `~/.config/openclaw-email/microsoft.json` |
| Gmail     | `~/.config/openclaw-email/gmail.json`     |
| GMX/IMAP  | `~/.config/openclaw-email/gmx.json`       |

All config files are stored with `chmod 600` (owner-read-only).
