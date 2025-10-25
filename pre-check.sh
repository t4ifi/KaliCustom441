#!/bin/bash

# ==============================================================================
# Pre-Installation Check Script
# ==============================================================================
# Este script verifica que el sistema cumple con los requisitos necesarios
# antes de ejecutar la instalación completa
# ==============================================================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
ERRORS=0
WARNINGS=0
SUCCESS=0

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Kali Linux Setup - Pre-Installation Check          ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ==============================================================================
# Verificación 1: Usuario no es root
# ==============================================================================
echo -e "${YELLOW}[1/10]${NC} Verificando usuario..."
if [ "$(whoami)" == "root" ]; then
    echo -e "${RED}   ✗ ERROR: No ejecutes este script como root${NC}"
    ((ERRORS++))
else
    echo -e "${GREEN}   ✓ Usuario correcto: $(whoami)${NC}"
    ((SUCCESS++))
fi

# ==============================================================================
# Verificación 2: Sistema operativo
# ==============================================================================
echo -e "${YELLOW}[2/10]${NC} Verificando sistema operativo..."
if grep -qi "kali" /etc/os-release 2>/dev/null; then
    echo -e "${GREEN}   ✓ Kali Linux detectado${NC}"
    ((SUCCESS++))
else
    echo -e "${YELLOW}   ⚠ ADVERTENCIA: No se detectó Kali Linux${NC}"
    echo -e "      El script puede no funcionar correctamente en otras distribuciones"
    ((WARNINGS++))
fi

# ==============================================================================
# Verificación 3: Entorno de escritorio XFCE4
# ==============================================================================
echo -e "${YELLOW}[3/10]${NC} Verificando entorno de escritorio..."
if command -v xfce4-panel &> /dev/null; then
    echo -e "${GREEN}   ✓ XFCE4 instalado${NC}"
    ((SUCCESS++))
else
    echo -e "${RED}   ✗ ERROR: XFCE4 no está instalado${NC}"
    echo -e "      Este script está diseñado para XFCE4"
    ((ERRORS++))
fi

# ==============================================================================
# Verificación 4: Privilegios sudo
# ==============================================================================
echo -e "${YELLOW}[4/10]${NC} Verificando privilegios sudo..."
if sudo -n true 2>/dev/null; then
    echo -e "${GREEN}   ✓ Privilegios sudo disponibles${NC}"
    ((SUCCESS++))
else
    echo -e "${YELLOW}   ⚠ ADVERTENCIA: Es necesario ingresar contraseña sudo${NC}"
    ((WARNINGS++))
fi

# ==============================================================================
# Verificación 5: Conexión a internet
# ==============================================================================
echo -e "${YELLOW}[5/10]${NC} Verificando conexión a internet..."
if ping -c 1 8.8.8.8 &> /dev/null || ping -c 1 google.com &> /dev/null; then
    echo -e "${GREEN}   ✓ Conexión a internet disponible${NC}"
    ((SUCCESS++))
else
    echo -e "${RED}   ✗ ERROR: No hay conexión a internet${NC}"
    ((ERRORS++))
fi

# ==============================================================================
# Verificación 6: Espacio en disco
# ==============================================================================
echo -e "${YELLOW}[6/10]${NC} Verificando espacio en disco..."
AVAILABLE_SPACE=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -ge 2 ]; then
    echo -e "${GREEN}   ✓ Espacio disponible: ${AVAILABLE_SPACE}GB${NC}"
    ((SUCCESS++))
else
    echo -e "${RED}   ✗ ERROR: Espacio insuficiente (${AVAILABLE_SPACE}GB)${NC}"
    echo -e "      Se requieren al menos 2GB de espacio libre"
    ((ERRORS++))
fi

# ==============================================================================
# Verificación 7: Git instalado
# ==============================================================================
echo -e "${YELLOW}[7/10]${NC} Verificando Git..."
if command -v git &> /dev/null; then
    echo -e "${GREEN}   ✓ Git instalado ($(git --version | awk '{print $3}'))${NC}"
    ((SUCCESS++))
else
    echo -e "${RED}   ✗ ERROR: Git no está instalado${NC}"
    echo -e "      Ejecuta: sudo apt install -y git"
    ((ERRORS++))
fi

# ==============================================================================
# Verificación 8: Compilador y herramientas de construcción
# ==============================================================================
echo -e "${YELLOW}[8/10]${NC} Verificando herramientas de compilación..."
if command -v gcc &> /dev/null && command -v make &> /dev/null; then
    echo -e "${GREEN}   ✓ Herramientas de compilación disponibles${NC}"
    ((SUCCESS++))
else
    echo -e "${YELLOW}   ⚠ ADVERTENCIA: build-essential no instalado completamente${NC}"
    echo -e "      Se instalará durante el proceso"
    ((WARNINGS++))
fi

# ==============================================================================
# Verificación 9: Archivos del repositorio
# ==============================================================================
echo -e "${YELLOW}[9/10]${NC} Verificando archivos del proyecto..."
MISSING_FILES=0
REQUIRED_FILES=(
    "install.sh"
    "docklike.sh"
    "Components/wallpapers"
    "Components/fonts"
    "Components/xfce4-config"
    ".zshrc"
    ".p10k.zsh"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -e "$file" ]; then
        echo -e "${RED}      ✗ Falta: $file${NC}"
        ((MISSING_FILES++))
    fi
done

if [ $MISSING_FILES -eq 0 ]; then
    echo -e "${GREEN}   ✓ Todos los archivos necesarios presentes${NC}"
    ((SUCCESS++))
else
    echo -e "${RED}   ✗ ERROR: Faltan $MISSING_FILES archivos necesarios${NC}"
    ((ERRORS++))
fi

# ==============================================================================
# Verificación 10: Backup de configuraciones existentes
# ==============================================================================
echo -e "${YELLOW}[10/10]${NC} Verificando configuraciones existentes..."
CONFIG_EXISTS=0
[ -f ~/.zshrc ] && ((CONFIG_EXISTS++)) && echo -e "${YELLOW}      ⚠ ~/.zshrc existe${NC}"
[ -d ~/.config/xfce4 ] && ((CONFIG_EXISTS++)) && echo -e "${YELLOW}      ⚠ ~/.config/xfce4 existe${NC}"
[ -f ~/.p10k.zsh ] && ((CONFIG_EXISTS++)) && echo -e "${YELLOW}      ⚠ ~/.p10k.zsh existe${NC}"

if [ $CONFIG_EXISTS -gt 0 ]; then
    echo -e "${YELLOW}   ⚠ Se crearán backups de configuraciones existentes${NC}"
    ((WARNINGS++))
else
    echo -e "${GREEN}   ✓ No hay configuraciones que respaldar${NC}"
    ((SUCCESS++))
fi

# ==============================================================================
# Resumen
# ==============================================================================
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                   Resumen de Verificación                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}   Exitosos:     $SUCCESS${NC}"
echo -e "${YELLOW}   Advertencias: $WARNINGS${NC}"
echo -e "${RED}   Errores:      $ERRORS${NC}"
echo ""

# ==============================================================================
# Decisión final
# ==============================================================================
if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ✗ NO SE PUEDE CONTINUAR - Errores encontrados           ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo -e "${RED}Corrige los errores antes de ejecutar install.sh${NC}"
    echo ""
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  ⚠ ADVERTENCIAS DETECTADAS                               ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Se puede continuar, pero revisa las advertencias${NC}"
    echo ""
    read -p "¿Deseas continuar con la instalación? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        echo -e "${YELLOW}Instalación cancelada por el usuario${NC}"
        exit 0
    fi
else
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ SISTEMA LISTO PARA INSTALACIÓN                        ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Puedes ejecutar ./install.sh para comenzar${NC}"
    echo ""
    exit 0
fi
