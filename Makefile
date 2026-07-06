PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin
CODEX_HOME ?= $(HOME)/.codex
SKILLS_DIR ?= $(CODEX_HOME)/skills

ROOT := $(CURDIR)
COMMANDS := spawn tell jump mesh
SKILL_NAME := codex-mesh
SKILL_SRC := $(ROOT)/skills/$(SKILL_NAME)
SKILL_DEST := $(SKILLS_DIR)/$(SKILL_NAME)

.PHONY: doctor verify check-deps check-runtime-deps check-verify-deps install install-bin install-skill uninstall

doctor:
	@./scripts/mesh doctor

verify: check-verify-deps
	./scripts/verify.sh

check-runtime-deps:
	@for cmd in bash python3 jq git bd kitty codex; do \
		command -v "$$cmd" >/dev/null 2>&1 || { echo "missing dependency: $$cmd" >&2; exit 1; }; \
	done

check-verify-deps:
	@for cmd in bash python3 jq git cue bd; do \
		command -v "$$cmd" >/dev/null 2>&1 || { echo "missing dependency: $$cmd" >&2; exit 1; }; \
	done

check-deps: check-runtime-deps check-verify-deps

install: check-runtime-deps install-bin install-skill

install-bin:
	@mkdir -p "$(BINDIR)"
	@for cmd in $(COMMANDS); do \
		src="$(ROOT)/scripts/$$cmd"; \
		dest="$(BINDIR)/$$cmd"; \
		if [ -e "$$dest" ] && [ ! -L "$$dest" ]; then \
			echo "refusing to replace non-symlink: $$dest" >&2; \
			exit 1; \
		fi; \
		ln -sfn "$$src" "$$dest"; \
		echo "linked $$dest -> $$src"; \
	done

install-skill:
	@mkdir -p "$(SKILLS_DIR)"
	@if [ -e "$(SKILL_DEST)" ] && [ ! -L "$(SKILL_DEST)" ]; then \
		echo "refusing to replace non-symlink skill: $(SKILL_DEST)" >&2; \
		exit 1; \
	fi
	@ln -sfn "$(SKILL_SRC)" "$(SKILL_DEST)"
	@echo "linked $(SKILL_DEST) -> $(SKILL_SRC)"

uninstall:
	@for cmd in $(COMMANDS); do \
		dest="$(BINDIR)/$$cmd"; \
		if [ -L "$$dest" ] && [ "$$(readlink "$$dest")" = "$(ROOT)/scripts/$$cmd" ]; then \
			rm -f "$$dest"; \
			echo "removed $$dest"; \
		fi; \
	done
	@if [ -L "$(SKILL_DEST)" ] && [ "$$(readlink "$(SKILL_DEST)")" = "$(SKILL_SRC)" ]; then \
		rm -f "$(SKILL_DEST)"; \
		echo "removed $(SKILL_DEST)"; \
	fi
