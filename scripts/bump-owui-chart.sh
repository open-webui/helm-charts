#!/usr/bin/env bash
# Bump the open-webui Helm chart for a new Open WebUI (OWUI) release.
#
# Version mapping (OWUI is pre-1.0):
#   - OWUI minor-field bump (e.g. 0.10.x -> 0.11.0) is breaking -> chart MAJOR bump.
#   - OWUI patch-field bump (e.g. 0.11.0 -> 0.11.1)            -> chart MINOR bump.
#   - Chart PATCH is reserved for chart-only fixes; never auto-bumped here.
#   - OWUI major >= 1 (new or current) -> abort: mapping needs a human.
#
# Also inserts a CHANGELOG.md entry (with a BREAKING CHANGES note on major bumps).
#
# Usage:
#   bump-owui-chart.sh --app-version <X.Y.Z> --chart-dir <path> [--github-output <file>]
set -euo pipefail

app_version=""
chart_dir=""
github_output=""

while [ $# -gt 0 ]; do
  case "$1" in
    --app-version)   app_version="${2:-}"; shift 2 ;;
    --chart-dir)     chart_dir="${2:-}"; shift 2 ;;
    --github-output) github_output="${2:-}"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

if [ -z "${app_version}" ] || [ -z "${chart_dir}" ]; then
  echo "Usage: $0 --app-version <X.Y.Z> --chart-dir <path> [--github-output <file>]" >&2
  exit 2
fi

app_version="${app_version#v}"
if ! [[ "${app_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Expected app version like 0.11.0, got '${app_version}'" >&2
  exit 1
fi

chart_yaml="${chart_dir}/Chart.yaml"
changelog="${chart_dir}/CHANGELOG.md"
if [ ! -f "${chart_yaml}" ]; then
  echo "Chart.yaml not found at ${chart_yaml}" >&2
  exit 1
fi

current_app_version="$(awk '/^appVersion:/ { print $2; exit }' "${chart_yaml}")"
current_app_version="${current_app_version#v}"
current_app_version="${current_app_version%\"}"; current_app_version="${current_app_version#\"}"
current_chart_version="$(awk '/^version:/ { print $2; exit }' "${chart_yaml}")"
current_chart_version="${current_chart_version%\"}"; current_chart_version="${current_chart_version#\"}"

emit() {
  echo "$1"
  if [ -n "${github_output}" ]; then
    echo "$1" >> "${github_output}"
  fi
}

# Idempotent: nothing to do if already on this app version.
if [ "${current_app_version}" = "${app_version}" ]; then
  emit "skip=true"
  emit "app_version=${app_version}"
  echo "Chart already targets Open WebUI ${app_version}" >&2
  exit 0
fi

IFS='.' read -r new_major new_minor new_patch <<< "${app_version}"
IFS='.' read -r cur_major cur_minor cur_patch <<< "${current_app_version}"

is_newer() { # returns 0 if $1 > $2 (numeric semver fields)
  local a1 a2 a3 b1 b2 b3
  IFS='.' read -r a1 a2 a3 <<< "$1"
  IFS='.' read -r b1 b2 b3 <<< "$2"
  if [ "$a1" -ne "$b1" ]; then [ "$a1" -gt "$b1" ]; return; fi
  if [ "$a2" -ne "$b2" ]; then [ "$a2" -gt "$b2" ]; return; fi
  [ "$a3" -gt "$b3" ]
}

if ! is_newer "${app_version}" "${current_app_version}"; then
  echo "Refusing to bump: ${app_version} is not newer than current ${current_app_version}" >&2
  exit 1
fi

# Fail loudly once OWUI reaches >= 1.0 — the mapping policy needs a human.
if [ "${new_major}" -ge 1 ] || [ "${cur_major}" -ge 1 ]; then
  echo "Open WebUI has reached 1.x (new=${app_version}, current=${current_app_version})." >&2
  echo "The chart version mapping needs a human decision. Aborting." >&2
  exit 1
fi

# Both 0.x: OWUI minor-field change is breaking (chart major); else chart minor.
if [ "${new_minor}" -ne "${cur_minor}" ]; then
  bump_type="major"; is_breaking="true"
else
  bump_type="minor"; is_breaking="false"
fi

IFS='.' read -r c_major c_minor c_patch <<< "${current_chart_version%%[-+]*}"
if [ "${bump_type}" = "major" ]; then
  next_chart_version="$((c_major + 1)).0.0"
else
  next_chart_version="${c_major}.$((c_minor + 1)).0"
fi

# Rewrite top-level version + appVersion (indented dependency versions are safe:
# ^ anchors to column 0 under /m and the awk reads above are column-0 only).
perl -0pi -e "s/^version: .*/version: ${next_chart_version}/m; s/^appVersion: .*/appVersion: ${app_version}/m" "${chart_yaml}"

# Build the CHANGELOG entry and insert it above the first existing '## [' heading.
entry_file="$(mktemp)"
{
  echo "## [v${next_chart_version}]"
  echo ""
  echo "### Changed"
  echo "- Updated chart appVersion to v${app_version}."
  if [ "${is_breaking}" = "true" ]; then
    echo ""
    echo "### ⚠ BREAKING CHANGES"
    echo "- Open WebUI v${app_version} is a major (0.x) release and may include breaking"
    echo "  migrations. Review the upstream release notes before upgrading:"
    echo "  https://github.com/open-webui/open-webui/releases/tag/v${app_version}"
  fi
  echo ""
} > "${entry_file}"

awk -v entry_file="${entry_file}" '
  BEGIN { inserted = 0 }
  /^## \[/ && !inserted {
    while ((getline line < entry_file) > 0) print line
    inserted = 1
  }
  { print }
' "${changelog}" > "${changelog}.new"
mv "${changelog}.new" "${changelog}"
rm -f "${entry_file}"

emit "skip=false"
emit "app_version=${app_version}"
emit "chart_version=${next_chart_version}"
emit "bump_type=${bump_type}"
emit "is_breaking=${is_breaking}"
