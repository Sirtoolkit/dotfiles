/**
 * Music bar animation with fast/slow typing mode
 *
 * Copyright (c) Marek Piechut
 * MIT License
 */

#pragma once

#include QMK_KEYBOARD_H

// Function to render the music bars animation
void oled_render_anim(void);

// Configuration
#ifndef FAST_TYPE_WPM
    #define FAST_TYPE_WPM 45 // Switch to fast animation when over words per minute
#endif
