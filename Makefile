.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Targets:"
	@echo "  make check-links       Validate every path reference + decisions/ status headers + root taxonomy"
	@echo "  make check-links-test  Run the guard's own fixture suite"
	@echo "  make vendor            Re-pull CLAUDE.md + .claude/settings.json from ContextEng"

# The taxonomy guard. Validates references in EVERY tracked text file — markdown
# links AND source comments — because source comments are where path references
# actually live and a docs-only linter cannot see them. Also lints decisions/
# status headers and root-markdown membership.
# Rationale: https://github.com/skrinak/ContextEng/blob/main/docs/REPOSITORY_TAXONOMY.md
.PHONY: check-links
check-links:
	uv run --no-project python3 utils/check_doc_links.py

# The guard's own guard. Do not skip this: the checker this replaced had no tests,
# which is exactly how it reported "OK" through a restructure that broke ~282 refs.
.PHONY: check-links-test
check-links-test:
	uv run --no-project --with pytest python3 -m pytest utils/tests/test_check_doc_links.py -q

# Re-vendor the contract files ContextEng owns. Run this when contract-sync
# reports drift. Never hand-edit CLAUDE.md or .claude/settings.json here — make
# the change upstream in ContextEng first, then re-vendor, because a local edit
# is silently reverted by the next run of this target.
CONTEXTENG := https://raw.githubusercontent.com/skrinak/ContextEng/refs/heads/main
.PHONY: vendor
vendor:
	@for f in CLAUDE.md .claude/settings.json env.example; do \
	  curl -sSf --max-time 20 "$(CONTEXTENG)/$$f" -o "$$f.new" \
	    && { cmp -s "$$f" "$$f.new" && echo "  unchanged  $$f" || echo "  UPDATED    $$f"; mv "$$f.new" "$$f"; } \
	    || { echo "  FAILED     $$f (upstream unreachable)"; rm -f "$$f.new"; exit 1; }; \
	done
	@echo "Re-vendored from ContextEng. Review the diff, then commit."
