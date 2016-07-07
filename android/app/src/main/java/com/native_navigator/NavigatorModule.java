package com.native_navigator;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import java.lang.reflect.Field;
import java.util.HashMap;

/**
 * Created by leland_richardson on 6/20/16.
 */

public class NavigatorModule extends ReactContextBaseJavaModule {

    public NavigatorModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNNNavigatorModule";
    }

    @ReactMethod
    public void setTitle(String id, final String title) {
        Log.d("NATIVE_NAVIGATOR", String.format("setTitle: %1s", id));
        final ReactNativeActivity activity = ReactNativeCoordinator.getInstance().activityFromId(id);
        if (activity == null) return;
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                activity.getToolbar().setTitle(title);
            }
        });
    }

    @ReactMethod
    public void setRightTitle(String id, String title) {

    }

    @ReactMethod
    public void setLeftIcon(String id, String leftIcon) {

    }

    @ReactMethod
    public void setTrailerButtons(String id, ReadableArray buttons) {

    }

    @ReactMethod
    public void push(String screenName, ReadableMap props, boolean animated) {
        Activity activity = ReactNativeCoordinator.getInstance().getCurrentActivity();
        Intent intent = ReactNativeActivity.intent(getReactApplicationContext(), screenName, new Bundle());
        activity.startActivity(intent);
    }

    @ReactMethod
    public void pushNative(String name, ReadableMap props, boolean animated) {

    }

    @ReactMethod
    public void present(String screenName, ReadableMap props, boolean animated) {
        Activity activity = ReactNativeCoordinator.getInstance().getCurrentActivity();
        Intent intent = ReactNativeModalActivity.intent(getReactApplicationContext(), screenName, new Bundle());
        activity.startActivity(intent);
    }

    @ReactMethod
    public void presentNative(String name, ReadableMap props, boolean animated) {

    }

    @ReactMethod
    public void dismiss(ReadableMap payload, boolean animated) {
        Activity activity = ReactNativeCoordinator.getInstance().getCurrentActivity();
        activity.finish();
    }

    @ReactMethod
    public void pop(ReadableMap payload, boolean animated) {
        Activity activity = ReactNativeCoordinator.getInstance().getCurrentActivity();
        activity.finish();
    }

    @ReactMethod
    public void setTabIndex(int index, boolean animated) {

    }
}
