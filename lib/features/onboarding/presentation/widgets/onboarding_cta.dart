import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_typography.dart';

class OnboardingCta extends StatelessWidget {
  const OnboardingCta({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    final amber = theme.colorScheme.primary;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFC2410C),
        textStyle: context.appTypography.buttonLabel,
        minimumSize: const Size(48, 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(label, textAlign: TextAlign.center)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 20),
        ],
      ),
    );
  }
}
