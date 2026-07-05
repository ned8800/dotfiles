#!/bin/bash
# Проверяем, существует ли утилита в системе
if command -v plasma-apply-wallpaperimage &> /dev/null; then
    # Укажите точный путь к картинке, которая у вас синхронизируется через dotfiles
    plasma-apply-wallpaperimage "$HOME/Pictures/StarrySur_Mac-3.jpg"
fi

# Перезапуск подсистемы клавиатуры Plasma
kquitapp6 kaccess 2>/dev/null; kstart kaccess &


# применяем настройки виджетов kde
# скачиваем konsave если его нет
if ! command -v konsave &>/dev/null; then
    sudo dnf install pipx -y
     pipx ensurepath
     pipx  install konsave
     pipx inject konsave setuptools
     pipx ensurepath ;
fi

# импортируем конфиг чтобы konsave мог его читать
konsave -i "$HOME/dotfiles/kde_plasma_initial_profile_dual_monitor.knsv"
konsave -i "$HOME/dotfiles/kde_plasma_initial_profile_single_monitor.knsv"

# Считаем количество подключенных мониторов через xrandr или wlr-randr
MONITORS=$(xrandr --listmonitors | grep -c "Monitor" || echo 1)

if [ "$MONITORS" -eq 2 ]; then
    echo "Обнаружено 2 монитора. Применяю двухэкранный профиль..."
    konsave -a kde_plasma_initial_profile_dual_monitor
else
    echo "Обнаружен 1 монитор. Применяю одноэкранный профиль..."
    konsave -a kde_plasma_initial_profile_single_monitor
fi

# Перезапускаем плазму, чтобы лоток и панели обновились
kquitapp6 plasmashell && sleep 1 && kstart plasmashell &
