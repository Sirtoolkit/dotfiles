#!/bin/sh

set -e

if ! command -v mise >/dev/null 2>&1; then
  echo "✅ 'mise' no está instalado. Saltando la instalación de herramientas."
  exit 0
fi

CONFIG_FILE="${HOME}/.config/mise/config.toml"

if [ -f "$CONFIG_FILE" ]; then
    echo "🚀 Instalando herramientas globales de 'mise' desde $CONFIG_FILE..."

    mise install

    echo "🛠️ Refrescando los shims de 'mise'..."
    mise reshim

    echo "✅ ¡Herramientas de 'mise' instaladas correctamente!"
else
    echo "ℹ️  No se encontró el archivo de configuración global de 'mise'. Saltando instalación."
fi