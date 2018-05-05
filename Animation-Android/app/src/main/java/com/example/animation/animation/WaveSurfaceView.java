package com.example.animation.animation;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

/**
 * Created by haijun on 2017/11/13.
 */

class WaveSurfaceView extends SurfaceView implements SurfaceHolder.Callback, Runnable {

    // SurfaceHolder
    private SurfaceHolder surfaceHolder;
    // 画布
    private Canvas canvas;
    // 子线程标志位
    private boolean isDrawing;

    private Bitmap baseBitmap;
    private float startPhase = 0.0f;
    private float waveHeight = 0.0f;
    private float amplitude = 20.0f;
    private float restAmplitude = 20.0f;
    private float speed = 0.02f;
    private float restSpeed = 0.2f;
    private Rect srcRect;
    private int index;
    private long startTime, endTime;

    public WaveSurfaceView(Context context) {
        super(context);
        init();
    }

    public WaveSurfaceView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public WaveSurfaceView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        surfaceHolder = getHolder();
        surfaceHolder.addCallback(this);
        setFocusable(true);
        setFocusableInTouchMode(true);
        this.setKeepScreenOn(true);


    }


    @Override
    public void surfaceCreated(SurfaceHolder holder) {

    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        isDrawing = true;
        baseBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        srcRect = new Rect(0, 0, baseBitmap.getWidth(), baseBitmap.getHeight());
        new Thread(this).start();
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        baseBitmap.recycle();
        baseBitmap = null;
    }

    @Override
    public void run() {


        while (isDrawing && baseBitmap != null) {

            drawing();

            if (++index >= 20) {
                endTime = (System.currentTimeMillis() - startTime);
                Log.e("TAG", "endTime =" + endTime/index);
                startTime = System.currentTimeMillis();
                index = 0;
            }


//            try {
//                Thread.sleep(80 - (endTime - startTime));
//            } catch (InterruptedException e) {
//                e.printStackTrace();
//            }
        }
    }

    private void drawing() {
        try {
            canvas = surfaceHolder.lockCanvas();
            if (speed >= restSpeed) {
                speed -= 0.0004;
            }

            if (speed < restSpeed) {
                speed += 0.0008;
            }

            if (amplitude >= restAmplitude) {
                amplitude -= 0.00005;
            }

            if (amplitude < restAmplitude) {
                amplitude += 0.0001;
            }

            startPhase += speed;

            DRLib.updateWave(baseBitmap, baseBitmap.getWidth(), baseBitmap.getHeight(), startPhase, amplitude, 0x88F0FFFF, 0xa0ffffFF);
            canvas.drawBitmap(baseBitmap, srcRect, srcRect, null);

        } finally {
            if (canvas != null) {
                surfaceHolder.unlockCanvasAndPost(canvas);
            }
        }
    }

}
