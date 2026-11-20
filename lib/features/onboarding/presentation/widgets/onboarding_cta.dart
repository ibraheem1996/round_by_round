import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_typography.dart';
import '../../../../shared/design_system/app_control_sizes.dart';
import '../../../../shared/design_system/app_icon_sizes.dart';
import '../../../../shared/design_system/app_radius.dart';
import '../../../../shared/design_system/app_spacing.dart';

class OnboardingCta extends StatelessWidget {
  const OnboardingCta({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  static const double _minWidthForInlineLabel = 120;

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppRadius.primaryButtonRadius),
      ),
    );
    final amber = Theme.of(context).colorScheme.primary;
    final style = context.appTypography.buttonLabel;
    final iconSize = AppIconSizes.buttonAction(context);
    final labelText = Text(label, textAlign: TextAlign.center);
    final arrow = Icon(Icons.arrow_forward, size: iconSize);

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFC2410C),
        textStyle: style,
        minimumSize: const Size(
          AppControlSizes.minimumTapTarget,
          AppControlSizes.primaryButtonMinHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonHorizontalPadding,
          vertical: AppSpacing.buttonVerticalPadding,
        ),
        shape: shape,
        elevation: 4,
        shadowColor: amber.withValues(alpha: 0.5),
        backgroundBuilder: (context, states, child) =>
            states.contains(WidgetState.disabled)
            ? child!
            : Ink(
                decoration: ShapeDecoration(
                  shape: shape,
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    // Keep the warm gradient behind white text within contrast range.
                    colors: [
                      Color.lerp(const Color(0xFFF97316), Colors.black, 0.27)!,
                      Color.lerp(amber, Colors.black, 0.18)!,
                      const Color(0xFFC2410C),
                    ],
                  ),
                ),
                child: child,
              ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth < _minWidthForInlineLabel
            ? Column(
                mainAxisSize: .min,
                spacing: AppSpacing.relatedItemGap,
                children: [labelText, arrow],
              )
            : ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Row(
                  mainAxisAlignment: .center,
                  spacing: AppSpacing.relatedItemGap,
                  children: [
                    Flexible(child: labelText),
                    arrow,
                  ],
                ),
              ),
      ),
    );
  }
}
