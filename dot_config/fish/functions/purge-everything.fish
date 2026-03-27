function purge-everything
	echo -e "\n\033[1;31m⚠️  MODO NUCLEAR ACTIVADO ⚠️\033[0m"
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará COMPLETAMENTE:"
	echo "  • ~/.config (toda la carpeta)"
	echo "  • ~/.cache (toda la carpeta)"
	echo "  • ~/.local (toda la carpeta)"
	echo "  • ~/.bashrc, ~/.tmux, ~/.tmux.conf"
	echo "  • Configs de apps instaladas via Homebrew Casks, MAS y dev tools"
	echo "  • Archivos de historial (zsh, bash)"
	echo -e "\n\033[1;31mEsto dejará tu sistema como recién instalado.\033[0m"
	echo "Esta acción no se puede deshacer."
	echo -n "Escribe 'borrar-todo' para confirmar: "
	read CONFIRM
	if test "$CONFIRM" = "borrar-todo"
		echo -e "\n\033[1;33m=> Eliminando ~/.config, ~/.cache, ~/.local...\033[0m"
		rm -rf ~/.config ~/.cache ~/.local
		echo "   ✓ ~/.config, ~/.cache, ~/.local eliminados"

		echo -e "\n\033[1;33m=> Eliminando archivos de configuración...\033[0m"
		rm -rf ~/.bashrc ~/.tmux ~/.tmux.conf
		echo "   ✓ ~/.bashrc, ~/.tmux, ~/.tmux.conf"

		echo -e "\n\033[1;33m=> Eliminando configs de apps (Casks, MAS, dev tools)...\033[0m"
		# Apps Casks
		rm -rf ~/Library/Application\ Support/Arc
		rm -rf ~/Library/Preferences/company.thebrowser.Browser.plist
		rm -rf ~/Library/Application\ Support/com.mitchellh.ghostty
		rm -rf ~/Library/Application\ Support/discord
		rm -rf ~/Library/Preferences/com.hnc.Discord.plist
		rm -rf ~/Library/Application\ Support/obsidian
		rm -rf ~/Library/Preferences/md.obsidian.Obsidian.plist
		rm -rf ~/Library/Application\ Support/Slack
		rm -rf ~/Library/Preferences/com.tinyspeck.slackmacgap.plist
		rm -rf ~/Library/Application\ Support/Raycast
		rm -rf ~/Library/Preferences/com.raycast.macos.plist
		rm -rf ~/Library/Application\ Support/bruno
		rm -rf ~/Library/Application\ Support/Google/Chrome
		rm -rf ~/Library/Preferences/com.google.Chrome.plist
		rm -rf ~/Library/Application\ Support/JetBrains/DataGrip*
		rm -rf ~/.flutter-tool-settings
		rm -rf ~/Library/Application\ Support/io.flutter
		rm -rf ~/Library/Application\ Support/CrossOver
		rm -rf ~/Library/Application\ Support/Clockify
		rm -rf ~/Library/Application\ Support/Bitwarden
		# MAS apps
		rm -rf ~/Library/Application\ Support/Transporter
		rm -rf ~/Library/Preferences/com.apple.itunes.transporter.plist
		# Dev tools
		rm -rf ~/.android
		rm -rf ~/Library/Application\ Support/OrbStack
		rm -rf ~/.aerospace.toml
		rm -rf ~/.cocoapods
		rm -rf ~/.pod
		rm -rf ~/.fastlane
		rm -rf ~/.ollama
		rm -rf ~/.claude
		rm -rf ~/.claude-code
		echo "   ✓ Configs de apps, MAS y dev tools"

		echo -e "\n\033[1;33m=> Eliminando archivos de historial...\033[0m"
		rm -rf ~/.zoxide
		rm -rf ~/.zsh_history
		rm -rf ~/.bash_history
		echo "   ✓ Archivos de historial"

		echo -e "\n\033[1;32m🔥 ¡TODO HA SIDO ELIMINADO! 🔥\033[0m"
		echo "Tu sistema está limpio. Restaura con: chezmoi apply"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	end
end
