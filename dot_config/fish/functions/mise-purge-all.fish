function mise-purge-all
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará todas las herramientas gestionadas por mise y la carpeta ~/.local/share/mise."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if test "$CONFIRM" = "si"
		echo -e "\nProcediendo con la eliminación de herramientas gestionadas por mise..."
		if command -v mise &>/dev/null; and command -v jq &>/dev/null
			set TOOLS_JSON (mise list --json 2>/dev/null)
			if test $status -eq 0
				set TOOLS (echo "$TOOLS_JSON" | jq -r '.[] | .plugin + "/" + .version' 2>/dev/null)
				if test $status -eq 0; and test -n "$TOOLS"
					echo -e "\nHerramientas instaladas con mise:"
					echo "$TOOLS"
				else
					echo "No hay herramientas instaladas con mise."
				end
			else
				echo "No hay herramientas instaladas con mise."
			end
		else
			echo "No se pudo verificar herramientas instaladas (falta 'mise' o 'jq')."
		end
		echo -e "\nEliminando la carpeta ~/.local/share/mise..."
		rm -rf ~/.local/share/mise
		echo -e "\n\033[1;32m¡Carpeta eliminada!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	end
end
