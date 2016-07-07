package com.native_navigator;

import android.app.Activity;
import android.app.Application;
import android.content.Context;

import com.facebook.react.LifecycleState;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.modules.core.ExceptionsManagerModule;
import com.facebook.react.shell.MainReactPackage;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;



public class ReactNativeCoordinator {
    private static ReactNativeCoordinator _instance = null;

    ReactInstanceManager manager;
    private boolean initialized = false;
    private Map<String, ReactNativeActivity> activityMap;


    public static ReactNativeCoordinator getInstance() {
        if (_instance == null) {
            _instance = new ReactNativeCoordinator();
        }
        return _instance;
    }

    void initialize(Context context) {
        if (initialized) {
            return;
        }
        initialized = true;
        activityMap = new HashMap<>();
        manager = ReactInstanceManager.builder()
                .setApplication((Application)context.getApplicationContext())
                .setBundleAssetName("index.js") // file name to be used locally
                .setJSMainModuleName("index.android") // file name to be used for packager
                .addPackage(new MainReactPackage())
                .addPackage(new NativeNavigatorPackage())
                .setUseDeveloperSupport(true)
                .setInitialLifecycleState(LifecycleState.BEFORE_RESUME)
                .build();

    }

    private ReactNativeCoordinator() {

    }

    void registerRNActivity(ReactNativeActivity activity, String name) {
        activityMap.put(name, activity);
    }

    void unregisterRNActivity(String name) {
        activityMap.remove(name);
    }

    ReactNativeActivity activityFromId(String id) {
        return activityMap.get(id);
    }

    Activity getCurrentActivity() {
        try {
            Class activityThreadClass = Class.forName("android.app.ActivityThread");
            Object activityThread = activityThreadClass.getMethod("currentActivityThread").invoke(null);
            Field activitiesField = activityThreadClass.getDeclaredField("mActivities");
            activitiesField.setAccessible(true);
            Map activities = (Map) activitiesField.get(activityThread);
            for (Object activityRecord : activities.values()) {
                Class activityRecordClass = activityRecord.getClass();
                Field pausedField = activityRecordClass.getDeclaredField("paused");
                pausedField.setAccessible(true);
                if (!pausedField.getBoolean(activityRecord)) {
                    Field activityField = activityRecordClass.getDeclaredField("activity");
                    activityField.setAccessible(true);
                    return (Activity) activityField.get(activityRecord);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
