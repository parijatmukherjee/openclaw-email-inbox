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
	@echo "    make install              Install all scripts to ~/.local/bin"
	@echo "    make setup-microsoft      Authenticate with Microsoft (Outlook/Live)"
	@echo "    make setup-gmail          Authenticate with Gmail"
	@echo "    make setup-gmx            Configure GMX / IMAP credentials"
	@echo "    make workspace            Copy agent docs to OpenClaw workspace"
	@echo ""
	@echo "  All-in-one:"
	@echo "    make all                  install + workspace (then run setup-* for each account)"
	@echo ""
	@echo "  Other:"
	@echo "    make check                Verify scripts are installed and accessible"
	@echo "    make uninstall            Remove installed scripts"
	@echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Install
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: install
install:
	@echo "→ Installing scripts to $(INSTALL_DIR)"
	@mkdir -p $(INSTALL_DIR)
	@install -m 755 scripts/msgraph  $(INSTALL_DIR)/msgraph
	@install -m 755 scripts/gmailctl $(INSTALL_DIR)/gmailctl
	@install -m 755 scripts/gmxctl   $(INSTALL_DIR)/gmxctl
	@mkdir -p $(CONFIG_DIR)
	@echo "✓ Scripts installed."
	@echo ""
	@echo "  Make sure $(INSTALL_DIR) is in your PATH:"
	@echo "    export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo ""

.PHONY: uninstall
uninstall:
	@echo "→ Removing scripts from $(INSTALL_DIR)"
	@rm -f $(INSTALL_DIR)/msgraph $(INSTALL_DIR)/gmailctl $(INSTALL_DIR)/gmxctl
	@echo "✓ Scripts removed."

# ─────────────────────────────────────────────────────────────────────────────
# Auth / Setup
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: setup-microsoft
setup-microsoft:
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Microsoft (Outlook / Live / Hotmail) Setup"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  Before you continue, make sure you have:"
	@echo "  1. An Azure App registration at https://portal.azure.com"
	@echo "     → App registrations → New registration"
	@echo "     → Supported account types: Personal Microsoft accounts"
	@echo "     → Redirect URI: http://localhost:9999/callback"
	@echo ""
	@echo "  2. API permissions added (Delegated):"
	@echo "     Mail.ReadWrite, Mail.Send, Calendars.ReadWrite"
	@echo "     → Click 'Grant admin consent' if available"
	@echo ""
	@echo "  3. A client secret created under 'Certificates & secrets'"
	@echo ""
	@echo "  See setup/microsoft.md for a detailed walkthrough."
	@echo ""
	@read -p "  Ready? Press Enter to open the browser login..." x
	@msgraph auth

.PHONY: setup-gmail
setup-gmail:
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Gmail Setup"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  Before you continue, make sure you have:"
	@echo "  1. A Google Cloud project at https://console.cloud.google.com"
	@echo "     → Create project → Enable 'Gmail API'"
	@echo ""
	@echo "  2. OAuth consent screen configured:"
	@echo "     → External → App name → Add your Gmail as a test user"
	@echo ""
	@echo "  3. OAuth credentials created:"
	@echo "     → Credentials → Create → OAuth 2.0 Client ID → Desktop app"
	@echo "     → Download client_id and client_secret"
	@echo ""
	@echo "  See setup/gmail.md for a detailed walkthrough."
	@echo ""
	@read -p "  Ready? Press Enter to open the browser login..." x
	@gmailctl auth

.PHONY: setup-gmx
setup-gmx:
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  GMX / Generic IMAP Setup"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  You will need:"
	@echo "  - Your email address (e.g. you@gmx.de)"
	@echo "  - Your GMX password"
	@echo "  - IMAP/SMTP settings (defaults pre-filled for GMX)"
	@echo ""
	@echo "  For other providers:"
	@echo "    Gmail IMAP:   imap.gmail.com:993 / smtp.gmail.com:587"
	@echo "    Yahoo:        imap.mail.yahoo.com:993 / smtp.mail.yahoo.com:587"
	@echo "    iCloud:       imap.mail.me.com:993 / smtp.mail.me.com:587"
	@echo ""
	@echo "  See setup/gmx.md for more details."
	@echo ""
	@gmxctl auth

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
	@echo "Checking installed scripts..."
	@which msgraph  && echo "  ✓ msgraph"  || echo "  ✗ msgraph  not found in PATH"
	@which gmailctl && echo "  ✓ gmailctl" || echo "  ✗ gmailctl not found in PATH"
	@which gmxctl   && echo "  ✓ gmxctl"   || echo "  ✗ gmxctl   not found in PATH"
	@echo ""
	@echo "Checking config files..."
	@test -f $(CONFIG_DIR)/microsoft.json && echo "  ✓ Microsoft tokens present" || echo "  - Microsoft not authenticated (run: make setup-microsoft)"
	@test -f $(CONFIG_DIR)/gmail.json     && echo "  ✓ Gmail tokens present"     || echo "  - Gmail not authenticated (run: make setup-gmail)"
	@test -f $(CONFIG_DIR)/gmx.json       && echo "  ✓ GMX config present"       || echo "  - GMX not configured (run: make setup-gmx)"

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
	@echo "  Next steps — authenticate your email accounts:"
	@echo ""
	@echo "    make setup-microsoft   (Outlook / Live / Hotmail)"
	@echo "    make setup-gmail       (Gmail)"
	@echo "    make setup-gmx         (GMX or any IMAP provider)"
	@echo ""
	@echo "  Then restart your OpenClaw agent to pick up the new TOOLS.md."
	@echo ""
