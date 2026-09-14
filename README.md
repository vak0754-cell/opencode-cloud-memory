# opencode-cloud-memory

Хмарне керування opencode (ПК + iPhone). Репо — єдине джерело: конфіг, пам'ять, devcontainer.

## Зайти з телефона (один тап)
Відкрий на iPhone:

**https://codespaces.new/vak0754-cell/opencode-cloud-memory**

Codespace підніметься, `opencode web` запуститься автоматично. Відкрий порт **4096** → працюєш.

### Порада
Safari → Share → **Add to Home Screen** — буде іконка, як застосунок.

## ПК
Конфіг синхронізується скриптом `sync-from-cloud.ps1` (автоматично за розкладом). Пам'ять доступна через `references`.

## Файли
- `opencode.jsonc` — моделі + провайдери (deepseek-flash, OpenRouter free)
- `MEMORY.md` — хмарна пам'ять між чатами
- `.devcontainer/devcontainer.json` — авто-запуск opencode web
