#!/usr/bin/env bash
# OpenCode 1.19.5 — the same V1 line as the desktop app that owns opencode.jsonc.
# Official installer (refuses 2.x): https://opencode.ai/install
#   curl -fsSL https://opencode.ai/install | bash -s -- --version 1.19.5
# npm package for this line is opencode-ai (not @opencode/cli, which is V2).
# Binary lands in $HOME/.opencode/bin.
set -euo pipefail
export PATH="${HOME}/.opencode/bin:${PATH}"

curl -fsSL https://opencode.ai/install | bash -s -- --version 1.19.5

export PATH="${HOME}/.opencode/bin:${PATH}"
if ! command -v opencode >/dev/null 2>&1; then
  echo "Офіційний інсталятор не поклав opencode у PATH; запасний варіант: npm opencode-ai@1.19.5." >&2
  npm install -g opencode-ai@1.19.5
fi

version="$(opencode --version)"
echo "Installed OpenCode ${version}"
case "${version}" in
  1.19.5*) ;;
  *)
    echo "Очікувався OpenCode 1.19.5, отримано: ${version}." >&2
    exit 1
    ;;
esac
