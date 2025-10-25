# Kali Linux Custom Setup 🐉

[![Kali Linux](https://img.shields.io/badge/Kali-Linux-557C94?style=for-the-badge&logo=kalilinux&logoColor=white)](https://www.kali.org/)
[![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

## 📋 Descripción

Script de configuración automática para Kali Linux que transforma tu entorno en un sistema estético y eficiente. Este proyecto reúne componentes de múltiples configuraciones tanto para la consola como para la interfaz gráfica XFCE4.

## ✨ Características

- 🎨 **Tema Everblush personalizado** - Interfaz GTK y XFWM
- 🖼️ **Iconos Nordzy Cyan Dark** - Pack de iconos moderno
- 🖱️ **Cursores Radioactive Nord** - Cursores animados
- 💻 **Kitty Terminal** - Terminal GPU-acelerada
- 🐚 **ZSH + Powerlevel10k** - Shell moderna y personalizada
- 📊 **Picom compositor** - Efectos de transparencia y sombras
- 🎯 **Rofi launcher** - Lanzador de aplicaciones estilizado
- 📈 **Panel XFCE4 customizado** - Con monitores de sistema
- 🔒 **i3lock-color** - Pantalla de bloqueo personalizada
- 📱 **EWW sidebar** - Widget de información del sistema
- 🎪 **Docklike plugin** - Vista previa de ventanas en el panel
- 🖼️ **Wallpapers customizados** - Colección de fondos de pantalla

## 🚀 Instalación Rápida

```bash
git clone https://github.com/t4ifi/KaliCustom441.git
cd KaliCustom441
chmod +x install.sh
chmod +x docklike.sh
./install.sh
```

> **⚠️ IMPORTANTE:** Después de la instalación, abre el archivo `~/ManualSteps.txt` y sigue los pasos de configuración manual.

## 📦 Requisitos Previos

- Kali Linux (probado en versiones recientes)
- Entorno de escritorio XFCE4
- Conexión a internet estable
- Al menos 2GB de espacio libre en disco
- Usuario con privilegios sudo

## 🛠️ Componentes Instalados

### Terminal y Shell
- **Kitty** - Terminal moderna
- **ZSH** - Shell avanzada
- **Powerlevel10k** - Tema para ZSH
- **Plugins ZSH:**
  - zsh-syntax-highlighting
  - zsh-autosuggestions
  - zsh-sudo

### Herramientas del Sistema
- **Picom** - Compositor con efectos
- **Rofi** - Lanzador de aplicaciones
- **Neofetch** - Información del sistema
- **lsd** - Comando ls mejorado
- **bat** - Comando cat mejorado
- **feh** - Visor de imágenes
- **scrot** - Captura de pantalla

### Interfaz Gráfica
- **Tema Everblush** - GTK y XFWM
- **Iconos Nordzy Cyan Dark**
- **Cursores Radioactive Nord**
- **Docklike Panel Plugin**
- **LightDM personalizado**

## 📖 Pasos Post-Instalación

Después de ejecutar el script, necesitas completar algunos pasos manualmente:

1. **Configurar LightDM** - Tema e iconos
2. **Ajustar wallpapers** - Desde `~/.local/share/wallpapers`
3. **Configurar docklike** - Plugin del panel
4. **Ajustar rutas** - En archivos de configuración del panel
5. **Activar eww sidebar** - Con `Shift + S`

Ver `~/ManualSteps.txt` para instrucciones detalladas.

## 🎨 Vista Previa

## 🎨 Vista Previa

### Escritorio Principal
![Desktop](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/DESK.PNG)

### Pantalla de Bloqueo
![Lockscreen](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/lockscreen.PNG)

### Logout
![Logout](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/logout.PNG)

### Login Personalizado
![Custom Login](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/custom%20login.PNG)

### Sidebar
![Sidebar](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/Sidebar.PNG)

### Wallpapers
![Wallpapers](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/wallpapers.PNG)

### Cursor Personalizado
![Mouse](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/mouse.PNG)

### Vista General
![Preview](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/preview.PNG)

### Terminal Shell
![Shell](https://github.com/t4ifi/KaliCustom441/blob/main/Preview/shell.PNG)

## 🤝 Créditos

Este proyecto es una recopilación y mejora de configuraciones de múltiples fuentes:

- [mehedirm6244](https://github.com/mehedirm6244) - Configuraciones base
- [LinuxScoop](https://github.com/linuxscoop) - Temas y componentes
- [xJackSx](https://github.com/xJackSx/) - Configuraciones XFCE
- [Mr.Pr1ngl3s](https://github.com/MrPr1ngl3s) - Scripts y utilidades
- [S4vitar](https://github.com/s4vitar) - Inspiración y herramientas
- [ZLCube](https://github.com/zlcube) - Proyecto original base

## 🐛 Solución de Problemas

### El script falla durante la instalación
```bash
# Verifica que tienes todas las dependencias
sudo apt update
sudo apt upgrade
```

### Picom no inicia automáticamente
```bash
# Añádelo manualmente a autostart
echo "picom &" >> ~/.config/autostart/picom.desktop
```

### Los iconos no se muestran correctamente
```bash
# Reconstruye la caché de iconos
gtk-update-icon-cache ~/.local/share/icons/Nordzy-cyan-dark-MOD
```

### El panel XFCE no se ve bien
```bash
# Reinicia el panel
xfce4-panel -r
```

## 📝 Notas Importantes

- ⚠️ **Backup recomendado**: Haz respaldo de tus configuraciones antes de ejecutar el script
- 🔧 **Personalización**: Puedes modificar los archivos de configuración en `~/.config/`
- 📦 **Espacio en disco**: Se requieren ~2GB para todos los componentes
- ⏱️ **Tiempo de instalación**: Aproximadamente 15-30 minutos dependiendo de tu conexión

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🌟 Contribuciones

Las contribuciones son bienvenidas! Si encuentras algún error o tienes sugerencias:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add: AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

Si tienes problemas o preguntas:
- 🐛 Abre un [Issue](https://github.com/t4ifi/KaliCustom441/issues)
- 💬 Consulta el archivo `Manual.txt` o `TROUBLESHOOTING.md`
- 📧 Contacta al mantenedor

---

⭐ Si te gusta este proyecto, dale una estrella en GitHub!

**Hecho con ❤️ para la comunidad de Kali Linux**


