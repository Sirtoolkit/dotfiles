if [ -f "$HOME/.config/shell/android/android_create_emulator.sh" ]; then
  source "$HOME/.config/shell/android/android_create_emulator.sh"
fi

if [ -f "$HOME/.config/shell/android/android_launch_emulator.sh" ]; then
  source "$HOME/.config/shell/android/android_launch_emulator.sh"
fi

if [ -f "$HOME/.config/shell/android/android_delete_emulator.sh" ]; then
  source "$HOME/.config/shell/android/android_delete_emulator.sh"
fi

if [ -f "$HOME/.config/shell/android/android_delete_system_image.sh" ]; then
  source "$HOME/.config/shell/android/android_delete_system_image.sh"
fi
