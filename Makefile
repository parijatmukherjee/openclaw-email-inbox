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
	@echo "    make install       Install emctl to ~/.local/bin"
	@echo "    make add-account   Add an email account interactively"
	@echo "    make workspace     Copy agent docs to OpenClaw workspace"
	@echo ""
	@echo "  All-in-one:"
	@echo "    make all           install + workspace (then run make add-account)"
	@echo ""
	@echo "  Other:"
	@echo "    make check         Verify emctl is installed and accounts are configured"
	@echo "    make accounts      List configured accounts"
	@echo "    make uninstall     Remove emctl from PATH"
	@echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Install
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: install
install:
	@echo "→ Installing emctl to $(INSTALL_DIR)"
	@mkdir -p $(INSTALL_DIR) $(CONFIG_DIR)
	@install -m 755 scripts/emctl $(INSTALL_DIR)/emctl
	@echo "✓ emctl installed."
	@echo ""
	@echo "  Make sure $(INSTALL_DIR) is in your PATH:"
	@echo "    export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo ""

.PHONY: uninstall
uninstall:
	@echo "→ Removing emctl from $(INSTALL_DIR)"
	@rm -f $(INSTALL_DIR)/emctl
	@echo "✓ Done."

# ─────────────────────────────────────────────────────────────────────────────
# Account setup
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: add-account
add-account:
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Add Email Account"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  You will need an App Password for your account."
	@echo "  (App Passwords work even if your normal password doesn't)"
	@echo ""
	@echo "  Microsoft: https://account.live.com/proofs/manage/additional"
	@echo "             Settings → Security → App passwords"
	@echo ""
	@echo "  Gmail:     https://myaccount.google.com/apppasswords"
	@echo "             (Requires 2-Step Verification to be enabled)"
	@echo ""
	@echo "  GMX:       Use your regular GMX password"
	@echo "             (enable IMAP at mail.gmx.net → Settings → POP3/IMAP)"
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
	@echo "Checking emctl..."
	@which emctl && echo "  ✓ emctl found in PATH" || echo "  ✗ emctl not found — run: make install"
	@echo ""
	@emctl list-accounts 2>/dev/null || echo "  No accounts configured — run: make add-account"

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
	@echo "  Next — add your email accounts:"
	@echo ""
	@echo "    make add-account   (run once per email account)"
	@echo ""
	@echo "  Then restart your OpenClaw agent to pick up the new TOOLS.md."
	@echo ""
