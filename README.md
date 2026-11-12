# opencode-cloud-memory

Хмарне керування opencode (ПК + iPhone). Репо — єдине джерело: конфіг, пам'ять, devcontainer.

GitHub Free без картки дає **120 core-годин** Codespaces на місяць (60 годин на машині з 2 ядрами) і **15 ГБ** сховища. Після ліміту без способу оплати запуск блокується. Машину лишайте на **2 ядрах**: 4 ядра витрачають квоту вдвічі швидше. Коли закінчили — зупиніть codespace.

## Секрети Codespaces

Ключі живуть лише в секретах Codespaces, не у файлах репозиторію. Репозиторій публічний.

Додайте секрети **до** створення codespace. Якщо codespace уже працює — зупиніть його і запустіть знову, інакше нові секрети не підхопляться.

1. [Особисті секрети](https://github.com/settings/codespaces) → New secret. У **Repository access** оберіть `vak0754-cell/opencode-cloud-memory`.
2. Або [секрети цього репозиторію](https://github.com/vak0754-cell/opencode-cloud-memory/settings/secrets/codespaces).

| Секрет | Потрібен | Навіщо |
| --- | --- | --- |
| `OPENCODE_PASSWORD` | так | Пароль веб-інтерфейсу. Логін завжди `opencode`. Скрипт копіює секрет у `OPENCODE_SERVER_PASSWORD` — саме ця змінна вмикає Basic auth в OpenCode 1.19.5 |
| `DEEPSEEK_API_KEY` | так | Ключ DeepSeek для моделі за замовчуванням |
| `OPENROUTER_API_KEY` | ні | Безкоштовні моделі OpenRouter з `opencode.jsonc` |
| `GEMINI_API_KEY` | ні | Якщо підключите Gemini |
| `GROQ_API_KEY` | ні | Якщо підключите Groq |

Без `OPENCODE_PASSWORD` або `DEEPSEEK_API_KEY` сервер не стартує і порт 4096 не відкривається. Під час створення через **Code → Codespaces → New with options** GitHub покаже ці секрети внизу сторінки; вписувати необов’язкові не треба.

## iPhone — зайти з телефона

### Повернутися у свій codespace (одним тапом) ← зазвичай це
**https://github.com/codespaces/verbose-guacamole-xrv7rgqqwxx73vp9g?editor=web**

Цей codespace зібрано зі старого devcontainer. Після оновлення: Command Palette → **Codespaces: Rebuild Container**, або видаліть codespace і створіть новий. Секрети мають уже бути додані.

### Якщо codespace видалено — створити заново
https://codespaces.new/vak0754-cell/opencode-cloud-memory

Надійніше: **Code → Codespaces → New with options**, машина **2 cores**, і внизу сторінки — секрети. Список усіх codespace: https://github.com/codespaces

Після старту сам запускається `opencode web --hostname 0.0.0.0 --port 4096`. Відкрийте порт **4096** (панель Ports). Для поточного codespace:

https://verbose-guacamole-xrv7rgqqwxx73vp9g-4096.app.github.dev

Порт **приватний**. Safari спочатку може попросити вхід у GitHub, потім OpenCode — вікно Basic auth: користувач `opencode`, пароль зі секрету `OPENCODE_PASSWORD`. Якщо codespace створили заново, ім’я в адресі зміниться; візьміть свіже посилання з панелі Ports.

Якщо сторінка не відкривається, у терміналі codespace подивіться `/tmp/opencode-web.log`.

### Порада
Safari → Share → **Add to Home Screen** — додайте посилання «Повернутися» і, за бажанням, посилання на порт 4096.

Коли закінчили: на https://github.com/codespaces натисніть **Stop**. Простійний codespace GitHub і так гасить (типово за 30 хвилин), але Stop одразу звільняє core-години.

## ПК
Конфіг синхронізується скриптом `sync-from-cloud.ps1` (задача `opencode-cloud-sync-6h`, кожні 6 год). Пам'ять — через `references`. На ПК стоїть OpenCode **1.19.5**; codespace ставить ту саму V1-збірку, тож `opencode.jsonc` лишається у форматі V1.

## Файли
- `opencode.jsonc` — моделі + провайдери (deepseek-flash за замовчуванням, OpenRouter free + ★ найпотужніші)
- `MEMORY.md` — хмарна пам'ять між чатами
- `.devcontainer/devcontainer.json` — машина від 2 ядер, порт 4096 приватний, секрети Codespaces
- `.devcontainer/install-opencode.sh` — `curl -fsSL https://opencode.ai/install | bash -s -- --version 1.19.5`
- `.devcontainer/start-opencode.sh` — не стартує без пароля; `opencode web --hostname 0.0.0.0 --port 4096`
