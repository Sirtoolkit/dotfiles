#pragma once

#define TAPPING_TERM 250
#define CHORDAL_HOLD
#define PERMISSIVE_HOLD
#define COMBO_ALLOW_ACTION_KEYS
#define COMBO_TERM 50 // 50ms para presionar ambas teclas
#define LEADER_TIMEOUT 300 // Tiempo para completar la secuencia después del combo (ms)
#define AUTO_SHIFT_TIMEOUT 150 // Tiempo en milisegundos para activar el Shift
// Encoder configuration - both encoders
#undef ENCODER_A_PINS
#undef ENCODER_B_PINS
#define ENCODER_A_PINS { F4, F6 }
#define ENCODER_B_PINS { F5, F7 }
#define ENCODER_RESOLUTION 4

// OLED Configuration for music bars animation
#define OLED_TIMEOUT 60000      // OLED timeout in milliseconds (60 seconds)
#define OLED_BRIGHTNESS 128     // OLED brightness (0-255)
