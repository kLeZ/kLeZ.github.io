#!/bin/bash
# SessionStart hook for Claude Code on the web.
# Prepares the Jekyll toolchain so `jekyll doctor` (lint), `jekyll build`
# and `htmlproofer` (tests) work out of the box in a remote session.
set -euo pipefail

# Only run in the remote (Claude Code on the web) environment. Local machines
# are assumed to already have the developer's own setup.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# --- Ruby version -----------------------------------------------------------
# The project pins Ruby 3.2.x (.ruby-version says 3.2.3). Jekyll 3.9.x is
# incompatible with Ruby 3.3+ (logger API change), and the container ships
# Ruby 3.2.6 via rbenv, so we pin to that for the whole session.
RUBY_VERSION_TO_USE="3.2.6"
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - bash)"
  export RBENV_VERSION="$RUBY_VERSION_TO_USE"
fi

# A UTF-8 locale is required, otherwise Nokogiri (used by html-proofer) reads
# the UTF-8 pages as US-ASCII and silently checks 0 links.
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"

echo "Using Ruby: $(ruby --version)"

# --- Git submodules (Jekyll plugins) ----------------------------------------
git submodule update --init --recursive

# --- Ruby gems --------------------------------------------------------------
# Vendor the gems locally; this directory is cached with the container, so a
# plain `bundle install` (not `bundle ci`) reuses it on subsequent runs.
bundle config set --local path 'vendor/bundle'
bundle install

# --- Persist environment for the rest of the session ------------------------
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export RBENV_VERSION=\"$RUBY_VERSION_TO_USE\""
    echo "export LANG=\"C.UTF-8\""
    echo "export LC_ALL=\"C.UTF-8\""
  } >> "$CLAUDE_ENV_FILE"
fi

echo "Session setup complete: gems installed, submodules ready."
