package com.example.animation.animation;

import android.graphics.Bitmap;

/**
 * Created by haijun on 2017/11/6.
 */

public class DRLib {
    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    public static native void updateWave(Bitmap bitmap, int width, int height, double phase, double amplitude, int color1, int color2);
    public static native void addBubble(int x, int y);
    public static native void initBubbles(Bitmap bubbleBitmap);


    public static native void showBubbles(Bitmap baseBitmap, int width, int height);

    // Used to load the 'native-lib' library on application startup.
    static {
        System.loadLibrary("native-lib");
    }
}
