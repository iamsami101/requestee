#!/usr/bin/env bash
#
# requesT — verification harness
#
# Automates a full smoke test of the frontend + "backend" (the mock agents):
#   1. static analysis (flutter analyze)
#   2. formatting check (dart format --set-exit-if-changed)
#   3. unit tests (classifier / matcher / app_store)
#   4. widget smoke tests (the full Post → Match → Book → Confirm → Rate flow)
#
# Usage:
#   ./tool/verify.sh            # run everything
#   ./tool/verify.sh --quick    # analyze + unit tests only (no widget tests)
#
# Exit code 0 on success, non-zero on any failure.

set -euo pipefail

cd "$(dirname "$0")/.."

QUICK=0
if [[ "${1:-}" == "--quick" ]]; then
  QUICK=1
fi

pass() { printf '  \033[32m✓ %s\033[0m\n' "$1"; }
fail() { printf '  \033[31m✗ %s\033[0m\n' "$1"; }

echo "── requesT verification harness ─────────────────────────"

# 1. Static analysis ---------------------------------------------------------
echo ""
echo "▸ flutter analyze"
if flutter analyze; then
  pass "analysis clean"
else
  fail "analysis found issues"
  exit 1
fi

# 2. Formatting --------------------------------------------------------------
echo ""
echo "▸ dart format --set-exit-if-changed"
if dart format --output=none --set-exit-if-changed lib test >/dev/null 2>&1; then
  pass "code is formatted"
else
  fail "code needs formatting (run: dart format lib test)"
  exit 1
fi

# 3. Unit tests (mock agents / backend) -------------------------------------
echo ""
echo "▸ unit tests (classifier, matcher, app_store)"
if flutter test test/classifier_test.dart test/matcher_test.dart test/app_store_test.dart; then
  pass "unit tests passed"
else
  fail "unit tests failed"
  exit 1
fi

# 4. Widget smoke tests (frontend flow) -------------------------------------
if [[ "$QUICK" -eq 0 ]]; then
  echo ""
  echo "▸ widget smoke tests (post → match → book → confirm → rate)"
  if flutter test test/smoke_test.dart; then
    pass "widget smoke tests passed"
  else
    fail "widget smoke tests failed"
    exit 1
  fi
fi

echo ""
echo "── All checks passed. ───────────────────────────────────"