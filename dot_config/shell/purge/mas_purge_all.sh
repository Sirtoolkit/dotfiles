mas-purge-all() {
	if ! command -v mas &>/dev/null;
	then
		echo "\n\033[1;31mError:\033[0m El comando 'mas' no está instalado."
		echo "Por favor, instálalo con 'brew install mas' y vuelve a intentarlo."
		return 1
	fi

	echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las aplicaciones instaladas desde la Mac App Store (Pages, Numbers, etc.)."
	echo "Esta acción no se puede deshacer."

	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM

	if [[ "$CONFIRM" == "si" ]]; 
	then
		echo "\nProcediendo con la eliminación de aplicaciones de la App Store..."

		if mas list &>/dev/null; 
		then
			mas list | awk '{print $1}' | xargs -n 1 mas uninstall
			echo "\n\033[1;32m¡Proceso completado!\033[0m"
		else
			echo "No hay aplicaciones de la Mac App Store para desinstalar."
		fi

	else
		echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado ninguna aplicación."
	fi
}
