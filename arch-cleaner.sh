#!/usr/bin/env bash

# ==============================================================================
# Script de Mantenimiento para Arch Linux
# Descripción: Automatiza la limpieza de caché, huérfanos y optimización de DB.
# Autor: [Tu Nombre/Usuario de GitHub]
# Licencia: MIT
# ==============================================================================

# --- Colores para la interfaz ---
SET_BOLD=$(tput bold)
CLR_RESET=$(tput sgr0)
CLR_RED=$(tput setaf 1)
CLR_GREEN=$(tput setaf 2)
CLR_YELLOW=$(tput setaf 3)
CLR_CYAN=$(tput setaf 6)

# --- Funciones de Ayuda ---
header() {
  echo -e "\n${SET_BOLD}${CLR_CYAN}>>> $1${CLR_RESET}"
}

success() {
  echo -e "${CLR_GREEN} [✔] $1${CLR_RESET}"
}

warning() {
  echo -e "${CLR_YELLOW} [!] $1${CLR_RESET}"
}

# --- Verificación de privilegios ---
if [[ $EUID -ne 0 ]]; then
  echo "${CLR_RED}Error: Este script debe ejecutarse como root (sudo).${CLR_RESET}"
  exit 1
fi

# --- Inicio del Mantenimiento ---
clear
echo "${SET_BOLD}${CLR_CYAN}Arch Linux Maintenance Tool${CLR_RESET}"
echo "------------------------------------------"

# 1. Actualización del Sistema
header "Actualizando repositorios y sistema..."
pacman -Syu --noconfirm

# 2. Limpieza de paquetes huérfanos
header "Buscando paquetes huérfanos (dependencies no utilizadas)..."
ORPHANS=$(pacman -Qtdq)
if [[ -n "$ORPHANS" ]]; then
  pacman -Rns $ORPHANS --noconfirm
  success "Paquetes huérfanos eliminados."
else
  success "No se encontraron paquetes huérfanos."
fi

# 3. Limpieza de caché de Pacman
# Mantiene solo las últimas 2 versiones de cada paquete instalado para permitir downgrade si es necesario.
header "Limpiando caché de paquetes (paccache)..."
if command -v paccache &>/dev/null; then
  paccache -r -k 2
  paccache -ruk 0
  success "Caché optimizada (se mantuvieron 2 versiones)."
else
  warning "pacman-contrib no está instalado. Saltando limpieza de caché."
fi

# 4. Reparación de archivos .pacnew
header "Verificando archivos de configuración (.pacnew / .pacsave)..."
PACNEW_FILES=$(find /etc -regextype posix-extended -regex ".+\.pac(new|save)" 2>/dev/null)
if [[ -n "$PACNEW_FILES" ]]; then
  warning "Se encontraron archivos .pacnew o .pacsave. Revisar manualmente:"
  echo "$PACNEW_FILES"
else
  success "No hay conflictos de configuración pendientes."
fi

# 5. Limpieza de logs de Journald
header "Limpiando logs del sistema (Journald) mayores a 2 semanas..."
journalctl --vacuum-time=2weeks

# 6. Verificación de errores en el Systemd
header "Verificando servicios fallidos..."
FAILED_SERVICES=$(systemctl --failed --quiet | grep "0 loaded")
if [[ -z "$FAILED_SERVICES" ]]; then
  success "Todos los servicios funcionan correctamente."
else
  warning "Hay servicios con errores. Revisa 'systemctl --failed'."
fi

header "Mantenimiento Finalizado."
echo -e "${SET_BOLD}${CLR_GREEN}¡Tu sistema está limpio y optimizado!${CLR_RESET}\n"
