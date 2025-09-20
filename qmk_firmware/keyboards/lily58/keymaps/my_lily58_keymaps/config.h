#pragma once

#define QUICK_TAP_TERM 0
#define TAPPING_TERM 100

// Encoder configuration - both encoders
#undef ENCODER_A_PINS
#undef ENCODER_B_PINS
#define ENCODER_A_PINS { F4, F6 }
#define ENCODER_B_PINS { F5, F7 }
#define ENCODER_RESOLUTION 4

// OLED Configuration for music bars animation
#define OLED_TIMEOUT 60000      // OLED timeout in milliseconds (60 seconds)
#define OLED_BRIGHTNESS 128     // OLED brightness (0-255)