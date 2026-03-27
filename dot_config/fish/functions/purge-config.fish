function purge-config
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará completamente:"
	echo "  • ~/.config (toda la carpeta)"
	echo "  • ~/.cache (toda la carpeta)"
	echo "  • ~/.local (toda la carpeta)"
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro? (escribe 'si' para confirmar): "
	read CONFIRM
	if test "$CONFIRM" = "si"
		echo -e "\n\033[1;33m=> Eliminando ~/.config, ~/.cache, ~/.local...\033[0m"
		rm -rf ~/.config ~/.cache ~/.local
		echo "   ✓ ~/.config, ~/.cache, ~/.local eliminados"
		echo -e "\n\033[1;32m¡Directorios de configuración eliminados!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	end
end
