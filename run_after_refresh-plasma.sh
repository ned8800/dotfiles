#!/bin/bash

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
CYAN='\033[0;36m' #Cyan color
NC='\033[0m'     # Reset to normal colors



# Перезапуск подсистемы клавиатуры Plasma для применения раскладок клавиатуры
kquitapp6 kaccess 2>/dev/null && sleep 1 && kstart kaccess 2>/dev/null && sleep 1


# применяем настройки виджетов kde
# скачиваем konsave если его нет
if ! command -v konsave &>/dev/null; then

    echo -e "${CYAN} konsave is not installed, installing pipx and konsave to the system. ${NC}"

    sudo dnf install pipx -y
    pipx ensurepath
    pipx  install konsave
    pipx inject konsave setuptools
    pipx ensurepath ;
fi

# импортируем конфиг чтобы konsave мог его читать
echo -e "${CYAN} applying the KDE saved config files for konsave. ${NC}"

konsave -i "$HOME/dotfiles/kde_plasma_initial_profile_dual_monitor.knsv"
konsave -i "$HOME/dotfiles/kde_plasma_initial_profile_single_monitor.knsv"

# Считаем количество подключенных мониторов через xrandr или wlr-randr
MONITORS=$(xrandr --listmonitors | grep -c "Monitor" || echo 1)

if [ "$MONITORS" -eq 2 ]; then
    echo -e "${CYAN} 2 monitors have been detected. Using a two-screen profile... ${NC}"
    konsave -a kde_plasma_initial_profile_dual_monitor
else
    echo -e "${CYAN} 1 monitor have been detected. Using a one-screen profile... ${NC}"
    konsave -a kde_plasma_initial_profile_single_monitor
fi

# Перезапускаем плазму, чтобы лоток и панели обновились
kquitapp6 plasmashell && sleep 1 && kstart plasmashell && sleep 3

until qdbus-qt6 org.kde.plasmashell /MainApplication org.freedesktop.DBus.Peer.Ping 2>/dev/null ; do
    echo -e "${CYAN} waiting for Plasma to reload... ${NC}"
    sleep 0.5
done

echo -e "${CYAN} Plasma successfully reloaded ${NC}"


# применяем  обои
echo -e "${CYAN} applying wallpapers... ${NC}"

# Проверяем, существует ли утилита в системе
if command -v plasma-apply-wallpaperimage &> /dev/null; then
    # Укажите точный путь к картинке, которая у вас синхронизируется через dotfiles
    plasma-apply-wallpaperimage "$HOME/Pictures/StarrySur_Mac-3.jpg"
fi

echo -e "${GREEN} KDE settings successfully applied. You are good to go! ${NC}"
