import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class AppWheelPicker extends StatelessWidget {
  const AppWheelPicker({
    super.key,
    required this.controller,
    required this.itemExtent,
    required this.itemCount,
    required this.itemBuilder,
    required this.onSelectedItemChanged,
    this.visibleItemCount = 5,
    this.canEdit = true,
    this.enableHapticFeedback = true,
    this.enableSound = true,
  });

  final FixedExtentScrollController controller;
  final double itemExtent;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int> onSelectedItemChanged;
  final bool enableSound;

  final int visibleItemCount;
  final bool canEdit;
  final bool enableHapticFeedback;

  static const double _magnification = 1.15;
  static const double _squeeze = 1.40;
  static const double _diameterRatio = 1.35;
  static const double _unselectedOpacity = 0.3;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: itemExtent * visibleItemCount,
      child: AbsorbPointer(
        absorbing: !canEdit,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: itemExtent * _magnification,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            ListWheelScrollView.useDelegate(
              controller: controller,
              physics: const FixedExtentScrollPhysics(),
              itemExtent: itemExtent,
              diameterRatio: _diameterRatio,
              squeeze: _squeeze,
              useMagnifier: true,
              magnification: _magnification,
              overAndUnderCenterOpacity: _unselectedOpacity,
              onSelectedItemChanged: (index) {
                if (!canEdit) return;

                if (enableHapticFeedback) {
                  HapticFeedback.selectionClick();
                }

                if (enableSound) {
                  SystemSound.play(SystemSoundType.tick);
                }

                onSelectedItemChanged(index);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: itemCount,
                builder: itemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
