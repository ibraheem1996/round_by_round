import 'package:material_ui/material_ui.dart';

import '../../../../app/responsive/app_responsive.dart';
import '../../../../app/theme/app_typography.dart';
import 'onboarding_cta.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    required this.title,
    required this.emphasis,
    required this.description,
    required this.index,
    required this.count,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String emphasis;
  final String description;
  final int index;
  final int count;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final window = context.responsive;
    final inset = window.byWidth(compact: 24.0, expanded: 36.0);
    final gap = window.byHeight(short: 16.0, regular: 26.0);
    final colors = Theme.of(context).colorScheme;
    final typography = context.appTypography;

    final copy = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: '$title\n',
            children: [
              TextSpan(
                text: emphasis,
                style: TextStyle(color: colors.primary),
              ),
            ],
          ),
          style: typography.pageTitle,
        ),
        const SizedBox(height: 12),
        Text(description, style: typography.supportingBody),
        SizedBox(height: gap),
        Row(
          spacing: 8,
          children: [
            for (var dot = 0; dot < count; dot++)
              Container(
                width: dot == index ? 36 : 20,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: dot == index
                      ? colors.primary
                      : colors.onSurface.withValues(alpha: 0.22),
                ),
              ),
          ],
        ),
      ],
    );

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 544),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: inset, vertical: gap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      key: ValueKey(index),
                      primary: false,
                      hitTestBehavior: HitTestBehavior.translucent,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.bottomStart,
                          // Let horizontal drags reach the pager behind the copy.
                          child: IgnorePointer(child: copy),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: gap),
                OnboardingCta(label: actionLabel, onPressed: onPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
