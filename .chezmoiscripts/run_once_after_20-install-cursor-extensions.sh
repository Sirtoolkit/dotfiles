#!/bin/sh

# Solo se ejecuta si el comando 'cursor' está disponible
if command -v cursor >/dev/null 2>&1; then
  echo "📦 Instalando extensiones de Cursor..."

  EXTENSIONS_FILE="${HOME}/.cursor_extensions.txt"

  if [ -f "$EXTENSIONS_FILE" ]; then
      # Lee el archivo línea por línea e instala cada extensión
      cat "$EXTENSIONS_FILE" | xargs -L 1 cursor --install-extension
      echo "✅ Extensiones de Cursor instaladas."
  else
      echo "⚠️  Archivo de extensiones no encontrado en $EXTENSIONS_FILE"
  fi
else
  echo "ℹ️  El comando 'cursor' no fue encontrado. Saltando instalación de extensiones."
fi