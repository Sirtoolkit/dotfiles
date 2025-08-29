#!/bin/sh

set -e

PLUGINS_DIR="$HOME/.config/tmux/plugins"

TPM_DIR="$PLUGINS_DIR/tpm"
TPM_REPO="https://github.com/tmux-plugins/tpm.git"

GRUVBOX_DIR="$PLUGINS_DIR/tmux-gruvbox"
GRUVBOX_REPO="git@github.com:egel/tmux-gruvbox.git"

echo "📂 Verificando que el directorio $PLUGINS_DIR exista..."
mkdir -p "$PLUGINS_DIR"

if [ -d "$TPM_DIR" ]; then
  echo "👍 TPM ya está instalado. Omitiendo."
else
  echo "🚀 Clonando TPM en $TPM_DIR..."
  git clone "$TPM_REPO" "$TPM_DIR"
  echo "✅ TPM clonado correctamente."
fi

if [ -d "$GRUVBOX_DIR" ]; then
  echo "👍 El tema tmux-gruvbox ya existe. Omitiendo."
else
  echo "🚀 Clonando tmux-gruvbox en $GRUVBOX_DIR..."
  git clone "$GRUVBOX_REPO" "$GRUVBOX_DIR"
  echo "✅ Tema clonado correctamente."
fi

echo "\n🎉 ¡Instalación de todos los repositorios completada!"
echo "👉 Ahora, añade las líneas de los plugins a tu .tmux.conf y recarga la configuración."
