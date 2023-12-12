package com.mapbox.android.core.location;

import android.content.Context;


public final class MyLocationEngineProvider {

  private MyLocationEngineProvider() {
    // prevent instantiation
  }

  public static LocationEngine getLocationEngine(Context context) {
    // 不能用谷歌，部分手机定位会闪退
    // FATAL EXCEPTION: main
    //  Process: cn.mepu.smart_farmland_protection.beta, PID: 13118
    //  java.lang.IncompatibleClassChangeError: Found interface com.google.android.gms.location.FusedLocationProviderClient, but class was expected (declaration of 'com.google.android.gms.location.FusedLocationProviderClient' appears in /data/app/~~NsfIYSqSF7ArbUQGlaE8Ag==/cn.mepu.smart_farmland_protection.beta-l7E2wWBYSgSHuSBp0SiF-Q==/base.apk)
    //  	at com.mapbox.android.core.location.GoogleLocationEngineImpl.requestLocationUpdates(GoogleLocationEngineImpl.java:58)
    //  	at com.mapbox.android.core.location.GoogleLocationEngineImpl.requestLocationUpdates(GoogleLocationEngineImpl.java:26)
    //  	at com.mapbox.android.core.location.LocationEngineProxy.requestLocationUpdates(LocationEngineProxy.java:34)
    //  	at com.mapbox.mapboxgl.MapboxMapController.startListeningForLocationUpdates(MapboxMapController.java:2011)
    //  	at com.mapbox.mapboxgl.MapboxMapController.updateMyLocationEnabled(MapboxMapController.java:1985)
    //  	at com.mapbox.mapboxgl.MapboxMapController.access$100(MapboxMapController.java:103)
    //  	at com.mapbox.mapboxgl.MapboxMapController$1.onStyleLoaded(MapboxMapController.java:152)
    //  	at com.mapbox.mapboxsdk.maps.MapboxMap.notifyStyleLoaded(MapboxMap.java:963)
    //  	at com.mapbox.mapboxsdk.maps.MapboxMap.onFinishLoadingStyle(MapboxMap.java:225)
    //  	at com.mapbox.mapboxsdk.maps.MapView$MapCallback.onDidFinishLoadingStyle(MapView.java:1383)
    //  	at com.mapbox.mapboxsdk.maps.MapChangeReceiver.onDidFinishLoadingStyle(MapChangeReceiver.java:198)
    //  	at com.mapbox.mapboxsdk.maps.NativeMapView.onDidFinishLoadingStyle(NativeMapView.java:1166)
    //  	at com.mapbox.mapboxsdk.maps.NativeMapView.nativeSetStyleJson(Native Method)
    //  	at com.mapbox.mapboxsdk.maps.NativeMapView.setStyleJson(NativeMapView.java:202)
    //  	at com.mapbox.mapboxsdk.maps.MapboxMap.setStyle(MapboxMap.java:945)
    //  	at com.mapbox.mapboxgl.MapboxMapController.setStyleString(MapboxMapController.java:262)
    //  	at com.mapbox.mapboxgl.MapboxMapController.onMapReady(MapboxMapController.java:250)
    //  	at com.mapbox.mapboxsdk.maps.MapView$MapCallback.onMapReady(MapView.java:1359)
    //  	at com.mapbox.mapboxsdk.maps.MapView$MapCallback.initialised(MapView.java:1345)
    //  	at com.mapbox.mapboxsdk.maps.MapView.initialiseMap(MapView.java:201)
    //  	at com.mapbox.mapboxsdk.maps.MapView.access$800(MapView.java:65)
    //  	at com.mapbox.mapboxsdk.maps.MapView$6.run(MapView.java:360)
    //  	at android.os.Handler.handleCallback(Handler.java:938)
    //  	at android.os.Handler.dispatchMessage(Handler.java:99)
    //  	at android.os.Looper.loopOnce(Looper.java:233)
    //  	at android.os.Looper.loop(Looper.java:344)
    //  	at android.app.ActivityThread.main(ActivityThread.java:8191)
    //  	at java.lang.reflect.Method.invoke(Native Method)
    //  	at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:584)
    //    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:1034)
    return new LocationEngineProxy<>(new MapboxFusedLocationEngineImpl(context.getApplicationContext()));
  }
}
