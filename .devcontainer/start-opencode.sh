#!/usr/bin/env bash
# V1 browser UI (OpenCode 1.19.5):
#   https://opencode.ai/docs/web/
#   opencode web --hostname 0.0.0.0 --port 4096
# Password: OPENCODE_SERVER_PASSWORD. Username: OPENCODE_SERVER_USERNAME
# (default opencode). `opencode serve` on this version is the headless API
# and does not serve the Safari page.
#
# Codespaces secret name is OPENCODE_PASSWORD. Same-named secrets
# (DEEPSEEK_API_KEY and the optional provider keys) are already exported
# into lifecycle scripts; this file only renames the password.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${root}"
export PATH="${HOME}/.opencode/bin:${PATH}"
export OPENCODE_SERVER_USERNAME=opencode

if [[ -z "${OPENCODE_SERVER_PASSWORD:-}" && -n "${OPENCODE_PASSWORD:-}" ]]; then
  export OPENCODE_SERVER_PASSWORD="${OPENCODE_PASSWORD}"
fi

stop_web() {
  pkill -f "[o]pencode web" >/dev/null 2>&1 || true
}

if [[ -z "${OPENCODE_SERVER_PASSWORD:-}" ]]; then
  echo "OpenCode не запустився: пароль не задано." >&2
  echo "Додайте секрет Codespaces OPENCODE_PASSWORD." >&2
  echo "Його буде скопійовано в OPENCODE_SERVER_PASSWORD (так V1 вмикає Basic auth, логін opencode)." >&2
  echo "https://github.com/settings/codespaces" >&2
  # Do not stop a server that is already rejecting anonymous requests.
  if pgrep -f "[o]pencode web" >/dev/null 2>&1; then
    existing="$(curl -s -o /dev/null -w '%{http_code}' --max-time 2 http://127.0.0.1:4096/ || true)"
    if [[ "${existing}" != "401" && "${existing}" != "000" ]]; then
      echo "Зупиняю вже запущений opencode web, бо він не вимагає пароль (HTTP ${existing})." >&2
      stop_web
    fi
  fi
  exit 1
fi

if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  echo "OpenCode не запустився: немає DEEPSEEK_API_KEY." >&2
  echo "Додайте цей секрет Codespaces. Необов’язкові: OPENROUTER_API_KEY, GEMINI_API_KEY, GROQ_API_KEY." >&2
  echo "https://github.com/settings/codespaces" >&2
  exit 1
fi

if ! command -v opencode >/dev/null 2>&1; then
  echo "opencode немає в PATH. Перевірте postCreate / install-opencode.sh." >&2
  exit 1
fi

if ! opencode web --help >/dev/null 2>&1; then
  echo "Ця збірка OpenCode не має команди \`opencode web\`." >&2
  exit 1
fi

if pgrep -f "[o]pencode web" >/dev/null 2>&1; then
  existing="$(curl -s -o /dev/null -w '%{http_code}' --max-time 2 http://127.0.0.1:4096/ || true)"
  if [[ "${existing}" == "401" ]]; then
    echo "OpenCode вже слухає порт 4096 і вимагає пароль."
    exit 0
  fi
  echo "Знайдено процес opencode web без пароля (HTTP ${existing}). Зупиняю його." >&2
  stop_web
  sleep 1
fi

: > /tmp/opencode-web.log
setsid opencode web --hostname 0.0.0.0 --port 4096 > /tmp/opencode-web.log 2>&1 < /dev/null &
disown || true
echo "Запуск: opencode web --hostname 0.0.0.0 --port 4096 (лог: /tmp/opencode-web.log)"

for _ in $(seq 1 30); do
  code="$(curl -s -o /dev/null -w '%{http_code}' --max-time 2 http://127.0.0.1:4096/ || true)"
  if [[ "${code}" == "401" ]]; then
    echo "OpenCode слухає 0.0.0.0:4096 і відхиляє запити без пароля."
    exit 0
  fi
  if [[ -n "${code}" && "${code}" != "000" ]]; then
    echo "Порт 4096 відповів HTTP ${code} без пароля. Очікувався 401. Зупиняю сервер." >&2
    stop_web
    exit 1
  fi
  if ! pgrep -f "[o]pencode web" >/dev/null 2>&1; then
    echo "opencode web завершився під час старту. Лог:" >&2
    cat /tmp/opencode-web.log >&2 || true
    exit 1
  fi
  sleep 1
done

echo "opencode web не відкрив порт 4096 за 30 с. Лог:" >&2
cat /tmp/opencode-web.log >&2 || true
stop_web
exit 1
