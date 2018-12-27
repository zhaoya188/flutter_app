package com.yimi.addflutter2app;

import android.content.Context;
import android.graphics.PixelFormat;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;

public class SurfaceViewHelper {

    private WindowManager.LayoutParams wmParams;
    private WindowManager mWindowManager;
    private float x;
    private float y;
    private static final int WIDTH = 400;
    private static final int HEIGHT = 400;
    private int screenWidth;
    private Context mContext;
    private View surfaceViewContainer;
    private ViewGroup localVideoLayout;
    private MySurfaceView surfaceView;

    public SurfaceViewHelper(Context context) {
        this.mContext = context;
        wmParams = new WindowManager.LayoutParams();
        mWindowManager = (WindowManager) mContext.getSystemService(mContext.WINDOW_SERVICE);
        wmParams.type = WindowManager.LayoutParams.TYPE_APPLICATION;
        wmParams.format = PixelFormat.RGBA_8888;
        wmParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL;
        wmParams.gravity = Gravity.RIGHT | Gravity.TOP;
        wmParams.width = WIDTH;
        wmParams.height = HEIGHT;

        DisplayMetrics metric = new DisplayMetrics();
        mWindowManager.getDefaultDisplay().getMetrics(metric);
        screenWidth = metric.widthPixels;

        createFloatView();
    }

    public void open() {
        if (surfaceView != null) {
            return;
        }
        mWindowManager.addView(surfaceViewContainer, wmParams);
        surfaceView = new MySurfaceView(mContext);
        localVideoLayout.addView(surfaceView);
    }

    public void close() {
        if (surfaceView == null) {
            return;
        }
        mWindowManager.removeViewImmediate(surfaceViewContainer);
        surfaceView.stop();
        surfaceView = null;
        localVideoLayout.removeAllViews();
    }

    private void createFloatView() {
        LayoutInflater inflater = LayoutInflater.from(mContext);
        surfaceViewContainer = inflater.inflate(R.layout.view_board_video_netease, null);
        localVideoLayout = (ViewGroup) surfaceViewContainer.findViewById(R.id.user_local_view);
        ImageView btnVideoClose = (ImageView) surfaceViewContainer.findViewById(R.id.btn_video_close);

        surfaceViewContainer.setOnTouchListener(new View.OnTouchListener() {
            float mTouchStartX;
            float mTouchStartY;
            int moveTime = 0;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                x = screenWidth - event.getRawX();
                y = event.getRawY();

                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        mTouchStartX = event.getX();
                        mTouchStartY = event.getY();
                        moveTime = 0;
                        break;

                    case MotionEvent.ACTION_MOVE:
                        moveTime++;
                        if (moveTime > 6) {
                            wmParams.x = (int) (x - mTouchStartX - (WIDTH / 2 - mTouchStartX));
                            //wmParams.x=(int) x;
                            wmParams.y = (int) (y - mTouchStartY);
                            mWindowManager.updateViewLayout(v, wmParams);
                        }
                        break;

                    case MotionEvent.ACTION_UP:
                        mTouchStartX = mTouchStartY = 0;
                        break;
                }

                return true;
            }
        });

        btnVideoClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                close();
            }
        });
    }

}
