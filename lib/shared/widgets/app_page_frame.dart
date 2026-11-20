import 'package:flutter/widgets.dart';

import '../design_system/app_spacing.dart';
import 'app_safe_area.dart';

class AppPageFrame extends StatelessWidget {
  const AppPageFrame({required this.child, this.maxContentWidth, super.key});

  final Widget child;
  final double? maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return AppSafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = AppScreenInsets.resolve(constraints);

          return Align(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth ?? double.infinity,
              ),
              child: Padding(padding: padding, child: child),
            ),
          );
        },
      ),
    );
  }
}

abstract final class AppScreenInsets {
  static EdgeInsets resolve(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    final isLandscape = width > height;
    final isVeryShort = height < 320;
    final isNarrow = width < 360;

    if (isVeryShort) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontalTight,
        vertical: AppSpacing.screenVerticalCompact,
      );
    }

    if (isLandscape) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontalCompact,
        vertical: AppSpacing.screenVerticalCompact,
      );
    }

    if (isNarrow) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontalCompact,
        vertical: AppSpacing.screenVerticalInset,
      );
    }

    return const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenHorizontalInset,
      vertical: AppSpacing.screenVerticalInset,
    );
  }
}
