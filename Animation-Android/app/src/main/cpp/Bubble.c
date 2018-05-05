//
//  Bubble.c
//  wave
//
//  Created by 时文娟 　　 on 17/11/5.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

#include "Animation.h"
#include "Bubble.h"
#include "Particle.h"

int bubbleCount = 0;
const int BUBBLE_MAX = 4;
Particle particles[BUBBLE_MAX];
float SpeedIncX = 2.0;
Bitmap particleBitmap;
Bitmap layerBitmap;


void initBubble(unsigned char *data, int width, int height) {
    long bitsSize = width * height * 4;
    particleBitmap.data = (unsigned char *) malloc(bitsSize);
    particleBitmap.width = width;
    particleBitmap.height = height;
    memcpy(particleBitmap.data, data, bitsSize);
}


void drawBubble(Particle particle, unsigned char *layerBuffer, int layerWidth, int layerHeight) {
//    particle.cy = 400 + random() % 20;
//    particle.cx = 200 + random() % 20;
//    particle.cy = 400;
//    particle.cx = 200;
    for (int y = 0; y < particleBitmap.height; y++) {
        if (particle.cy + y < 0) {
            break;
        }
        unsigned int *destLine = (unsigned int *) layerBuffer + (particle.cy + y) * layerWidth + particle.cx;
        for (int x = 0; x < particleBitmap.width; x++) {
            if (x + particle.cx == layerWidth - 1) {
                break;
            }
            unsigned int srcColor = *((unsigned int *) particleBitmap.data + y * particleBitmap.width + x);
//            unsigned destColor = *(destLine + x);

            unsigned int alpha = srcColor >> 24;
            unsigned int destAlpha;
            switch (alpha) {
                case 0:
                    break;
                case 255:
                    *(destLine + x) = srcColor;
                    break;
                default:
                    destAlpha = ((particle.alpha * alpha) >> 8);
                    *(destLine + x) = (destAlpha << 24) | (srcColor & 0x00FFFFFF);
                    break;
            }

//            switch (alpha) {
//                case 0:
//                    break;
//                case 255:
//                    *(destLine + x) = srcColor | alpha << 24;
//                    break;
//                default:
//                    *(destLine + x) = (((((destColor & 0xFF00FF) << 8) + ((srcColor & 0xFF00FF) - (destColor & 0xFF00FF)) * alpha) >> 8) & 0xFF00FF) |
//                    (((((destColor & 0xFF00) << 8) + ((srcColor & 0xFF00) - (destColor & 0xFF00)) * alpha) >> 8) & 0xFF00) ;
//                    break;
//            }
        }
    }
}


void bubbleCycle(unsigned char *layerBuffer, int layerWidth, int layerHeight) {
    int i, count;
    float scale, half_height;
    
    memset(layerBuffer, 0x00, layerWidth * layerHeight * 4);
    count = bubbleCount;
    half_height = layerHeight / 2;

    for (i = 0; i < BUBBLE_MAX; i++) {
        if (count == 0)
            break;

        if (particles[i].visible == 1) {
            particles[i].life--;
            particles[i].cx += particles[i].speedX;
            particles[i].cy += particles[i].speedY;
            particles[i].speedX += particles[i].speedIncX;
            particles[i].speedY += particles[i].speedIncY;
            drawBubble(particles[i], layerBuffer, layerWidth, layerHeight);

            if (particles[i].life == 0 || particles[i].cy < 0
                || particles[i].cx < -particleBitmap.width || particles[i].cx > layerWidth + particleBitmap.width) {
                particles[i].visible = 0;
                i--;
                bubbleCount--;
            }

            count--;
        }
    }

    count = random() % BUBBLE_MAX;
    for (i = 0; i < count; i++) {

        if ((random() * 256) % 256 > 100)
            continue;

        if (particles[i].visible == 1) {
            continue;
        }

        particles[i].life = 30 + random() % 60;

        scale = random() % 10;
        particles[i].cz = scale;

        particles[i].width = particles[i].height = particleBitmap.width;//10 + 15 * scale;

        particles[i].cy = (layerHeight + particles[i].width) / 2;
        particles[i].speedY = -(4 + random() % 8);
        particles[i].speedIncY = 0.125f * (0.5f + random() % 5);

        if (random() % 2 == 0) {
            particles[i].cx = random() % layerWidth + particles[i].width;
            particles[i].speedX = -0.5f - random() % 8;
            particles[i].speedIncX = -0.125f * (0.5f + random() % 4);
        } else {
            particles[i].cx = random() % layerWidth - particles[i].width;
            particles[i].speedX = 0.5f + random() % 8;
            particles[i].speedIncX = 0.125f * (0.5f + random() % 3);
        }

        particles[i].alpha = 155 + random() % 100;
        particles[i].visible = 1;
        bubbleCount++;
    }
}



void addBubble(int x, int y) {
    int i = 0;//random() % BUBBLE_MAX;

    particles[i].life = 30 + random() % 60;

    particles[i].width = particles[i].height = particleBitmap.width;//10 + 15 * scale;

    particles[i].cy = y - particleBitmap.height/2;
    particles[i].speedY = -(4 + random() % 8);
    particles[i].speedIncY = 0.125f * (0.5f + random() % 5);

    if (random() % 2 == 0) {
        particles[i].cx = x - particleBitmap.width/2;
        particles[i].speedX = -0.5f - random() % 8;
        particles[i].speedIncX = -0.125f * (0.5f + random() % 4);
    } else {
        particles[i].cx = x - particleBitmap.width/2;
        particles[i].speedX = 0.5f + random() % 8;
        particles[i].speedIncX = 0.125f * (0.5f + random() % 3);
    }

    particles[i].alpha = 155 + random() % 100;
    particles[i].visible = 1;
}
