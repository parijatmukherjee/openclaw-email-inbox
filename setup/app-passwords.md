# Getting App Passwords

All providers require an **App Password** instead of your regular account password.
App Passwords are 16-character codes generated specifically for IMAP access.

---

## Microsoft (Outlook / Live / Hotmail)

1. Go to [account.live.com/proofs/manage/additional](https://account.live.com/proofs/manage/additional)
   - Or: [account.microsoft.com](https://account.microsoft.com) → Security → Advanced security options → App passwords
2. You must have **Two-step verification** enabled first.
   - If not: Security → Two-step verification → Turn on
3. Under **App passwords**, click **Create a new app password**
4. Copy the generated 16-character password

IMAP settings:
```
IMAP host: outlook.office365.com   port: 993
SMTP host: smtp.office365.com      port: 587
```

---

## Gmail

1. Go to [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
2. You must have **2-Step Verification** enabled first.
   - If not: [myaccount.google.com/signinoptions/two-step-verification](https://myaccount.google.com/signinoptions/two-step-verification)
3. Select app: **Mail**, device: **Other (Custom name)** → enter `dobby` → **Generate**
4. Copy the 16-character password shown

IMAP settings:
```
IMAP host: imap.gmail.com    port: 993
SMTP host: smtp.gmail.com    port: 587
```

---

## GMX

GMX uses your **regular password** — no App Password needed.

You just need to enable IMAP access:
1. Log in at [mail.gmx.net](https://mail.gmx.net)
2. Settings (gear icon) → POP3 & IMAP → **Enable IMAP**
3. Save

IMAP settings:
```
IMAP host: imap.gmx.net    port: 993
SMTP host: mail.gmx.net    port: 587
```

---

## Yahoo

1. Go to [login.yahoo.com/account/security](https://login.yahoo.com/account/security)
2. Enable **2-Step Verification** if not already on
3. Go to **Generate app password** → select **Other app** → name it `dobby`
4. Copy the generated password

IMAP settings:
```
IMAP host: imap.mail.yahoo.com    port: 993
SMTP host: smtp.mail.yahoo.com    port: 587
```

---

## iCloud

1. Go to [appleid.apple.com](https://appleid.apple.com) → Sign-In and Security → App-Specific Passwords
2. Click **+** → name it `dobby` → **Create**
3. Copy the generated password

IMAP settings:
```
IMAP host: imap.mail.me.com    port: 993
SMTP host: smtp.mail.me.com    port: 587
```

---

## Fastmail

1. Go to [app.fastmail.com/settings/security/devicekeys](https://app.fastmail.com/settings/security/devicekeys)
2. Click **New App Password** → name it `dobby` → select **Mail (IMAP/POP/SMTP)**
3. Copy the generated password

IMAP settings:
```
IMAP host: imap.fastmail.com    port: 993
SMTP host: smtp.fastmail.com    port: 587
```
