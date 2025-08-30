alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias v="nvim"
alias zsource='source ~/.zshrc'
alias gdu='gdu-go'

alias ls="eza -l --icons=always -m -n -l"
alias l="eza -l --icons=always -m -n -l -a"
alias ll="eza -l --icons=always -m -n -l"

alias dbb="flutter clean && dart run build_runner build -d"
alias dbw="flutter clean && dart run build_runner watch -d"

alias mkdir='mkdir -pv'

alias Applications='cd $HOME/Applications'
alias Cloud='cd $HOME/Cloud'
alias Config='cd $HOME/.config'
alias Desktop='cd $HOME/Desktop'
alias Downloads='cd $HOME/Downloads'
alias Library='cd $HOME/Library'
alias Local='cd $HOME/.local'
alias Movies='cd $HOME/Movies'
alias Music='cd $HOME/Music'
alias Pictures='cd $HOME/Pictures'
alias Public='cd $HOME/Public'

dgrep() {
	als | grep "$@"
}

purge-all-mobile-dev-cache() {
	echo -e "\n\033[1;33mINFO:\033[0m Esta acción eliminará directamente las carpetas de caché de desarrollo nativo y de frameworks."
	echo "Se limpiarán carpetas de Android (Gradle), iOS (Xcode), Node.js (npm/yarn), React Native, Expo y Flutter."
	echo "Tus proyectos, SDKs y configuraciones principales NO serán eliminados."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo -e "\nEliminando carpetas de caché de desarrollo móvil..."

		# --- Limpieza de Caché Nativa ANDROID ---
		echo "Limpiando carpetas de caché de Gradle y Android Studio..."
		rm -rf ~/.gradle/caches
		rm -rf ~/.gradle/wrapper/dists
		rm -rf ~/.cache/Google/AndroidStudio*

		# --- Limpieza de Caché Nativa iOS/Xcode (solo en macOS) ---
		if [[ "$(uname)" == "Darwin" ]]; then
			echo "Limpiando carpetas de caché de Xcode (DerivedData, Archives)..."
			rm -rf ~/Library/Developer/Xcode/DerivedData/
			rm -rf ~/Library/Developer/Xcode/Archives/
			rm -rf ~/Library/Caches/com.apple.dt.Xcode/
			rm -rf ~/Library/Caches/org.swift.swiftpm/
		fi

		# --- Limpieza de Carpetas de Caché de Frameworks ---

		# Caché de Node.js (npm y Yarn)
		echo "Eliminando carpetas de caché de npm y Yarn..."
		rm -rf ~/.npm/_cacache
		rm -rf ~/.npm/_logs
		if [[ "$(uname)" == "Darwin" ]]; then
			rm -rf ~/Library/Caches/Yarn
		else # Asumiendo Linux
			rm -rf ~/.cache/yarn
		fi

		# Caché específica de React Native
		echo "Eliminando carpetas de caché de React Native (Metro)..."
		rm -rf $TMPDIR/react-*
		rm -rf $TMPDIR/metro-*
		rm -rf $TMPDIR/haste-map-*

		# --- NUEVO: Caché específica de Expo ---
		echo "Eliminando carpetas de caché de Expo y EAS CLI..."
		rm -rf ~/.expo           # Caché principal de Expo CLI, logs y datos de sesión
		rm -rf ~/.cache/expo     # Ubicación de caché común en sistemas Linux
		rm -rf ~/.config/eas-cli # Caché y configuración de EAS CLI

		# Caché específica de Flutter
		echo "Eliminando carpetas de caché de Flutter..."
		if [[ "$(uname)" == "Darwin" ]]; then # macOS
			rm -rf ~/.pub-cache
		else # Linux
			rm -rf ~/.cache/dart
			rm -rf ~/.pub-cache
		fi

		echo -e "\n\033[1;32m¡Limpieza de carpetas de caché completada!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

purge-config() {
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará completamente la carpeta ~/.config, así como los archivos ~/.zshrc, ~/.bashrc, ~/.tmux y ~/.tmux.conf."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo -e "\nEliminando la carpeta ~/.config y archivos de configuración..."
		rm -rf ~/.config ~/.zshrc ~/.bashrc ~/.tmux ~/.tmux.conf ~/.oh-my-zsh ~/.zprofile ~/.zsh_history
		echo -e "\n\033[1;32m¡Carpeta ~/.config y archivos de configuración eliminados!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

mise-purge-all() {
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará todas las herramientas gestionadas por mise y la carpeta ~/.local/share/mise."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo -e "\nProcediendo con la eliminación de herramientas gestionadas por mise..."
		if command -v mise &>/dev/null && command -v jq &>/dev/null; then
			TOOLS_JSON=$(mise list --json 2>/dev/null)
			if [[ $? -eq 0 ]]; then
				TOOLS=$(echo "$TOOLS_JSON" | jq -r '.[] | .plugin + "/" + .version' 2>/dev/null)
				if [[ $? -eq 0 && -n "$TOOLS" ]]; then
					echo -e "\nHerramientas instaladas con mise:"
					echo "$TOOLS"
				else
					echo "No hay herramientas instaladas con mise."
				fi
			else
				echo "No hay herramientas instaladas con mise."
			fi
		else
			echo "No se pudo verificar herramientas instaladas (falta 'mise' o 'jq')."
		fi
		echo -e "\nEliminando la carpeta ~/.local/share/mise..."
		rm -rf ~/.local/share/mise
		echo -e "\n\033[1;32m¡Carpeta eliminada!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

brew-purge-formula() {
	echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las fórmulas (paquetes) instaladas con Homebrew."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo "\nProcediendo con la eliminación de fórmulas..."
		echo "\n\033[1;33m=> Desinstalando Fórmulas...\033[0m"
		if brew list --formula &>/dev/null; then
			brew remove --force --ignore-dependencies $(brew list --formula)
		else
			echo "No hay fórmulas para desinstalar."
		fi
		echo "\n\033[1;32m¡Proceso completado!\033[0m"
		echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."
	else
		echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

brew-purge-cask() {
	echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODOS los casks (aplicaciones) instalados con Homebrew."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo "\nProcediendo con la eliminación de casks..."
		echo "\n\033[1;33m=> Desinstalando Casks (Aplicaciones)...\033[0m"
		if brew list --cask &>/dev/null; then
			brew uninstall --cask --force --ignore-dependencies $(brew list --cask)
		else
			echo "No hay casks para desinstalar."
		fi
		echo "\n\033[1;32m¡Proceso completado!\033[0m"
		echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."
	else
		echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

mas-purge-all() {
	if ! command -v mas &>/dev/null; then
		echo "\n\033[1;31mError:\033[0m El comando 'mas' no está instalado."
		echo "Por favor, instálalo con 'brew install mas' y vuelve a intentarlo."
		return 1
	fi

	echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las aplicaciones instaladas desde la Mac App Store (Pages, Numbers, etc.)."
	echo "Esta acción no se puede deshacer."

	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM

	if [[ "$CONFIRM" == "si" ]]; then
		echo "\nProcediendo con la eliminación de aplicaciones de la App Store..."

		if mas list &>/dev/null; then
			mas list | awk '{print $1}' | xargs -n 1 mas uninstall
			echo "\n\033[1;32m¡Proceso completado!\033[0m"
		else
			echo "No hay aplicaciones de la Mac App Store para desinstalar."
		fi

	else
		echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado ninguna aplicación."
	fi
}
