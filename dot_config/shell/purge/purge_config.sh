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
