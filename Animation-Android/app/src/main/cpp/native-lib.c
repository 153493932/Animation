#include "Animation.h"
#include "Bubble.h"
#include "Wave.h"

JNIEXPORT void JNICALL
Java_com_example_animation_animation_DRLib_initBubbles(JNIEnv *env, jobject object, jobject bubbleBitmap) {
    int ret;
    AndroidBitmapInfo info;
    unsigned char *bubblebuffer;

    if ((ret = AndroidBitmap_getInfo(env, bubbleBitmap, &info)) < 0) {
        LOGD("AndroidBitmap_getInfo() failed ! error=%d", ret);
        return;
    }

    if (info.format != ANDROID_BITMAP_FORMAT_RGBA_8888) {
        LOGD("Bitmap format is not RGBA_8888 !");
        return;
    }

    if ((ret = AndroidBitmap_lockPixels(env, bubbleBitmap, (void **) &bubblebuffer)) < 0) {
        assert(0);
    }
    initBubble(bubblebuffer, info.width, info.height);
    AndroidBitmap_unlockPixels(env, bubbleBitmap);
}

JNIEXPORT void JNICALL
Java_com_example_animation_animation_DRLib_showBubbles(JNIEnv *env, jobject object, jobject baseBitmap, int width, int height) {
    int ret;
    unsigned char *layerBuffer = NULL;
    if ((ret = AndroidBitmap_lockPixels(env, baseBitmap, (void **) &layerBuffer)) < 0) {
        assert(0);
    }
    bubbleCycle(layerBuffer, width, height);
    AndroidBitmap_unlockPixels(env, baseBitmap);
}

JNIEXPORT void JNICALL
Java_com_example_animation_animation_DRLib_addBubble(JNIEnv *env, jobject object, int x, int y) {
    addBubble(x, y);
}

JNIEXPORT void JNICALL
Java_com_example_animation_animation_DRLib_updateWave(JNIEnv *env, jobject object, jobject bitmap, int width, int height, double phase, double amplitude,
                                                      int color1, int color2) {
    unsigned char *bitmapBuffer;
    int ret;
    if ((ret = AndroidBitmap_lockPixels(env, bitmap, (void **) &bitmapBuffer)) < 0) {
        assert(0);
    }
    drawWave(bitmapBuffer, width, height, phase, amplitude, color1, color2);
    AndroidBitmap_unlockPixels(env, bitmap);
}
