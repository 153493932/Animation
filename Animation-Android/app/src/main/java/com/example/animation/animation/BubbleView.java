package com.example.animation.animation;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

/**
 * Created by haijun on 2017/11/8.
 */

public class BubbleView extends View {

    public Handler handler;
    private Runnable runnable;
    private Bitmap baseBitmap;
    private Rect srcRect;

    public BubbleView(Context context) {
        super(context);
        initResource();
    }

    public BubbleView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        initResource();
    }

    public BubbleView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
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
        Bitmap bubbleBitmap = BitmapFactory.decodeResource(this.getResources(), R.mipmap.particle_bubble).copy(Bitmap.Config.ARGB_8888, true);
        DRLib.initBubbles(bubbleBitmap);
        srcRect = new Rect(0, 0, baseBitmap.getWidth(), baseBitmap.getHeight());
    }

    @Override
    public void onDraw(Canvas canvas) {
        long startTime = System.currentTimeMillis(), endTime;

        DRLib.showBubbles(baseBitmap, baseBitmap.getWidth(),baseBitmap.getHeight());
        canvas.drawBitmap(baseBitmap, srcRect, srcRect, null);

        endTime = (System.currentTimeMillis() - startTime);
//        Log.e("TAG", "Bubble endTime =" + endTime);

        handler.postDelayed(runnable, (long) (Math.max(5.0d, 50.0d - endTime)));
    }


    @Override
    public boolean onTouchEvent(MotionEvent event) {
        int action = event.getAction();
        int pos_x = (int) event.getX(), pos_y = (int) event.getY();

        switch (action) {
            case MotionEvent.ACTION_DOWN:
                DRLib.addBubble(pos_x, pos_y);
                break;

            case MotionEvent.ACTION_MOVE:
                break;

            case MotionEvent.ACTION_UP:
                break;
        }

        return true;
    }
}
