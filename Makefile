.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Targets:"
	@echo "  make check-links       Validate every path reference + decisions/ status headers + root taxonomy"
	@echo "  make check-links-test  Run the guard's own fixture suite"
	@echo "  make vendor            Re-pull CLAUDE.md + .claude/settings.json from ContextEng"
	@echo "  make sync-scaffold     Report scaffold files (CI, guard, .gitignore) that drifted from groundwork"

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

# Reachability probe, for callers that must tell "upstream is down" apart from
# "vendoring failed". They cannot get that from `make vendor` exit status: GNU
# make collapses ANY recipe failure to exit 2, so the curl failure above and a
# genuine error are indistinguishable to a caller. Probe first, then vendor.
#
# Exists so the ContextEng URL stays defined once, here, rather than being
# duplicated into a workflow where it would silently drift.
.PHONY: vendor-probe
vendor-probe:
	@curl -sSf --max-time 20 -o /dev/null "$(CONTEXTENG)/CLAUDE.md"

# The scaffold blind spot. `make vendor` above keeps the CONTENT (CLAUDE.md and
# friends) current, but the MACHINERY that implements it — these workflows, the
# reference guard, the Makefile, .gitignore — is copied ONCE when a repo is
# created from groundwork and never updated again. That is how a CI bug fixed
# upstream can keep failing a project seeded months earlier: the fix never had a
# path in. This target is that path: it diffs each scaffold file against the
# current groundwork and prints what drifted.
#
# REPORT-ONLY on purpose. .gitignore and the Makefile take legitimate per-project
# edits, so blindly overwriting them would clobber real work — applying is a
# human decision. Read each diff and copy across what you actually want.
GROUNDWORK := https://raw.githubusercontent.com/skrinak/groundwork/refs/heads/main
SCAFFOLD := .github/workflows/contract-sync.yml \
            .github/workflows/docs-links.yml \
            .github/workflows/auto-vendor.yml \
            utils/check_doc_links.py \
            utils/tests/test_check_doc_links.py \
            Makefile \
            .gitignore
.PHONY: sync-scaffold
sync-scaffold:
	@drift=""; \
	for f in $(SCAFFOLD); do \
	  if ! curl -sSf --max-time 20 "$(GROUNDWORK)/$$f" -o /tmp/gw_scaffold 2>/dev/null; then \
	    echo "  unreachable  $$f (upstream missing or network down — skipped)"; \
	  elif [ ! -f "$$f" ]; then \
	    echo "  ABSENT       $$f (groundwork has it, this repo does not)"; drift="$$drift $$f"; \
	  elif cmp -s "$$f" /tmp/gw_scaffold; then \
	    echo "  in sync      $$f"; \
	  else \
	    echo "  DRIFTED      $$f"; drift="$$drift $$f"; \
	    diff -u "$$f" /tmp/gw_scaffold | sed 's/^/      /' || true; \
	  fi; \
	done; \
	rm -f /tmp/gw_scaffold; \
	if [ -n "$$drift" ]; then \
	  echo; \
	  echo "Scaffold drifted from groundwork:$$drift"; \
	  echo "Not auto-applied — review each diff above and copy across what you want."; \
	else \
	  echo; echo "Scaffold matches groundwork."; \
	fi
