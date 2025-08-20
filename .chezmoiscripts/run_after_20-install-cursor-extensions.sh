#!/bin/sh

if command -v cursor >/dev/null 2>&1; then
  echo "📦 Verificando e instalando extensiones de Cursor..."

  EXTENSIONS_FILE="${HOME}/.cursor_extensions.txt"

  if [ -f "$EXTENSIONS_FILE" ]; then
      while IFS= read -r extension; do
          [ -z "$extension" ] || [ "${extension#\#}" != "$extension" ] && continue
          if cursor --list-extensions | grep -q "^$extension$"; then
              echo "✓ $extension ya está instalada"
          else
              echo "📥 Instalando $extension..."
              cursor --install-extension "$extension"
          fi
      done < "$EXTENSIONS_FILE"
      echo "✅ Verificación de extensiones de Cursor completada."
  else
      echo "⚠️  Archivo de extensiones no encontrado en $EXTENSIONS_FILE"
  fi
else
  echo "ℹ️  El comando 'cursor' no fue encontrado. Saltando instalación de extensiones."
fi