import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void mockDeviceOrientation(String orientation) {
  const methods = MethodChannel('native_device_orientation');
  const events = MethodChannel('native_device_orientation_events');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(methods, (call) async {
    return call.method == 'getOrientation' ? orientation : null;
  });
  messenger.setMockMethodCallHandler(events, (_) async => null);
  addTearDown(() {
    messenger.setMockMethodCallHandler(methods, null);
    messenger.setMockMethodCallHandler(events, null);
  });
}
