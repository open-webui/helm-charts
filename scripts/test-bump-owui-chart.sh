#!/usr/bin/env bash
# Pure-bash test suite for bump-owui-chart.sh (no bats/shellcheck required).
# Runnable on bash 3.2 (macOS) and bash 5 (CI).
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUMP="${SCRIPT_DIR}/bump-owui-chart.sh"
failures=0
tests=0

make_fixture() {
  # $1 = appVersion, $2 = chart version. Prints the temp chart dir path.
  local dir
  dir="$(mktemp -d)"
  cat > "${dir}/Chart.yaml" <<EOF
apiVersion: v2
name: open-webui
version: $2
appVersion: $1
dependencies:
  - name: ollama
    version: ">=0.24.0"
EOF
  cat > "${dir}/CHANGELOG.md" <<EOF

# Changelog

All notable changes to the Open WebUI Helm chart will be documented in this file.

## [v$2]

### Changed
- Updated chart appVersion to v$1.
EOF
  echo "${dir}"
}

pass() { echo "  PASS: $1"; tests=$((tests + 1)); }
fail() { echo "  FAIL: $1"; tests=$((tests + 1)); failures=$((failures + 1)); }

assert_contains() { # haystack needle msg
  if [[ "$1" == *"$2"* ]]; then pass "$3"; else fail "$3 (missing '$2' in output)"; fi
}
assert_not_contains() { # haystack needle msg
  if [[ "$1" != *"$2"* ]]; then pass "$3"; else fail "$3 (unexpected '$2' in output)"; fi
}
assert_file_contains() { # file needle msg
  if grep -qF -- "$2" "$1"; then pass "$3"; else fail "$3 (missing '$2' in $1)"; fi
}
assert_file_not_contains() { # file needle msg
  if ! grep -qF -- "$2" "$1"; then pass "$3"; else fail "$3 (unexpected '$2' in $1)"; fi
}

echo "TEST: minor OWUI bump (0.11.0 -> 0.11.1) => chart minor (16.0.0 -> 16.1.0)"
dir="$(make_fixture 0.11.0 16.0.0)"
out="$("${BUMP}" --app-version 0.11.1 --chart-dir "${dir}" 2>/dev/null)"; rc=$?
[ "${rc}" -eq 0 ] && pass "exit 0" || fail "exit 0 (got ${rc})"
assert_contains "${out}" "skip=false" "emits skip=false"
assert_contains "${out}" "chart_version=16.1.0" "chart bumps to 16.1.0"
assert_contains "${out}" "bump_type=minor" "bump_type=minor"
assert_contains "${out}" "is_breaking=false" "is_breaking=false"
assert_file_contains "${dir}/Chart.yaml" "version: 16.1.0" "Chart.yaml version rewritten"
assert_file_contains "${dir}/Chart.yaml" "appVersion: 0.11.1" "Chart.yaml appVersion rewritten"
assert_file_contains "${dir}/Chart.yaml" 'version: ">=0.24.0"' "dependency version untouched"
assert_file_contains "${dir}/CHANGELOG.md" "## [v16.1.0]" "changelog new heading"
assert_file_contains "${dir}/CHANGELOG.md" "Updated chart appVersion to v0.11.1." "changelog appVersion line"
assert_file_not_contains "${dir}/CHANGELOG.md" "BREAKING CHANGES" "no breaking note on minor"
rm -rf "${dir}"

echo "TEST: major OWUI bump (0.10.2 -> 0.11.0) => chart major (15.2.0 -> 16.0.0)"
dir="$(make_fixture 0.10.2 15.2.0)"
out="$("${BUMP}" --app-version 0.11.0 --chart-dir "${dir}" 2>/dev/null)"; rc=$?
[ "${rc}" -eq 0 ] && pass "exit 0" || fail "exit 0 (got ${rc})"
assert_contains "${out}" "chart_version=16.0.0" "chart bumps to 16.0.0"
assert_contains "${out}" "bump_type=major" "bump_type=major"
assert_contains "${out}" "is_breaking=true" "is_breaking=true"
assert_file_contains "${dir}/Chart.yaml" "version: 16.0.0" "Chart.yaml version rewritten"
assert_file_contains "${dir}/Chart.yaml" "appVersion: 0.11.0" "Chart.yaml appVersion rewritten"
assert_file_contains "${dir}/CHANGELOG.md" "## [v16.0.0]" "changelog new heading"
assert_file_contains "${dir}/CHANGELOG.md" "BREAKING CHANGES" "breaking note present on major"
assert_file_contains "${dir}/CHANGELOG.md" "releases/tag/v0.11.0" "breaking note links release"
rm -rf "${dir}"

echo "TEST: equal version => skip, no file changes"
dir="$(make_fixture 0.11.0 16.0.0)"
before="$(cat "${dir}/Chart.yaml")"
out="$("${BUMP}" --app-version 0.11.0 --chart-dir "${dir}" 2>/dev/null)"; rc=$?
[ "${rc}" -eq 0 ] && pass "exit 0 on skip" || fail "exit 0 on skip (got ${rc})"
assert_contains "${out}" "skip=true" "emits skip=true"
[ "$(cat "${dir}/Chart.yaml")" = "${before}" ] && pass "Chart.yaml unchanged on skip" || fail "Chart.yaml unchanged on skip"
rm -rf "${dir}"

echo "TEST: OWUI >= 1.0 aborts (new >= 1.0)"
dir="$(make_fixture 0.11.0 16.0.0)"
"${BUMP}" --app-version 1.0.0 --chart-dir "${dir}" >/dev/null 2>&1; rc=$?
[ "${rc}" -ne 0 ] && pass "non-zero exit on OWUI 1.0.0" || fail "non-zero exit on OWUI 1.0.0 (got ${rc})"
rm -rf "${dir}"

echo "TEST: OWUI >= 1.0 aborts (current >= 1.0)"
dir="$(make_fixture 1.0.0 16.0.0)"
"${BUMP}" --app-version 1.1.0 --chart-dir "${dir}" >/dev/null 2>&1; rc=$?
[ "${rc}" -ne 0 ] && pass "non-zero exit when current is 1.x" || fail "non-zero exit when current is 1.x (got ${rc})"
rm -rf "${dir}"

echo "TEST: downgrade aborts"
dir="$(make_fixture 0.11.0 16.0.0)"
"${BUMP}" --app-version 0.10.5 --chart-dir "${dir}" >/dev/null 2>&1; rc=$?
[ "${rc}" -ne 0 ] && pass "non-zero exit on downgrade" || fail "non-zero exit on downgrade (got ${rc})"
rm -rf "${dir}"

echo "TEST: malformed version aborts"
dir="$(make_fixture 0.11.0 16.0.0)"
"${BUMP}" --app-version 0.11 --chart-dir "${dir}" >/dev/null 2>&1; rc=$?
[ "${rc}" -ne 0 ] && pass "non-zero exit on malformed input" || fail "non-zero exit on malformed input (got ${rc})"
rm -rf "${dir}"

echo "TEST: leading v is tolerated (v0.11.1 == 0.11.1)"
dir="$(make_fixture 0.11.0 16.0.0)"
out="$("${BUMP}" --app-version v0.11.1 --chart-dir "${dir}" 2>/dev/null)"; rc=$?
[ "${rc}" -eq 0 ] && pass "exit 0 with leading v" || fail "exit 0 with leading v (got ${rc})"
assert_contains "${out}" "app_version=0.11.1" "strips leading v"
rm -rf "${dir}"

echo ""
echo "Ran ${tests} assertions, ${failures} failure(s)."
[ "${failures}" -eq 0 ]
