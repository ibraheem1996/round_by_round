import 'package:material_ui/material_ui.dart';

/// Fills the bounds supplied by the screen, independently of foreground insets.
class OnboardingBackdrop extends StatelessWidget {
  const OnboardingBackdrop({
    required this.image,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  final String image;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final surface = colors.surface;

    return IgnorePointer(
      child: ColoredBox(
        color: surface,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, alignment: alignment, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.35),
                  radius: 0.9,
                  colors: [
                    colors.primary.withValues(alpha: 0.12),
                    surface.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    surface.withValues(alpha: 0.55),
                    surface.withValues(alpha: 0),
                    surface,
                  ],
                  stops: const [0, 0.3, 0.94],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
