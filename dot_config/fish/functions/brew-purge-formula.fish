function brew-purge-formula
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las fórmulas (paquetes) instaladas con Homebrew."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if test "$CONFIRM" = "si"
		echo -e "\nProcediendo con la eliminación de fórmulas..."
		echo -e "\n\033[1;33m=> Desinstalando Fórmulas...\033[0m"
		if brew list --formula &>/dev/null
			brew remove --force --ignore-dependencies (brew list --formula)
		else
			echo "No hay fórmulas para desinstalar."
		end
		echo -e "\n\033[1;32m¡Proceso completado!\033[0m"
		echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	end
end
