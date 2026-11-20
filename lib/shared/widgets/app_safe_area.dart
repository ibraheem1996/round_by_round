import 'package:material_ui/material_ui.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class AppSafeArea extends StatelessWidget {
  const AppSafeArea({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NativeDeviceOrientedWidget(
      useSensor: false,

      portrait: (_) => SafeArea(child: child),

      landscapeLeft: (_) => SafeArea(
        top: false,
        bottom: true,
        left: true,
        right: false,
        child: child,
      ),

      landscapeRight: (_) => SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: true,
        child: child,
      ),

      fallback: (_) => SafeArea(child: child),
    );
  }
}
