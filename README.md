## 🛠️ Arch Maintenance Script

Un script ligero, modular y seguro diseñado para automatizar las tareas de mantenimiento esenciales en **Arch Linux**, siguiendo la filosofía KISS.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=arch-linux)](https://archlinux.org/)

## 🚀 Características

Este script automatiza los puntos críticos de mantenimiento recomendados por la [Arch Wiki](https://wiki.archlinux.org/title/System_maintenance):

- **Actualización del Sistema:** Sincroniza repositorios y actualiza paquetes.
- **Limpieza de Huérfanos:** Elimina dependencias que ya no son necesarias (`pacman -Rns`).
- **Optimización de Caché:** Limpia versiones antiguas de paquetes manteniendo solo las últimas 2 (vía `paccache`).
- **Detección de Conflictos:** Identifica archivos `.pacnew` y `.pacsave` pendientes de revisión.
- **Gestión de Logs:** Limpia el `journald` para liberar espacio en disco (mantiene las últimas 2 semanas).
- **Auditoría de Servicios:** Reporta servicios de `systemd` que hayan fallado.

## 📦 Requisitos

El script utiliza herramientas nativas, pero requiere el paquete `pacman-contrib` para la gestión inteligente de la caché:

```bash
sudo pacman -S pacman-contrib
```

## 💻 Instalación y Uso

Clona el repositorio:
    
```bash
git clone [https://github.com/TU_USUARIO/arch-maintenance-script.git](https://github.com/TU_USUARIO/arch-maintenance-script.git)
cd arch-maintenance-script
```

Dale permisos de ejecución:

```bash
chmod +x arch-cleaner.sh
```

Ejecútalo con privilegios de root:

```bash
sudo ./arch-cleaner.sh
```

## ⚠️ Advertencia

Aunque este script es seguro, Arch Linux es un sistema centrado en el usuario.

    Revisa siempre los archivos .pacnew detectados manualmente.

    Asegúrate de tener una conexión a internet estable antes de iniciar la actualización.

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Si tienes una idea para mejorar la limpieza o añadir una funcionalidad (como soporte para AUR/Yay), siéntete libre de abrir un Pull Request o un Issue.
