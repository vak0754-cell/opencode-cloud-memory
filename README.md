# opencode-cloud-memory

Хмарне керування opencode (ПК + iPhone). Репо — єдине джерело: конфіг, пам'ять, devcontainer.

## iPhone — зайти з телефона

### Повернутися у свій codespace (одним тапом) ← зазвичай це
**https://github.com/codespaces/verbose-guacamole-xrv7rgqqwxx73vp9g?editor=web**

### Якщо codespace видалено — створити заново
https://codespaces.new/vak0754-cell/opencode-cloud-memory

Список усіх codespace: https://github.com/codespaces

Після старту `opencode web` запускається сам. Відкрий порт **4096**:
https://verbose-guacamole-xrv7rgqqwxx73vp9g-4096.app.github.dev

### Порада
Safari → Share → **Add to Home Screen** — додай посилання «Повернутися».

## ПК
Конфіг синхронізується скриптом `sync-from-cloud.ps1` (задача `opencode-cloud-sync-6h`, кожні 6 год). Пам'ять — через `references`.

## Файли
- `opencode.jsonc` — моделі + провайдери (deepseek-flash за замовчуванням, OpenRouter free + ★ найпотужніші)
- `MEMORY.md` — хмарна пам'ять між чатами
- `.devcontainer/devcontainer.json` — авто-встановлення й авто-запуск opencode web
