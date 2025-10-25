# Changelog

Todos los cambios notables en este proyecto serán documentados aquí.

## [2.0.0] - 2025-10-25

### 🎉 Nueva versión mejorada

### ✅ Correcciones Críticas
- **Corregidas rutas de Wallpaper**: Ahora usa `Components/wallpapers` correctamente
- **Eliminada duplicación de Picom**: Solo una instalación en lugar de dos
- **Corregido uso de sudo**: Removido sudo innecesario en archivos de usuario
- **Corregidas rutas en docklike.sh**: Ahora usa rutas relativas correctamente
- **Actualizado Manual.txt**: Rutas dinámicas en lugar de hardcoded `/home/kali/`
- **Agregado .p10k.zsh-root**: Archivo faltante ahora incluido

### 🆕 Nuevas Características
- **pre-check.sh**: Script de verificación pre-instalación
  - Verifica requisitos del sistema
  - Comprueba espacio en disco
  - Valida conexión a internet
  - Verifica archivos necesarios
  
- **Logging mejorado**: Sistema de logs completo
  - `install.log`: Log de instalación completa
  - `install_errors.log`: Solo errores
  - Mensajes con colores para mejor UX
  
- **Manejo de errores robusto**: Verificación en cada paso
- **Interfaz visual mejorada**: Con colores y símbolos Unicode

### 📝 Documentación
- **README.md**: Completamente reescrito
  - Estructura moderna con badges
  - Instrucciones claras
  - Sección de troubleshooting
  - Lista completa de componentes
  
- **TROUBLESHOOTING.md**: Nueva guía de solución de problemas
  - Problemas comunes y soluciones
  - Guías paso a paso
  - FAQ
  
- **LICENSE**: Archivo de licencia MIT agregado
- **.gitignore**: Agregado para ignorar logs y temporales

### 🔧 Mejoras
- Mejor organización del código
- Funciones reutilizables
- Mensajes más descriptivos
- Mejor experiencia de usuario
- Proceso más robusto

### 🐛 Correcciones de Bugs
- Carpeta `Wallpaper` no existente → Corregido a `Components/wallpapers`
- Archivo `ManualSteps.txt` no existente → Corregido a `Manual.txt`
- Comando peligroso `kill -9 -1` → Removido del script automático
- Rutas hardcoded `/home/kali/` → Cambiadas a variables dinámicas
- Uso incorrecto de `sudo` en archivos de usuario → Corregido

---

## [1.0.0] - Versión Original

### Características Iniciales
- Script básico de instalación
- Configuración de XFCE4
- Instalación de temas y componentes
- Configuración de terminal

### Problemas Conocidos
- Múltiples errores en rutas
- Duplicación de instalación de Picom
- Falta de manejo de errores
- Documentación incompleta
