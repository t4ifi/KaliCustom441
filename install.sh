#!/bin/bash

# ==============================================================================
# Kali Linux Custom Setup - Installation Script
# ==============================================================================
# Script de instalación automática para configurar Kali Linux
# Autor: Adaptado para uso personal
# ==============================================================================

# Activar modo estricto de bash
set -euo pipefail  # Sale en caso de error, variables no definidas, o fallo en pipe

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Variables globales
ruta=$(pwd)
LOG_FILE="$ruta/install.log"
ERROR_LOG="$ruta/install_errors.log"
STEP_COUNTER=0
TOTAL_STEPS=20

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

# Función para mostrar progreso
step() {
    ((STEP_COUNTER++))
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ PASO [$STEP_COUNTER/$TOTAL_STEPS]: $1${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    log "STEP $STEP_COUNTER/$TOTAL_STEPS: $1"
}

# Función para manejar errores críticos
handle_error() {
    local exit_code=$?
    local line_number=$1
    local command="$2"
    
    echo -e "\n${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                    ⚠ ERROR CRÍTICO ⚠                      ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${RED}Línea: ${line_number}${NC}"
    echo -e "${RED}Código de salida: ${exit_code}${NC}"
    echo -e "${RED}Comando que falló: ${command}${NC}"
    echo -e "${RED}Paso actual: ${STEP_COUNTER}/${TOTAL_STEPS}${NC}"
    echo ""
    echo -e "${YELLOW}📋 Información del sistema:${NC}"
    echo -e "   Directorio actual: $(pwd)"
    echo -e "   Usuario: $(whoami)"
    echo -e "   Fecha: $(date)"
    echo ""
    echo -e "${YELLOW}📝 Logs guardados en:${NC}"
    echo -e "   - ${LOG_FILE}"
    echo -e "   - ${ERROR_LOG}"
    echo ""
    echo -e "${YELLOW}💡 Sugerencias:${NC}"
    echo -e "   1. Revisa el log de errores: cat ${ERROR_LOG}"
    echo -e "   2. Verifica tu conexión a internet"
    echo -e "   3. Asegúrate de tener espacio en disco: df -h"
    echo -e "   4. Verifica los repositorios: sudo apt update"
    echo -e "   5. Consulta TROUBLESHOOTING.md para soluciones comunes"
    echo ""
    
    # Guardar información del error
    {
        echo "=========================================="
        echo "ERROR CRÍTICO - $(date)"
        echo "=========================================="
        echo "Línea: $line_number"
        echo "Código de salida: $exit_code"
        echo "Comando: $command"
        echo "Paso: $STEP_COUNTER/$TOTAL_STEPS"
        echo "Directorio: $(pwd)"
        echo "Usuario: $(whoami)"
        echo "=========================================="
    } >> "$ERROR_LOG"
    
    # Preguntar si quiere continuar o salir
    echo -e "${YELLOW}¿Qué deseas hacer?${NC}"
    echo -e "  ${GREEN}1${NC}) Intentar continuar (no recomendado)"
    echo -e "  ${RED}2${NC}) Salir y revisar el error (recomendado)"
    echo ""
    read -p "Selecciona una opción (1/2): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[1]$ ]]; then
        echo -e "${RED}Instalación abortada por el usuario${NC}"
        exit $exit_code
    else
        echo -e "${YELLOW}⚠ Continuando bajo tu responsabilidad...${NC}"
        # Desactivar el modo estricto temporalmente
        set +e
    fi
}

# Función para ejecutar comandos con manejo de errores mejorado
run_cmd() {
    local cmd="$1"
    local description="$2"
    local allow_fail="${3:-false}"
    
    info "$description..."
    log "Ejecutando: $cmd"
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        success "$description completado"
        return 0
    else
        local exit_code=$?
        if [ "$allow_fail" = "true" ]; then
            warning "$description falló (permitido continuar)"
            log "WARNING: $description falló pero se permite continuar (código: $exit_code)"
            return 0
        else
            error "$description falló (código: $exit_code)"
            echo -e "${YELLOW}Comando que falló: $cmd${NC}"
            echo -e "${YELLOW}Ver detalles en: $LOG_FILE${NC}"
            return $exit_code
        fi
    fi
}

# Función para verificar si un paquete está instalado
check_package() {
    local package="$1"
    if dpkg -l | grep -q "^ii  $package "; then
        return 0
    else
        return 1
    fi
}

# Función para verificar espacio en disco
check_disk_space() {
    local required_gb=$1
    local available_gb=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
    
    if [ "$available_gb" -lt "$required_gb" ]; then
        error "Espacio insuficiente. Requerido: ${required_gb}GB, Disponible: ${available_gb}GB"
        return 1
    fi
    return 0
}

# Capturar errores y mostrar información útil
trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR

# Cleanup al salir
cleanup() {
    echo -e "\n${BLUE}Limpiando archivos temporales...${NC}"
    log "Limpieza al finalizar script"
}

# Cleanup al salir
cleanup() {
    echo -e "\n${BLUE}Limpiando archivos temporales...${NC}"
    log "Limpieza al finalizar script"
}

trap cleanup EXIT

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
log "Hostname: $(hostname)"
log "Kernel: $(uname -r)"
log "=========================================="

# Verificar que no se ejecuta como root
step "Verificación de usuario"
if [ "$(whoami)" == "root" ]; then
    error "No ejecutes este script como root. Usa tu usuario normal."
    exit 1
fi
success "Usuario correcto: $(whoami)"

# Verificar espacio en disco
step "Verificación de espacio en disco"
if ! check_disk_space 2; then
    error "Espacio en disco insuficiente"
    exit 1
fi
success "Espacio en disco suficiente"

# Verificar conexión a internet
step "Verificación de conexión a internet"
info "Verificando conexión a internet..."
if ! ping -c 1 -W 5 8.8.8.8 &> /dev/null && ! ping -c 1 -W 5 1.1.1.1 &> /dev/null; then
    error "No hay conexión a internet. Verifica tu red."
    echo -e "${YELLOW}Intenta:${NC}"
    echo -e "  - Verificar cable de red: ip link"
    echo -e "  - Conectar WiFi: nmcli device wifi connect SSID password PASSWORD"
    echo -e "  - Verificar gateway: ip route"
    exit 1
fi
success "Conexión a internet verificada"

# Verificar que estamos en el directorio correcto
step "Verificación de archivos del proyecto"
REQUIRED_FILES=("Components" ".zshrc" ".p10k.zsh" "docklike.sh")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -e "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    error "Faltan archivos necesarios en el directorio:"
    for file in "${MISSING_FILES[@]}"; do
        echo -e "  ${RED}✗${NC} $file"
    done
    echo ""
    echo -e "${YELLOW}Asegúrate de estar en el directorio correcto del repositorio${NC}"
    exit 1
fi
success "Todos los archivos necesarios presentes"

# ==============================================================================
# Inicio de instalación
# ==============================================================================

step "Actualización de repositorios"
run_cmd "sudo apt update" "Actualización de repositorios" || {
    error "Fallo al actualizar repositorios"
    echo -e "${YELLOW}Intenta:${NC}"
    echo -e "  - sudo apt update --fix-missing"
    echo -e "  - Verifica /etc/apt/sources.list"
    exit 1
}

# Instalando dependencias de Entorno
step "Instalación de dependencias del entorno"

# Instalando dependencias de Entorno
step "Instalación de dependencias del entorno"

run_cmd "sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev" "Instalación de dependencias de compilación" || exit 1

run_cmd "sudo apt install -y cmatrix" "Instalación de cmatrix" true
run_cmd "sudo apt install -y xfce4-terminal" "Instalación de xfce4-terminal" true

# Mugshot - Intentar instalar, pero permitir que falle
info "Intentando instalar mugshot (opcional)..."
if ! sudo apt install -y mugshot 2>/dev/null; then
    warning "Mugshot no disponible en repositorios, se puede instalar manualmente después"
fi

# Creando la carpeta para los temas
step "Configuración de temas"

# Creando la carpeta para los temas
step "Configuración de temas"

info "Creando directorio de temas..."
mkdir -p ~/.themes || { error "No se pudo crear ~/.themes"; exit 1; }

info "Copiando tema Everblush..."
if [ -d "$ruta/Components/GTK-XFWM-Everblush-Theme/Everblush" ]; then
    cp -r "$ruta/Components/GTK-XFWM-Everblush-Theme/Everblush" ~/.themes/ || { error "Error copiando tema Everblush"; exit 1; }
    success "Tema Everblush copiado"
else
    error "No se encontró el tema Everblush en $ruta/Components/GTK-XFWM-Everblush-Theme/"
    exit 1
fi

info "Copiando tema XFWM Everblush..."
if [ -d "$ruta/Components/GTK-XFWM-Everblush-Theme/Everblush-xfwm" ]; then
    cp -r "$ruta/Components/GTK-XFWM-Everblush-Theme/Everblush-xfwm" ~/.themes/ || { error "Error copiando tema XFWM"; exit 1; }
    success "Tema XFWM Everblush copiado"
else
    error "No se encontró el tema XFWM en $ruta/Components/GTK-XFWM-Everblush-Theme/"
    exit 1
fi

# Configurando iconos
step "Configuración de iconos"

# Configurando iconos
step "Configuración de iconos"

info "Creando directorio de iconos..."
mkdir -p ~/.local/share/icons || { error "No se pudo crear ~/.local/share/icons"; exit 1; }

info "Copiando iconos Nordzy-cyan-dark-MOD..."
if [ -d "$ruta/Components/Nordzy-cyan-dark-MOD" ]; then
    cp -r "$ruta/Components/Nordzy-cyan-dark-MOD" ~/.local/share/icons/ || { error "Error copiando iconos"; exit 1; }
    success "Iconos Nordzy-cyan-dark-MOD copiados"
else
    error "No se encontraron los iconos en $ruta/Components/Nordzy-cyan-dark-MOD"
    exit 1
fi

# Importando cursores
step "Instalación de cursores"

# Importando cursores
step "Instalación de cursores"

info "Clonando repositorio de cursores Radioactive-nord..."
if [ ! -d "Radioactive-nord" ]; then
    run_cmd "git clone https://github.com/alvatip/Radioactive-nord.git" "Clonación de Radioactive-nord" || {
        warning "No se pudo clonar repositorio de cursores, continuando..."
    }
else
    info "Radioactive-nord ya existe, omitiendo clonación"
fi

if [ -d "Radioactive-nord" ]; then
    cd Radioactive-nord || { error "No se pudo acceder al directorio Radioactive-nord"; exit 1; }
    chmod +x install.sh || { error "No se pudo dar permisos a install.sh"; exit 1; }
    ./install.sh || warning "Instalación de cursores falló, continuando..."
    success "Cursores instalados"
    cd "$ruta" || { error "No se pudo regresar al directorio $ruta"; exit 1; }
else
    warning "No se instalaron los cursores Radioactive-nord"
fi

# Instalamos paquetes adicionales
step "Instalación de paquetes adicionales"

# Instalamos paquetes adicionales
step "Instalación de paquetes adicionales"

run_cmd "sudo apt install -y kitty feh scrot scrub rofi xclip bat locate ranger wmname acpi sxhkd imagemagick" "Instalación de herramientas del sistema" || {
    error "Error instalando paquetes adicionales"
    echo -e "${YELLOW}Intentando instalar paquetes uno por uno...${NC}"
    
    PACKAGES=(kitty feh scrot scrub rofi xclip bat locate ranger wmname acpi sxhkd imagemagick)
    FAILED_PACKAGES=()
    
    for pkg in "${PACKAGES[@]}"; do
        if ! sudo apt install -y "$pkg" >> "$LOG_FILE" 2>&1; then
            warning "Paquete $pkg falló"
            FAILED_PACKAGES+=("$pkg")
        else
            success "Paquete $pkg instalado"
        fi
    done
    
    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        warning "Los siguientes paquetes no se pudieron instalar:"
        for pkg in "${FAILED_PACKAGES[@]}"; do
            echo -e "  ${YELLOW}⚠${NC} $pkg"
        done
    fi
}

# Creando carpeta de Repositorios
step "Preparación de directorios"

# Creando carpeta de Repositorios
step "Preparación de directorios"

info "Creando directorio para repositorios..."
mkdir -p "$ruta/github" || { error "No se pudo crear directorio github"; exit 1; }
success "Directorio github creado"

# Dependencias de Picom
step "Instalación de dependencias de Picom"

# Dependencias de Picom
step "Instalación de dependencias de Picom"

run_cmd "sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev" "Instalación de dependencias de Picom" || {
    error "Error instalando dependencias de Picom"
    exit 1
}

# Clonando e instalando Picom
step "Compilación e instalación de Picom"

cd "$ruta/github/" || { error "No se pudo acceder a $ruta/github/"; exit 1; }

if [ ! -d "picom" ]; then
    info "Clonando repositorio de Picom..."
    run_cmd "git clone https://github.com/ibhagwan/picom.git" "Clonación de Picom" || {
        error "Error clonando Picom"
        exit 1
    }
else
    info "Directorio picom ya existe, omitiendo clonación"
fi

cd "$ruta/github/picom" || { error "No se pudo acceder al directorio picom"; exit 1; }

cd "$ruta/github/picom" || { error "No se pudo acceder al directorio picom"; exit 1; }

info "Inicializando submódulos de Picom..."
run_cmd "git submodule update --init --recursive" "Inicialización de submódulos" || {
    error "Error inicializando submódulos de Picom"
    exit 1
}

info "Configurando Picom con Meson..."
run_cmd "meson --buildtype=release . build" "Configuración de Picom" || {
    error "Error configurando Picom con Meson"
    echo -e "${YELLOW}Verifica que meson esté instalado: meson --version${NC}"
    exit 1
}

info "Compilando Picom con Ninja..."
run_cmd "ninja -C build" "Compilación de Picom" || {
    error "Error compilando Picom"
    exit 1
}

info "Instalando Picom..."
run_cmd "sudo ninja -C build install" "Instalación de Picom" || {
    error "Error instalando Picom"
    exit 1
}

success "Picom compilado e instalado correctamente"

info "Copiando configuración de Picom..."
mkdir -p ~/.config || { error "No se pudo crear ~/.config"; exit 1; }
if [ -f "$ruta/Components/picom-config/picom.conf" ]; then
    sudo cp -r "$ruta/Components/picom-config/picom.conf" ~/.config/ || {
        error "Error copiando configuración de Picom"
        exit 1
    }
    success "Configuración de Picom copiada"
else
    warning "No se encontró picom.conf en $ruta/Components/picom-config/"
fi

cd "$ruta" || { error "No se pudo regresar al directorio $ruta"; exit 1; }

# Instalando p10k
step "Instalación de Powerlevel10k"

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
