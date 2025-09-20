LTO_ENABLE = yes            # Link Time Optimization enabled
BOOTMAGIC_ENABLE = no       # Enable Bootmagic Lite
MOUSEKEY_ENABLE = no        # Mouse keys
EXTRAKEY_ENABLE = yes       # Audio control and System control
CONSOLE_ENABLE = no         # Console for debug
COMMAND_ENABLE = no         # Commands for debug and configuration
NKRO_ENABLE = no            # N-Key Rollover
BACKLIGHT_ENABLE = no       # Enable keyboard backlight functionality
AUDIO_ENABLE = no           # Audio output
RGBLIGHT_ENABLE = no        # Enable WS2812 RGB underlight.
SWAP_HANDS_ENABLE = no      # Enable one-hand typing
OLED_ENABLE = yes           # OLED display
ENCODER_ENABLE = yes        # Enable encoder support
ENCODER_MAP_ENABLE = yes    # Enable encoder map
WPM_ENABLE = yes            # Enable WPM tracking for music bars animation

# Custom animations and logo
SRC +=  ./animations/music/music-bars.c \
        ./animations/hornet/hornet.c \
        ./animations/luffy_hat/luffy_hat.c \
        ./animations/hollow_knight/hollow_knight.c
