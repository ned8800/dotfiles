#!/bin/bash
# Проверяем, существует ли утилита в системе
if command -v plasma-apply-wallpaperimage &> /dev/null; then
    # Укажите точный путь к картинке, которая у вас синхронизируется через dotfiles
    plasma-apply-wallpaperimage "$HOME/Pictures/StarrySur_Mac-3.jpg"
fi

# Перезапуск подсистемы клавиатуры Plasma
kquitapp6 kaccess 2>/dev/null; kstart kaccess &

