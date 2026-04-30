# Microsoft (Outlook / Live / Hotmail) Setup

This guide walks you through connecting your Microsoft personal email account.
Estimated time: **5–10 minutes**.

---

## Step 1 — Create an Azure App

1. Go to [portal.azure.com](https://portal.azure.com) and sign in with **any** Microsoft account
   (doesn't have to be the mailbox you want to connect).

2. Search for **"App registrations"** in the top search bar and click it.

3. Click **"+ New registration"**.

4. Fill in:
   - **Name:** `openclaw-email` (or anything you like)
   - **Supported account types:** select **"Personal Microsoft accounts only"**
   - **Redirect URI:** choose **Web** and enter: `http://localhost:9999/callback`

5. Click **Register**.

6. You'll land on the app overview page. Copy your **Application (client) ID** — you'll need it shortly.

---

## Step 2 — Add API Permissions

1. In the left menu, click **"API permissions"**.
2. Click **"+ Add a permission"** → **"Microsoft Graph"** → **"Delegated permissions"**.
3. Search for and add:
   - `Mail.ReadWrite`
   - `Mail.Send`
   - `Calendars.ReadWrite`
4. Click **"Add permissions"**.

> **Note:** You don't need to click "Grant admin consent" for personal accounts — the user will consent during login.

---

## Step 3 — Create a Client Secret

1. In the left menu, click **"Certificates & secrets"**.
2. Click **"+ New client secret"**.
3. Give it a description (e.g. `openclaw`) and choose an expiry (24 months is fine).
4. Click **"Add"**.
5. **Copy the secret value immediately** — it won't be shown again.

---

## Step 4 — Authenticate

Run:

```bash
make setup-microsoft
```

Or directly:

```bash
msgraph auth
```

A browser window will open. Sign in with the Microsoft account whose mailbox you want to access. Approve the permissions. The browser will show "Auth complete." and the terminal will confirm tokens are saved.

---

## Step 5 — Test It

```bash
msgraph email list
msgraph calendar list
```

You should see your inbox and upcoming calendar events.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `redirect_uri_mismatch` | Make sure the redirect URI in Azure exactly matches `http://localhost:9999/callback` |
| `AADSTS65001: consent required` | Re-run `msgraph auth` and approve permissions in the browser |
| `401 Unauthorized` after a while | Tokens expire — run `msgraph auth` again to refresh |
| Port 9999 already in use | Kill the process: `lsof -ti:9999 \| xargs kill` |

---

## Config Location

Tokens are stored at `~/.config/openclaw-email/microsoft.json` (permissions: `600`).
