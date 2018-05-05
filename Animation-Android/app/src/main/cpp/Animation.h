//
// Created by wanghaijun on 2017/11/9.
//

#ifndef ANIMATION_ANIMATION_H
#define ANIMATION_ANIMATION_H

#ifdef ANDROID_MODEL
#undef IOS_MODEL
#else
#define IOS_MODEL
#endif


#include <stdio.h>
#include <math.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>

#ifdef IOS_MODEL

#define LOGD(...) print(__VA_ARGS__)
#define LOGE(...) print( __VA_ARGS__)

#else

#include <jni.h>
#include <android/bitmap.h>
#include <android/log.h>


#define LOG_TAG  "DRAnimation"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG,  __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG,  __VA_ARGS__)

#endif


#endif //ANIMATION_ANIMATION_H
