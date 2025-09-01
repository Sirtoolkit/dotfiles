#!/bin/sh

set -e

PLUGINS_DIR="$HOME/.config/tmux/plugins"

TPM_DIR="$PLUGINS_DIR/tpm"
TPM_REPO="https://github.com/tmux-plugins/tpm.git"

GRUVBOX_DIR="$PLUGINS_DIR/tmux-gruvbox"
GRUVBOX_REPO="git@github.com:egel/tmux-gruvbox.git"

WINDOW_NAME_DIR="$PLUGINS_DIR/tmux-window-name"
WINDOW_NAME_REPO="https://github.com/ofirgall/tmux-window-name.git"

PAIN_CONTROL_DIR="$PLUGINS_DIR/tmux-pain-control"
PAIN_CONTROL_REPO="https://github.com/tmux-plugins/tmux-pain-control.git"

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

if [ -d "$WINDOW_NAME_DIR" ]; then
  echo "👍 tmux-window-name ya está instalado. Omitiendo."
else
  echo "🐍 Instalando libtmux con pip..."
  python3 -m pip install --user libtmux
  echo "✅ libtmux instalado correctamente."
  echo "🚀 Clonando tmux-window-name en $WINDOW_NAME_DIR..."
  git clone "$WINDOW_NAME_REPO" "$WINDOW_NAME_DIR"
  echo "✅ tmux-window-name clonado correctamente."
fi

if [ -d "$PAIN_CONTROL_DIR" ]; then
  echo "👍 tmux-pain-control ya está instalado. Omitiendo."
else
  echo "🚀 Clonando tmux-pain-control en $PAIN_CONTROL_DIR..."
  git clone "$PAIN_CONTROL_REPO" "$PAIN_CONTROL_DIR"
  echo "✅ tmux-pain-control clonado correctamente."
fi

echo "\n🎉 ¡Instalación de todos los repositorios completada!"
echo "👉 Ahora, añade las líneas de los plugins a tu .tmux.conf y recarga la configuración."
