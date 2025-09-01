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

# Función para aplicar configuraciones de chezmoi
apply_chezmoi_config() {
    log_step "Aplicando configuraciones completas de chezmoi..."
    
    script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
    chezmoi_bin="$HOME/.local/bin/chezmoi"
    
    if [ ! -x "$chezmoi_bin" ]; then
        chezmoi_bin="chezmoi"
    fi
    
    log_info "Inicializando y aplicando desde: $script_dir"
    log_info "Chezmoi ejecutará scripts en orden perfecto: 01-Homebrew → 02-Paquetes → 03-1Password → 04-TouchID → 05-mise → 06-Android → 07-tmux → 08-Cursor"
    
    # Dejar que chezmoi haga todo su trabajo en orden
    "$chezmoi_bin" init --apply --source="$script_dir"
    
    log_success "Chezmoi completado - archivos y scripts aplicados"
}

# Función para configurar shell
setup_shell() {
    log_step "Configurando shell..."
    
    # Cambiar shell por defecto a zsh si no lo es ya
    if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/opt/homebrew/bin/zsh" ]; then
        if command -v zsh >/dev/null 2>&1; then
            log_info "Cambiando shell por defecto a zsh..."
            chsh -s "$(which zsh)"
            log_success "Shell cambiado a zsh"
        else
            log_warning "zsh no está disponible, manteniendo shell actual"
        fi
    else
        log_success "zsh ya es el shell por defecto"
    fi
}

# Función para configuración final
final_setup() {
    log_step "Configuración final..."
    
    # Cambiar shell por defecto a zsh si no lo es ya
    if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/opt/homebrew/bin/zsh" ]; then
        if command -v zsh >/dev/null 2>&1; then
            log_info "Cambiando shell por defecto a zsh..."
            chsh -s "$(which zsh)"
            log_success "Shell cambiado a zsh"
        else
            log_warning "zsh no está disponible, manteniendo shell actual"
        fi
    else
        log_success "zsh ya es el shell por defecto"
    fi
    
    # Información final
    if [ -f "$HOME/.zshrc" ]; then
        log_success "Configuración lista - abre una nueva terminal o ejecuta: source ~/.zshrc"
    fi
}

# Función para mostrar resumen final
show_summary() {
    log_step "🎉 ¡Instalación completada!"
    
    echo "\n${GREEN}✅ Instalación exitosa de tu entorno de desarrollo${NC}"
    echo "\n${BLUE}📋 Chezmoi ejecutó automáticamente (en orden perfecto):${NC}"
    echo "  1️⃣ Homebrew installation"
    echo "  2️⃣ Homebrew packages (mise, tools, etc.)"
    echo "  3️⃣ 1Password agent setup"
    echo "  4️⃣ macOS TouchID for sudo"
    echo "  5️⃣ mise tools (Java, Node, Python, etc.)"
    echo "  6️⃣ Android Platform Tools (con Java disponible)"
    echo "  7️⃣ tmux plugins y configuración"
    echo "  8️⃣ Cursor extensions"
    echo "  ✨ Todos los dotfiles (.zshrc, .config/, etc.)"
    
    echo "\n${YELLOW}📝 Próximos pasos:${NC}"
    echo "  1. Abre una nueva terminal o ejecuta: source ~/.zshrc"
    echo "  2. ¡Todo está listo para usar!"
    
    echo "\n${YELLOW}💡 Si algo falló:${NC}"
    echo "  • Ejecuta: chezmoi apply"
    echo "  • Para herramientas específicas: mise install"
    
    echo "\n${BLUE}💡 Comandos útiles:${NC}"
    echo "  • purge-config          - Limpiar configuraciones"
    echo "  • purge-all-mobile-dev-cache - Limpiar caché de desarrollo"
    echo "  • mise-purge-all        - Limpiar herramientas de mise"
    echo "  • brew-purge-formula    - Limpiar paquetes de Homebrew"
    echo "  • brew-purge-cask       - Limpiar aplicaciones de Homebrew"
    
    echo "\n${GREEN}🚀 ¡Tu entorno está listo para usar!${NC}\n"
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
    
    # Aplicar todo con chezmoi (archivos + scripts en orden correcto)
    apply_chezmoi_config
    
    # Configuración final
    final_setup
    
    # Mostrar resumen
    show_summary
}

# Ejecutar función principal
main "$@"