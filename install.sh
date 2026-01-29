#!/bin/sh

set -e

# Colores para output
if [ -t 1 ] && [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Función para logging con colores
log_info() {
    printf "%b\n" "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    printf "%b\n" "${GREEN}✅ $1${NC}"
}

log_warning() {
    printf "%b\n" "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    printf "%b\n" "${RED}❌ $1${NC}"
}

log_step() {
    printf "\n%b\n" "${BLUE}🚀 $1${NC}"
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

# Función para aplicar configuraciones de chezmoi
apply_chezmoi_config() {
    log_step "Aplicando configuraciones de chezmoi..."
    
    chezmoi_bin="$HOME/.local/bin/chezmoi"
    
    if [ ! -x "$chezmoi_bin" ]; then
        chezmoi_bin="chezmoi"
    fi
    
    if "$chezmoi_bin" apply; then
        log_success "Configuraciones aplicadas correctamente"
    else
        log_warning "Algunos archivos pueden no haberse aplicado correctamente"
    fi
}

# Función principal
main() {
    log_step "🍎 Iniciando instalación de chezmoi y aplicación de configuraciones"
    
    # Verificar que no se ejecute como root
    if [ "$EUID" -eq 0 ]; then
        log_warning "No ejecutes este script como root."
        exit 1
    fi
    
    # Verificar herramientas mínimas
    check_basic_tools
    
    # Instalar chezmoi
    install_chezmoi
    
    # Aplicar configuraciones
    apply_chezmoi_config
    
    log_success "¡Instalación completa!"
}

# Ejecutar función principal
main "$@"