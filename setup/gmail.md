# Gmail Setup

This guide walks you through connecting a Gmail account.
Estimated time: **10–15 minutes**.

---

## Step 1 — Create a Google Cloud Project

1. Go to [console.cloud.google.com](https://console.cloud.google.com).
2. Click the project dropdown at the top → **"New Project"**.
3. Give it a name like `openclaw-email` and click **"Create"**.
4. Make sure the new project is selected.

---

## Step 2 — Enable the Gmail API

1. In the left menu, go to **"APIs & Services"** → **"Library"**.
2. Search for **"Gmail API"** and click on it.
3. Click **"Enable"**.

---

## Step 3 — Configure OAuth Consent Screen

1. Go to **"APIs & Services"** → **"OAuth consent screen"**.
2. Select **"External"** and click **"Create"**.
3. Fill in:
   - **App name:** `openclaw-email`
   - **User support email:** your Gmail address
   - **Developer contact:** your Gmail address
4. Click **"Save and Continue"** through the Scopes screen (no changes needed).
5. On the **Test users** screen, click **"+ Add Users"** and add your Gmail address.
6. Click **"Save and Continue"** → **"Back to Dashboard"**.

> **Why test users?** While your app is in "testing" mode, only listed users can log in. This is fine for personal use.

---

## Step 4 — Create OAuth Credentials

1. Go to **"APIs & Services"** → **"Credentials"**.
2. Click **"+ Create Credentials"** → **"OAuth 2.0 Client ID"**.
3. Select **"Desktop app"** as the application type.
4. Give it a name (e.g. `openclaw`) and click **"Create"**.
5. A dialog will show your **Client ID** and **Client Secret** — copy both.

---

## Step 5 — Authenticate

Run:

```bash
make setup-gmail
```

Or directly:

```bash
gmailctl auth
```

You'll be prompted for your Client ID and Client Secret. A browser will open — sign in with your Gmail account and approve permissions. The terminal will confirm "Authenticated."

---

## Step 6 — Test It

```bash
gmailctl email list
gmailctl email list sent
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `Access blocked: This app's request is invalid` | Check redirect URI is `http://localhost:9999/callback` in credentials |
| `403: The caller does not have permission` | Make sure Gmail API is enabled in the project |
| Your email is not in test users | Add it under OAuth consent screen → Test users |
| `invalid_grant` | Re-run `gmailctl auth` — refresh tokens sometimes expire |
| Port 9999 already in use | `lsof -ti:9999 \| xargs kill` |

---

## Config Location

Tokens are stored at `~/.config/openclaw-email/gmail.json` (permissions: `600`).
