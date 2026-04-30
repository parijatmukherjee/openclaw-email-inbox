INSTALL_DIR := $(HOME)/.local/bin
CONFIG_DIR  := $(HOME)/.config/openclaw-email
WORKSPACE   := $(HOME)/.openclaw/workspace

.DEFAULT_GOAL := help

# ─────────────────────────────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: help
help:
	@echo ""
	@echo "  openclaw-email-inbox — Email integration for OpenClaw"
	@echo ""
	@echo "  Quick start:"
	@echo "    make install              Install both scripts to ~/.local/bin"
	@echo "    make workspace            Copy agent docs to OpenClaw workspace"
	@echo ""
	@echo "  Account setup:"
	@echo "    make setup-microsoft      Authenticate Microsoft via OAuth2 (Graph API)"
	@echo "    make add-account          Add Gmail, GMX, or any IMAP account"
	@echo ""
	@echo "  All-in-one:"
	@echo "    make all                  install + workspace"
	@echo ""
	@echo "  Other:"
	@echo "    make check                Verify installation and accounts"
	@echo "    make accounts             List configured IMAP accounts"
	@echo "    make uninstall            Remove installed scripts"
	@echo ""
	@echo "  Note: Microsoft (Outlook/Live) requires OAuth2 — use msgraph."
	@echo "        Gmail, GMX, Yahoo, etc. use IMAP — use emctl."
	@echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Install
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: install
install:
	@echo "→ Installing scripts to $(INSTALL_DIR)"
	@mkdir -p $(INSTALL_DIR) $(CONFIG_DIR)
	@install -m 755 scripts/emctl   $(INSTALL_DIR)/emctl
	@install -m 755 scripts/msgraph $(INSTALL_DIR)/msgraph
	@echo "✓ emctl and msgraph installed."
	@echo ""
	@echo "  Make sure $(INSTALL_DIR) is in your PATH:"
	@echo "    export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo ""

.PHONY: uninstall
uninstall:
	@echo "→ Removing scripts from $(INSTALL_DIR)"
	@rm -f $(INSTALL_DIR)/emctl $(INSTALL_DIR)/msgraph
	@echo "✓ Done."

# ─────────────────────────────────────────────────────────────────────────────
# Account setup
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: setup-microsoft
setup-microsoft:
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Microsoft (Outlook / Live / Hotmail) — OAuth2 Setup"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  Microsoft blocks basic auth (including App Passwords) for IMAP."
	@echo "  msgraph uses the Microsoft Graph API with OAuth2 instead."
	@echo ""
	@echo "  You will need an Azure App registration."
	@echo "  See setup/microsoft-oauth.md for step-by-step instructions."
	@echo ""
	@msgraph auth

.PHONY: add-account
add-account:
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Add IMAP Email Account (Gmail, GMX, Yahoo, iCloud, Fastmail…)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  NOTE: Microsoft (Outlook/Live) is NOT supported here."
	@echo "        Use 'make setup-microsoft' for Microsoft accounts."
	@echo ""
	@echo "  You will need an App Password for Gmail/Yahoo/iCloud."
	@echo "  GMX and Fastmail accept your regular password."
	@echo ""
	@echo "  Gmail:    https://myaccount.google.com/apppasswords"
	@echo "  GMX:      your regular password (enable IMAP in GMX settings)"
	@echo "  Yahoo:    https://login.yahoo.com/account/security"
	@echo "  iCloud:   https://appleid.apple.com → App-Specific Passwords"
	@echo ""
	@emctl add-account

.PHONY: accounts
accounts:
	@emctl list-accounts

# ─────────────────────────────────────────────────────────────────────────────
# Workspace
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: workspace
workspace:
	@echo "→ Copying agent docs to OpenClaw workspace"
	@mkdir -p $(WORKSPACE)
	@cp workspace/TOOLS.md $(WORKSPACE)/TOOLS.md
	@echo "✓ TOOLS.md installed at $(WORKSPACE)/TOOLS.md"
	@echo "  Your OpenClaw agent will see this on the next session."

# ─────────────────────────────────────────────────────────────────────────────
# Check
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: check
check:
	@echo "Checking scripts..."
	@which msgraph  && echo "  ✓ msgraph  (Microsoft Graph API)" || echo "  ✗ msgraph  not found — run: make install"
	@which emctl    && echo "  ✓ emctl    (IMAP/SMTP)"           || echo "  ✗ emctl    not found — run: make install"
	@echo ""
	@echo "Checking Microsoft config..."
	@test -f $(CONFIG_DIR)/microsoft.json && echo "  ✓ Microsoft OAuth2 tokens present" || echo "  - Microsoft not authenticated (run: make setup-microsoft)"
	@echo ""
	@echo "Checking IMAP accounts..."
	@emctl list-accounts 2>/dev/null || echo "  No IMAP accounts configured — run: make add-account"

# ─────────────────────────────────────────────────────────────────────────────
# All
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: all
all: install workspace
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Installation complete!"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  Next — connect your email accounts:"
	@echo ""
	@echo "    make setup-microsoft   Microsoft (Outlook/Live/Hotmail)"
	@echo "    make add-account       Gmail, GMX, Yahoo, or any IMAP provider"
	@echo ""
	@echo "  Then restart your OpenClaw agent to pick up the new TOOLS.md."
	@echo ""
