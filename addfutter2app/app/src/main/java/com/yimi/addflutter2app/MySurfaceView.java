package com.yimi.addflutter2app;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.PorterDuff;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

public class MySurfaceView extends SurfaceView implements SurfaceHolder.Callback, Runnable {
    private static final String TAG = "YIMI-MySurfaceView";
    public static final int TIME_IN_FRAME = 30;

    private Paint mPaint;
    private boolean mIsRunning = false;
    private SurfaceHolder mSurfaceHolder;
    private Canvas mCanvas;

    private float mX = 0;
    private float mY = 0;

    private Thread thread;

    public MySurfaceView(Context context) {
        super(context);
        mPaint = new Paint();
        mPaint.setColor(Color.RED);
        mPaint.setStrokeWidth(3);

        mSurfaceHolder = getHolder();
        mSurfaceHolder.addCallback(this);
        setBackgroundColor(Color.WHITE);
        setZOrderOnTop(true);
        mSurfaceHolder.setFormat(PixelFormat.TRANSLUCENT);//使窗口支持透明度
    }

    private void draw() {
        mCanvas = mSurfaceHolder.lockCanvas();
        if (mCanvas == null) {
            return;
        }
        //mCanvas.save();
        drawInternal();
        //mCanvas.restore();
        mSurfaceHolder.unlockCanvasAndPost(mCanvas);//图形绘制完之后解锁画布
    }

    private void drawInternal() {
        mX++;
        if (mX >= getWidth() || mX <= 10) {
            mCanvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR);//绘制透明色
            if (mX >= getWidth()) {
                mX = 0;
            }
        } else {
            mY = (int) (100 * Math.sin(mX * 2 * Math.PI / 180) + 200);
            //Log.d(TAG, "drawInternal: " + mX + ", " + mY);
            mCanvas.drawPoint(mX, mY, mPaint);
        }
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        //draw();
        start();
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        stop();
    }

    @Override
    public void run() {
        while (mIsRunning) {
            long startTime = System.currentTimeMillis();
            synchronized (mSurfaceHolder) {
                draw();
            }

            long endTime = System.currentTimeMillis();
            int diffTime = (int) (endTime - startTime);

            while (diffTime <= TIME_IN_FRAME) {
                diffTime = (int) (System.currentTimeMillis() - startTime);
                Thread.yield();
            }
        }
    }

    private synchronized void start() {
        if (thread == null) {
            mIsRunning = true;
            thread = new Thread(this);
            thread.start();
        }
    }

    public synchronized void stop() {
        mIsRunning = false;
        thread = null;
    }

}
