//
//  Particle.h
//  wave
//
//  Created by 时文娟 　　 on 17/11/4.
//  Copyright © 2017年 dhlsnow. All rights reserved.
//

#ifndef Particle_h
#define Particle_h

typedef struct BitmapStruct {
    unsigned char         *data;
    int         width;
    int         height;
} Bitmap;

typedef struct ParticleStruct{
    int         visible;
    int			life;
    int			size;
    int			cx;
    int			cy;
    int			cz;
    int			speedX;
    int			speedY;
    int			speedIncX;
    int			speedIncY;
    int			alpha;
    int			alphaInc;
    int			angle;
    int			radius;
    int			color;
    int         width;
    int         height;
    Bitmap      bitmap;
} Particle;

extern Particle *addPaticel(int *data, int width, int height, int color) ;
#endif /* Particle_h */
