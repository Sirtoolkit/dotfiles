#!/bin/sh

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging con colores
log_info() {
    echo "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo "${RED}❌ $1${NC}"
}

log_step() {
    echo "\n${BLUE}🚀 $1${NC}"
}

# Verificar que estamos en macOS
if [ "$(uname -s)" != "Darwin" ]; then
    log_error "Este script solo funciona en macOS"
    exit 1
fi

log_info "Detectado sistema operativo: macOS"

# Función para verificar herramientas mínimas
check_basic_tools() {
    log_step "Verificando herramientas básicas..."
    
    # Solo verificar que tenemos lo mínimo para ejecutar chezmoi
    if ! command -v git >/dev/null 2>&1; then
        log_error "Git no está instalado. Por favor instala Git primero."
        exit 1
    fi
    
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        log_error "Necesitas curl o wget instalado."
        exit 1
    fi
    
    log_success "Herramientas básicas disponibles"
}

# Función para instalar chezmoi
install_chezmoi() {
    if command -v chezmoi >/dev/null 2>&1; then
        log_success "chezmoi ya está instalado"
        return 0
    fi
    
    log_step "Instalando chezmoi..."
    
    bin_dir="$HOME/.local/bin"
    mkdir -p "$bin_dir"
    
    if command -v curl >/dev/null 2>&1; then
        sh -c "$(curl -fsLS https://git.io/chezmoi)" -- -b "$bin_dir"
    elif command -v wget >/dev/null 2>&1; then
        sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
    else
        log_error "Para instalar chezmoi, necesitas curl o wget instalado"
        exit 1
    fi
    
    # Agregar al PATH si no está
    if ! echo "$PATH" | grep -q "$bin_dir"; then
        export PATH="$bin_dir:$PATH"
    fi
    
    log_success "chezmoi instalado correctamente"
}

# Función para aplicar configuraciones de chezmoi en dos fases
apply_chezmoi_config() {
    log_step "Aplicando configuraciones de chezmoi en dos fases..."
    
    script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
    chezmoi_bin="$HOME/.local/bin/chezmoi"
    
    if [ ! -x "$chezmoi_bin" ]; then
        chezmoi_bin="chezmoi"
    fi
    
    log_info "Inicializando chezmoi desde: $script_dir"
    "$chezmoi_bin" init --source="$script_dir"
    
    # FASE 1: Copiar solo archivos de configuración
    log_step "📁 FASE 1: Copiando archivos de configuración..."
    log_info "Aplicando: ~/.config/, ~/.Library/, dotfiles, etc."
    
    if "$chezmoi_bin" apply --exclude scripts; then
        log_success "Archivos de configuración copiados correctamente"
    else
        log_warning "Algunos archivos pueden no haberse copiado correctamente, pero continuando..."
    fi
    
    # FASE 2: Ejecutar scripts de instalación
    log_step "🚀 FASE 2: Ejecutando scripts de instalación..."
    log_info "Scripts en orden: 01-Homebrew → 02-Paquetes → 03-1Password → 04-TouchID → 05-mise → 06-Android"
    
    if "$chezmoi_bin" apply --include scripts; then
        log_success "Scripts ejecutados correctamente"
    else
        log_warning "Algunos scripts fallaron, pero la configuración base está aplicada"
    fi
    
    log_success "Chezmoi completado - archivos copiados primero, luego scripts ejecutados"
}

# Función principal
main() {
    log_step "🍎 Iniciando instalación completa del entorno de desarrollo para macOS"
    
    # Verificar que no se ejecute como root
    if [ "$EUID" -eq 0 ]; then
        log_warning "No ejecutes este script como root."
        exit 1
    fi
    
    # Verificar herramientas mínimas
    check_basic_tools
    
    # Instalar chezmoi
    install_chezmoi
    
    # Aplicar chezmoi en dos fases: primero archivos, luego scripts
    apply_chezmoi_config
    
    log_success "¡Instalación completa! Archivos copiados primero, scripts ejecutados después."
}

# Ejecutar función principal
main "$@"