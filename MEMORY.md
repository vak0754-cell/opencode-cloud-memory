# Хмарна пам'ять OpenCode

Стислий опис поточного налаштування. Сесії: `C:/Users/Roma/OpenCode-Workspace`.

## Моделі
- Основна: `myy/deepseek-v4-pro`
- Мала / швидка: `deepseek-flash/deepseek-flash`

## MCP
- `context7` — увімкнено (`https://mcp.context7.com/mcp`)
- `grep-app` — увімкнено (`https://mcp.grep.app`)
- `browser-control` — вимкнено

## Команди та агенти
- Команди: `/review`, `/commit`, `/explain`, `/duo`, `/pharmacy`
- Агент: `reviewer`

## Синхронізація
- `sync-from-cloud.ps1` підставляє `model` / `small_model` і провайдерів лише якщо їх немає локально; наявні не перезаписує.

## Правила
- `snapshot`: false
- `lsp`: false
- `logLevel`: ERROR
