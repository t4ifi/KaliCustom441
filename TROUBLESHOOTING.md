# 🔧 Guía de Solución de Problemas

## Índice
1. [Problemas durante la instalación](#problemas-durante-la-instalación)
2. [Problemas después de la instalación](#problemas-después-de-la-instalación)
3. [Problemas con componentes específicos](#problemas-con-componentes-específicos)
4. [Desinstalación](#desinstalación)

---

## Problemas durante la instalación

### ❌ Error: "No ejecutes este script como root"
**Problema:** El script no debe ejecutarse con `sudo` o como usuario root.

**Solución:**
```bash
# Ejecuta como usuario normal (NO uses sudo)
chmod +x install.sh
./install.sh
```

---

### ❌ Error: "No hay conexión a internet"
**Problema:** El script requiere internet para descargar paquetes y repositorios.

**Solución:**
```bash
# Verifica tu conexión
ping -c 4 google.com

# Si usas WiFi, conéctate primero
nmcli device wifi list
nmcli device wifi connect SSID password PASSWORD
```

---

### ❌ Error: "Espacio insuficiente en disco"
**Problema:** Se requieren al menos 2GB de espacio libre.

**Solución:**
```bash
# Verifica el espacio disponible
df -h

# Limpia archivos innecesarios
sudo apt clean
sudo apt autoremove
```

---

### ❌ Error durante la compilación de Picom
**Problema:** Faltan dependencias o errores de compilación.

**Solución:**
```bash
# Instala todas las dependencias necesarias
sudo apt install -y meson ninja-build libxext-dev libxcb1-dev \
    libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev \
    libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev \
    libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev \
    libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev \
    libpcre2-dev libevdev-dev uthash-dev libev-dev

# Intenta compilar manualmente
cd github/picom
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
```

---

### ❌ Error al instalar Rust para eww
**Problema:** La instalación de Rust falla o se interrumpe.

**Solución:**
```bash
# Instala Rust manualmente
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Verifica la instalación
rustc --version
cargo --version
```

---

## Problemas después de la instalación

### ❌ El tema no se aplica correctamente
**Problema:** Los colores o el tema no se ven como en las previews.

**Solución:**
```bash
# Aplica el tema manualmente
xfconf-query -c xsettings -p /Net/ThemeName -s "Everblush"
xfconf-query -c xfwm4 -p /general/theme -s "Everblush-xfwm"

# Reinicia el panel
xfce4-panel -r
```

---

### ❌ Los iconos no se muestran
**Problema:** Los iconos del sistema no aparecen.

**Solución:**
```bash
# Verifica que los iconos estén instalados
ls ~/.local/share/icons/Nordzy-cyan-dark-MOD

# Aplica el tema de iconos
xfconf-query -c xsettings -p /Net/IconThemeName -s "Nordzy-cyan-dark-MOD"

# Reconstruye la caché
gtk-update-icon-cache ~/.local/share/icons/Nordzy-cyan-dark-MOD
```

---

### ❌ Picom no inicia al login
**Problema:** El compositor no se ejecuta automáticamente.

**Solución:**
```bash
# Crea el archivo de autostart
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/picom.desktop << EOF
[Desktop Entry]
Type=Application
Name=Picom
Exec=picom
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# O agrega a .zshrc
echo "picom &" >> ~/.zshrc
```

---

### ❌ La terminal muestra caracteres raros
**Problema:** Los iconos de Nerd Fonts no se muestran correctamente.

**Solución:**
```bash
# Verifica que las fuentes estén instaladas
fc-list | grep -i "nerd"

# Reinstala las fuentes
sudo cp -v fonts/HNF/* /usr/local/share/fonts/
fc-cache -fv
```

---

### ❌ ZSH no es el shell por defecto
**Problema:** Todavía se abre bash en lugar de zsh.

**Solución:**
```bash
# Cambia el shell por defecto
chsh -s $(which zsh)

# Cierra sesión y vuelve a entrar
# O ejecuta zsh manualmente
zsh
```

---

## Problemas con componentes específicos

### 🔧 Docklike Plugin

**Problema:** El plugin no aparece en el panel.

**Solución:**
```bash
# Ejecuta el script de docklike
cd KaliSetupBeta
chmod +x docklike.sh
./docklike.sh

# Reinicia el panel
xfce4-panel -r

# Añade el plugin manualmente:
# Click derecho en panel → Panel → Preferencias → Items → Añadir (+) → Docklike
```

---

### 🔧 EWW Sidebar

**Problema:** El sidebar no se abre con Shift+S.

**Solución:**
```bash
# Verifica que eww esté instalado
which eww

# Prueba abrir manualmente
eww open --toggle sidebar

# Verifica sxhkd
pgrep -x sxhkd || sxhkd &

# Verifica la configuración de atajos
cat ~/.config/sxhkd/sxhkdrc
```

---

### 🔧 Neofetch personalizado

**Problema:** Neofetch no muestra el logo personalizado.

**Solución:**
```bash
# Verifica la configuración
cat ~/.config/neofetch/config.conf

# Ejecuta neofetch para ver errores
neofetch
```

---

### 🔧 i3lock personalizado

**Problema:** La pantalla de bloqueo es la estándar.

**Solución:**
```bash
# Verifica que i3lock-color esté instalado
which i3lock

# Prueba el lock personalizado
i3lock-everblush

# Si no funciona, verifica el script
cat /usr/bin/i3lock-everblush
```

---

## Desinstalación

### 🗑️ Revertir configuraciones

Si quieres volver a tu configuración anterior:

```bash
# Restaurar configuraciones respaldadas
[ -f ~/.zshrc-00 ] && mv ~/.zshrc-00 ~/.zshrc
[ -d ~/.config/xfce4-00 ] && rm -rf ~/.config/xfce4 && mv ~/.config/xfce4-00 ~/.config/xfce4
[ -f ~/.p10k.zsh-00 ] && mv ~/.p10k.zsh-00 ~/.p10k.zsh

# Cambiar shell a bash
chsh -s /bin/bash

# Reiniciar el panel
xfce4-panel -r

# Cerrar sesión y volver a entrar
kill -9 -1
```

---

### 🗑️ Desinstalar paquetes

Para eliminar los paquetes instalados:

```bash
# Desinstalar picom
sudo apt remove picom

# Desinstalar kitty
sudo apt remove kitty

# Desinstalar otros paquetes
sudo apt remove rofi feh scrot neofetch i3lock-color

# Limpiar paquetes no necesarios
sudo apt autoremove
```

---

## Preguntas Frecuentes

### ❓ ¿Puedo instalar solo algunos componentes?
Sí, puedes editar `install.sh` y comentar (con `#`) las secciones que no quieras instalar.

### ❓ ¿Funciona en otras distribuciones?
El script está optimizado para Kali Linux con XFCE4. Puede funcionar en Debian/Ubuntu pero no está garantizado.

### ❓ ¿Cómo actualizo los componentes?
Ejecuta `git pull` en cada repositorio clonado en `github/` y recompila si es necesario.

### ❓ ¿Dónde están los logs?
Los logs se guardan en:
- `install.log` - Log general
- `install_errors.log` - Solo errores

---

## 📞 Obtener más ayuda

Si ninguna de estas soluciones funciona:

1. Revisa los logs: `cat install.log` y `cat install_errors.log`
2. Abre un issue en GitHub con:
   - Descripción del problema
   - Logs relevantes
   - Versión de Kali Linux
   - Pasos para reproducir

---

**💡 Consejo:** Haz un snapshot o backup de tu sistema antes de hacer cambios importantes.
