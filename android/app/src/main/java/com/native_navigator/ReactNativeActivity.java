package com.native_navigator;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Toolbar;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter;

import java.util.Locale;

/**
 * Created by leland_richardson on 6/19/16.
 */

public class ReactNativeActivity
        extends Activity
        implements
            DefaultHardwareBackBtnHandler,
            Toolbar.OnMenuItemClickListener,
            View.OnClickListener {
    private static final String REACT_MODULE_NAME = "REACT_MODULE_NAME";
    private static final String REACT_PROPS = "REACT_PROPS";

    private static int _uuid = 1;

    private String moduleName;
    private Bundle props;
    private String activityId;
    private String getActivityId() {
        if (activityId == null) {
            activityId = String.format(Locale.ENGLISH, "%1s_%2$d", moduleName, _uuid++);
        }
        return activityId;
    }

    private Toolbar toolbar;
    private ReactRootView reactRootView;


    private ReactInstanceManager getReactInstanceManager() {
        return ReactNativeCoordinator.getInstance().manager;
    }

    protected static Intent intent(Context context, String moduleName, Bundle props, boolean isModal) {
        Class<? extends ReactNativeActivity> activityClass =
                isModal
                        ? ReactNativeModalActivity.class
                        : ReactNativeActivity.class;
        return new Intent(context, activityClass)
                .putExtra(REACT_MODULE_NAME, moduleName)
                .putExtra(REACT_PROPS, props);
    }

    protected static Intent intent(Context context, String moduleName, Bundle props) {
        return intent(context, moduleName, props, false);
    }

    protected static Intent intent(Context context, String moduleName, boolean isModal) {
        return intent(context, moduleName, null, isModal);
    }

    protected static Intent intent(Context context, String moduleName) {
        return intent(context, moduleName, null, false);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_react_native);

        moduleName = getIntent().getStringExtra(REACT_MODULE_NAME);
        props = getIntent().getBundleExtra(REACT_PROPS);
        props.putString("viewControllerId", getActivityId());

        ReactNativeCoordinator.getInstance().registerRNActivity(this, getActivityId());

        toolbar = (Toolbar)findViewById(R.id.toolbar);
        toolbar.setOnMenuItemClickListener(this);
        toolbar.setNavigationOnClickListener(this);

        toolbar.setTitle("");
        toolbar.setNavigationIcon(R.drawable.n2_ic_arrow_back_black);
        setActionBar(toolbar);

        reactRootView = (ReactRootView)findViewById(R.id.reactRootView);
        reactRootView.setBackgroundColor(Color.WHITE);
        reactRootView.startReactApplication(getReactInstanceManager(), moduleName, props);
    }

    public Toolbar getToolbar() {
        return toolbar;
    }

    public void setLeftIcon(String icon) {
        if (icon != null) {
            // TODO(lmr): map string icons to resources
            toolbar.setNavigationIcon(R.drawable.n2_ic_arrow_back_black);
        } else {
            toolbar.setNavigationIcon(null);
        }
    }

    public void setTitle(String title) {
        toolbar.setTitle(title);
    }

    public void setSubtitle(String subtitle) {
        toolbar.setSubtitle(subtitle);
    }

    public void setMenuItems() {
        toolbar.setOverflowIcon(getDrawable(R.drawable.n2_ic_am_tv));
//        toolbar.inflateMenu();


    }


    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (BuildConfig.DEBUG && keyCode == KeyEvent.KEYCODE_MENU && getReactInstanceManager() != null) {
            getReactInstanceManager().showDevOptionsDialog();
            return true;
        }
        return super.onKeyUp(keyCode, event);
    }

    @Override
    public void onBackPressed() {
        Log.d("NNavigator", String.format("onBackPressed: %1s", getActivityId()));
        if (getReactInstanceManager() != null) {
            getReactInstanceManager().onBackPressed();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public void invokeDefaultOnBackPressed() {
        super.onBackPressed();
    }

    @Override
    protected void onPause() {
        super.onPause();
        Log.d("NNavigator", String.format("onPause: %1s", getActivityId()));
        ReactNativeCoordinator.getInstance().unregisterRNActivity(getActivityId());
        if (getReactInstanceManager() != null) {
            getReactInstanceManager().onHostPause();
        }
        emitEvent("onDisappear", null);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d("NNavigator", String.format("onResume: %1s", getActivityId()));
        ReactNativeCoordinator.getInstance().registerRNActivity(this, getActivityId());
        if (getReactInstanceManager() != null) {
            getReactInstanceManager().onHostResume(this, this);
        }
        emitEvent("onAppear", null);
    }

    private void emitEvent(String eventName, Object object) {
        ReactContext reactContext = getReactInstanceManager()
                .getCurrentReactContext();
        if (reactContext == null) {
            Log.d("NNavigator", "reactContext is null");
            return;
        }
        RCTDeviceEventEmitter eventEmitter = reactContext.getJSModule(RCTDeviceEventEmitter.class);
        if (eventEmitter == null) {
            Log.d("NNavigator", "eventEmitter is null");
            return;
        }

        String key = String.format(Locale.ENGLISH, "NNNavigatorScene.%s.%s", eventName, getActivityId());
        Log.d("NNavigator", key);
        eventEmitter.emit(key, object);
    }

    @Override
    public boolean onMenuItemClick(MenuItem item) {
        // TODO(lmr): pass event data... or send specific event for each item
        emitEvent("onRightPress", null);
        return false;
    }

    @Override
    public void onClick(View v) {
        emitEvent("onLeftPress", null);
    }
}
