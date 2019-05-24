package com.example.mobile_app;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements  SensorEventListener {
    private static final  String Channel = "android-sensor";
    private static final String ToastChannel = "android-toast";
    SensorManager sensorManager;
    Sensor sensor;
    private EventChannel.EventSink sEventSink;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      GeneratedPluginRegistrant.registerWith(this);
       sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
       sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
        sensorManager.registerListener(this,sensor,SensorManager.SENSOR_DELAY_FASTEST);

        new MethodChannel(getFlutterView(),ToastChannel).setMethodCallHandler(
                (methodCall, result) ->  {
                    if (methodCall.method.equals("showToast")) {
                        Toast.makeText(getApplicationContext(),methodCall.argument("message") , Toast.LENGTH_LONG).show();
                        result.success("done");
                    }else  {
                        result.notImplemented();
                    }
                }
        );


      new EventChannel(getFlutterView(),Channel).setStreamHandler(
              new EventChannel.StreamHandler() {
                  @Override
                  public void onListen(Object o, EventChannel.EventSink eventSink) {
                      sEventSink = eventSink;
                  }

                  @Override
                  public void onCancel(Object o) {
                      sEventSink = null;
                  }
              }
      );
  }

    @Override
    public void onSensorChanged(SensorEvent event) {
      if (sEventSink != null) {
          sEventSink.success(event.values[0]);
      }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // nothing
    }
}

