function purge-mas
	if not command -v mas &>/dev/null
		echo -e "\n\033[1;31mError:\033[0m El comando 'mas' no está instalado."
		echo "Por favor, instálalo con 'brew install mas' y vuelve a intentarlo."
		return 1
	end

	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las aplicaciones instaladas desde la Mac App Store (Pages, Numbers, etc.)."
	echo "Esta acción no se puede deshacer."

	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM

	if test "$CONFIRM" = "si"
		echo -e "\nProcediendo con la eliminación de aplicaciones de la App Store..."

		if mas list &>/dev/null
			mas list | awk '{print $1}' | xargs -n 1 mas uninstall
			echo -e "\n\033[1;32m¡Proceso completado!\033[0m"
		else
			echo "No hay aplicaciones de la Mac App Store para desinstalar."
		end
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado ninguna aplicación."
	end
end
