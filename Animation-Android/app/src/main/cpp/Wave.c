//
// Created by wanghaijun on 2017/11/6.
//
#include "Animation.h"
#include "Wave.h"

static const float DEFAULT_AMPLITUDE_RATIO = 0.05f;
static const float DEFAULT_WATER_LEVEL_RATIO = 0.5f;
static const float DEFAULT_WAVE_LENGTH_RATIO = 1.0f;
static const float DEFAULT_WAVE_SHIFT_RATIO = 0.0f;


void drawLine(unsigned char *buffer, int x1, int y1, int x2, int y2, int rowSize, int color) {
    for (int y = y1; y < y2; y++) {
        for (int x = x1; x < x2; x++) {
            unsigned char *tmp = buffer + y * rowSize + (x << 2);
            #ifdef IOS_MODEL
                *(tmp + 0) = (color & 0x00FF0000) >> 16;
                *(tmp + 1) = (color & 0x0000FF00) >> 8;
                *(tmp + 2) = color & 0x000000FF;
            #else
                *(tmp + 0) = (color & 0xFF000000) >> 24;
                *(tmp + 1) = (color & 0x00FF0000) >> 16;
                *(tmp + 2) = color & 0x0000FF00 >> 8;
            #endif
        }
    }
}

void drawWave(unsigned char *buffer, int width, int height, double phase, double amplitude, unsigned int c1, unsigned int c2) {
    // y=Asin(ωx+φ)+h
    float waveX1 = 0;
    float wave2Shift = width / 3.0f;
    float endX = width;
    float endY = height;
    int rowSize = width << 2;
    double mDefaultAngularFrequency = 2.0f * M_PI / DEFAULT_WAVE_LENGTH_RATIO / width;
    double mDefaultWaterLevel = height * DEFAULT_WATER_LEVEL_RATIO;

    memset(buffer, 0xFF, height * rowSize);
    if (phase > rowSize) {
        phase -= rowSize;
    }

    while (waveX1 < endX) {
        double wx = waveX1 * mDefaultAngularFrequency;
        int startY = (int) (mDefaultWaterLevel + amplitude * sin(phase + wx));
        drawLine(buffer, waveX1, startY, waveX1 + 1, endY, rowSize, c1);

        startY = (int) (mDefaultWaterLevel + amplitude * sin(wave2Shift + phase + wx));
        drawLine(buffer, waveX1, startY, waveX1 + 1, endY, rowSize, c2);

        waveX1++;
    }

}
