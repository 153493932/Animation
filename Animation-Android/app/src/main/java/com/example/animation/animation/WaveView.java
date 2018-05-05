package com.example.animation.animation;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceView;
import android.view.View;
import android.widget.ImageView;

/**
 * Created by haijun on 2017/11/6.
 */

public class WaveView extends View {

    public Handler handler;
    private Runnable runnable;
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


    public WaveView(Context context) {
        super(context);
        initResource();
    }

    public WaveView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        initResource();
    }

    public WaveView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initResource();

    }

    private void initResource() {
        handler = new Handler();
        runnable = new Runnable() {
            public void run() {
                invalidate();
            }
        };
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        baseBitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        srcRect = new Rect(0, 0, baseBitmap.getWidth(), baseBitmap.getHeight());
    }

    @Override
    public void onDraw(Canvas canvas) {
        //    super.onDraw(canvas);


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

        if (++index >= 20) {
            endTime = (System.currentTimeMillis() - startTime);
            Log.e("TAG", "endTime =" + endTime/index);
            startTime = System.currentTimeMillis();
            index = 0;
        }
//        invalidate();

        handler.postDelayed(runnable, (long) (Math.max(5.0d, 80.0d - endTime)));
    }
}
