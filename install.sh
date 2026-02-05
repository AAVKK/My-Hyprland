#!/bin/bash

echo "--- Начинаю установку твоей сборки Hyprland ---"

# 1. Обновление системы
sudo pacman -Syu --noconfirm

# 2. Установка помощника AUR (yay), если его нет
if ! command -v yay &> /dev/null; then
    echo "Устанавливаю yay..."
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd -
fi

# 3. Установка основных пакетов из твоего списка
echo "Устанавливаю официальные пакеты..."
sudo pacman -S --needed - < ~/dotfiles/pkglist.txt --noconfirm

# 4. Установка пакетов из AUR
if [ -f ~/dotfiles/aur_pkglist.txt ]; then
    echo "Устанавливаю AUR пакеты..."
    yay -S --needed - < ~/dotfiles/aur_pkglist.txt --noconfirm
fi

# 5. Копирование конфигов
echo "Копирую конфиги в ~/.config..."
mkdir -p ~/.config
cp -rf ~/dotfiles/config/.config/* ~/.config/

# 6. Копирование тем, иконок и шрифтов
echo "Восстанавливаю темы и шрифты..."
cp -rf ~/dotfiles/home/.icons ~/ 2>/dev/null
cp -rf ~/dotfiles/home/.themes ~/ 2>/dev/null
mkdir -p ~/.local/share/fonts
cp -rf ~/dotfiles/home/fonts/* ~/.local/share/fonts/ 2>/dev/null

# 7. Обновление кэша шрифтов
fc-cache -fv

echo "--- Установка завершена! Перезагрузись или заходи в Hyprland ---"
