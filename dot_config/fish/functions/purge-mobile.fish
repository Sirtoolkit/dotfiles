function purge-mobile
	echo -e "\n\033[1;33mINFO:\033[0m Esta acción eliminará directamente las carpetas de caché de desarrollo nativo y de frameworks."
	echo "Se limpiarán carpetas de Android (Gradle), iOS (Xcode), Node.js (npm/yarn/pnpm), React Native, Expo y Flutter."
	echo "Tus proyectos, SDKs y configuraciones principales NO serán eliminados."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if test "$CONFIRM" = "si"
		echo -e "\nEliminando carpetas de caché de desarrollo móvil..."

		# --- Limpieza de Caché Nativa ANDROID ---
		echo "Limpiando carpetas de caché de Gradle y Android Studio..."
		rm -rf ~/.gradle/caches
		rm -rf ~/.gradle/wrapper/dists
		rm -rf ~/.cache/Google/AndroidStudio*

		# --- Limpieza de Caché Nativa iOS/Xcode (solo en macOS) ---
		if test (uname) = "Darwin"
			echo "Limpiando carpetas de caché de Xcode (DerivedData, Archives)..."
			rm -rf ~/Library/Developer/Xcode/DerivedData/
			rm -rf ~/Library/Developer/Xcode/Archives/
			rm -rf ~/Library/Caches/com.apple.dt.Xcode/
			rm -rf ~/Library/Caches/org.swift.swiftpm/
		end

		# --- Limpieza de Carpetas de Caché de Frameworks ---

		# Caché de Node.js (npm, Yarn y pnpm)
		echo "Eliminando carpetas de caché de npm, Yarn y pnpm..."
		rm -rf ~/.npm/_cacache
		rm -rf ~/.npm/_logs

		if test (uname) = "Darwin"
			rm -rf ~/Library/Caches/Yarn
			rm -rf ~/Library/Caches/pnpm
		else
			rm -rf ~/.cache/yarn
			rm -rf ~/.cache/pnpm
		end

		# Caché específica de React Native
		echo "Eliminando carpetas de caché de React Native (Metro)..."
		rm -rf $TMPDIR/react-*
		rm -rf $TMPDIR/metro-*
		rm -rf $TMPDIR/haste-map-*

		# --- NUEVO: Caché específica de Expo ---
		echo "Eliminando carpetas de caché de Expo y EAS CLI..."
		rm -rf ~/.expo
		rm -rf ~/.cache/expo
		rm -rf ~/.config/eas-cli

		# Caché específica de Flutter
		echo "Eliminando carpetas de caché de Flutter..."
		if test (uname) = "Darwin"
			rm -rf ~/.pub-cache
		else
			rm -rf ~/.cache/dart
			rm -rf ~/.pub-cache
		end

		echo -e "\n\033[1;32m¡Limpieza de carpetas de caché completada!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	end
end
