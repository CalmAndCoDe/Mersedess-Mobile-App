import 'package:flutter/services.dart';

void showToast(String message) {
  var platform = MethodChannel('android-toast');
  platform.invokeMethod('showToast', {"message": message});
}
