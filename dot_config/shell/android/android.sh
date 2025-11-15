if [ -f "$HOME/.config/shell/android/android_new_avd.sh" ]; then
  source "$HOME/.config/shell/android/android_new_avd.sh"
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

if [ -f "$HOME/.config/shell/android/android_enable_keyboard.sh" ]; then
  source "$HOME/.config/shell/android/android_enable_keyboard.sh"
fi
