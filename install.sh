#!/bin/bash

# ==============================================================================
# Kali Linux Custom Setup - Installation Script
# ==============================================================================
# Script de instalación automática para configurar Kali Linux
# Autor: Adaptado para uso personal
# ==============================================================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables globales
ruta=$(pwd)
LOG_FILE="$ruta/install.log"
ERROR_LOG="$ruta/install_errors.log"

# ==============================================================================
# Funciones de utilidad
# ==============================================================================

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Función para mensajes de error
error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$ERROR_LOG"
}

# Función para mensajes de éxito
success() {
    echo -e "${GREEN}✓ $1${NC}"
    log "SUCCESS: $1"
}

# Función para mensajes de información
info() {
    echo -e "${BLUE}ℹ $1${NC}"
    log "INFO: $1"
}

# Función para mensajes de advertencia
warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    log "WARNING: $1"
}

# Función para ejecutar comandos con logging
run_cmd() {
    local cmd="$1"
    local description="$2"
    
    info "$description..."
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        success "$description completado"
        return 0
    else
        error "$description falló"
        return 1
    fi
}

# ==============================================================================
# Verificaciones iniciales
# ==============================================================================

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║       Kali Linux Custom Setup - Instalación              ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Iniciar logging
log "=========================================="
log "Iniciando instalación"
log "Usuario: $(whoami)"
log "Directorio: $ruta"
log "=========================================="

# Verificar que no se ejecuta como root
if [ "$(whoami)" == "root" ]; then
    error "No ejecutes este script como root. Usa tu usuario normal."
    exit 1
fi

success "Usuario correcto: $(whoami)"

# Verificar conexión a internet
info "Verificando conexión a internet..."
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    error "No hay conexión a internet"
    exit 1
fi
success "Conexión a internet verificada"

# ==============================================================================
# Inicio de instalación
# ==============================================================================

info "Actualizando repositorios..."
sudo apt update >> "$LOG_FILE" 2>&1 || warning "Actualización de repositorios tuvo advertencias"

# Instalando dependencias de Entorno

sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev
sudo apt install -y cmatrix
sudo apt install -y mugshot xfce4-terminal

# Creando la carpeta para los temas

mkdir ~/.themes 
cp -r $ruta/Components/GTK-XFWM-Everblush-Theme/Everblush ~/.themes/ 
cp -r $ruta/Components/GTK-XFWM-Everblush-Theme/Everblush-xfwm ~/.themes/

# Configurando iconos

mkdir ~/.local/share/icons
cp -r $ruta/Components/Nordzy-cyan-dark-MOD ~/.local/share/icons 

# Importando cursores

git clone https://github.com/alvatip/Radioactive-nord.git 
cd Radioactive-nord 
chmod +x install.sh 
./install.sh
echo "cursores instalados"
cd ~/KaliSetup

# Instalamos paquetes adionales

sudo apt install -y kitty feh scrot scrub rofi xclip bat locate ranger wmname acpi sxhkd imagemagick

# Creando carpeta de Reposistorios

cd $ruta
mkdir $ruta/github

# Dependencias de Picom

sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev

cd $ruta/github/
git clone https://github.com/ibhagwan/picom.git

# Instalando Picom
cd $ruta/github/picom

git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

sudo cp -r $ruta/Components/picom-config/picom.conf ~/.config/

# Instalando p10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Instalando p10k root

sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k

# Configuramos el tema Nord de Rofi:

mkdir -p ~/.config/rofi/themes
cp $ruta/rofi/nord.rasi ~/.config/rofi/themes/

# Instando lsd

sudo dpkg -i $ruta/lsd.deb

# Instalamos las HackNerdFonts

sudo cp -v $ruta/fonts/HNF/* /usr/local/share/fonts/

# Instalando Wallpapers

mkdir -p ~/Wallpaper
cp -v $ruta/Components/wallpapers/* ~/Wallpaper 2>/dev/null || echo "Wallpapers copiados desde carpeta alternativa"
mkdir -p ~/ScreenShots

# Copiando Archivos de Configuración

cp -rv $ruta/Config/* ~/.config/
sudo cp -rv $ruta/kitty /opt/

# Copia de configuracion de .p10k.zsh y .zshrc

rm -rf ~/.zshrc
cp -v $ruta/.zshrc ~/.zshrc

cp -v $ruta/.p10k.zsh ~/.p10k.zsh
sudo cp -v $ruta/.p10k.zsh-root /root/.p10k.zsh

# Script

sudo cp -v $ruta/scripts/whichSystem.py /usr/local/bin/
sudo cp -v $ruta/scripts/screenshot /usr/local/bin/

# Plugins ZSH

sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions
sudo mkdir /usr/share/zsh-sudo
cd /usr/share/zsh-sudo
sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# Cambiando de SHELL a zsh

sudo ln -s -fv ~/.zshrc /root/.zshrc

# Asignamos Permisos a los Scritps

chmod +x ~/.config/bin/ethernet_status.sh
chmod +x ~/.config/bin/htb_status.sh
chmod +x ~/.config/bin/htb_target.sh
chmod +x ~/.config/polybar/launch.sh
sudo chmod +x /usr/local/bin/whichSystem.py
sudo chmod +x /usr/local/bin/screenshot

#Installing fonts 

cp -r $ruta/Components/fonts ~/.local/share

#Installing Kvantum themes

sudo apt install -y qt5-style-kvantum qt5-style-kvantum-themes

cp -r $ruta/Components/Kvantum ~/.config

# Wallpaper folder

cp -r $ruta/Components/wallpapers ~/.local/share

# Lightdm login manager 

cd ~/.themes 
sudo cp -R Everblush /usr/share/themes/

cd ~/.local/share/icons
sudo cp -Rv Nordzy-cyan-dark-MOD /usr/share/icons


# Nota: Picom ya fue instalado anteriormente (línea 43-54)
# Se elimina duplicación para evitar conflictos

cd $ruta

# xfce4 setup

xfce4-panel --quit
pkill xfconfd
cp -R $ruta/Components/home-config/.assets ~/
[ -f ~/.profile ] && mv ~/.profile ~/.profile-00
cp -R $ruta/Components/home-config/.profile ~/
cp -R $ruta/Components/home-config/.Xresources ~/
mkdir -p ~/.config/gtk-3.0/
cp -R $ruta/Components/gtk-3.0/gtk.css ~/.config/gtk-3.0/
cp -R $ruta/Components/xfce4-config/genmon-scripts ~/
[ -d ~/.config/xfce4 ] && mv ~/.config/xfce4 ~/.config/xfce4-00 
cp -R $ruta/Components/xfce4-config/xfce4 ~/.config/

# Docklike-plugin

cd $ruta
chmod +x docklike.sh
./docklike.sh
cd $ruta

# Findex

sudo apt install -y libkeybinder-3.0-dev
cd $ruta
git clone https://github.com/mdgaziur/findex.git
cd findex
sudo ./installer.sh

# i3lock

sudo apt install -y i3lock-color
cd $ruta
sudo cp -R $ruta/Components/i3lock-color-everblush/i3lock-everblush /usr/bin
xfconf-query --create -c xfce4-session -p /general/LockCommand -t string -s "i3lock-everblush"

# Neofetch

sudo apt install -y neofetch
[ -d ~/.config/neofetch ] && rm -rf ~/.config/neofetch
cp -R $ruta/Components/neofetch ~/.config/

# EWW widget

sudo apt install -y alsa-utils brightnessctl jq playerctl
cd $ruta
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
git clone https://github.com/elkowar/eww 
cd eww
cargo build --release 
sudo mv target/release/eww /usr/bin
sudo cp -R $ruta/Components/eww ~/.config/

# Mensaje de Instalado

notify-send "Kali configurado - Instalación completada"
cp $ruta/Manual.txt ~/ManualSteps.txt


# Final steps (Manual Settings)
echo ""
echo "========================================="
echo "   INSTALACIÓN COMPLETADA CON ÉXITO"
echo "========================================="
echo ""
echo "⚠️  IMPORTANTE: Abre el archivo ~/ManualSteps.txt y sigue los pasos manuales"
echo ""
cat ~/ManualSteps.txt
echo ""
echo "========================================="
echo "Para aplicar todos los cambios, reinicia tu sesión con: kill -9 -1"
echo "O reinicia el sistema manualmente"
echo "========================================="

xfce4-panel & 
