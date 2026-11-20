import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/shared/design_system/app_responsive_value.dart';

import '../../../../app/theme/app_typography.dart';
import '../../../../shared/design_system/app_radius.dart';
import '../../../../shared/design_system/app_spacing.dart';
import '../../../../shared/widgets/app_page_frame.dart';
import '../../../../shared/widgets/app_safe_area.dart';
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

  static const double _maxForegroundWidth = 544;
  static const double _minHeightForPinnedAction = 200;

  @override
  Widget build(BuildContext context) {
    double activeMarkerWidth = AppResponsiveValue.resolve(
      context,
      compact: 37,
      medium: 39,
      expanded: 41,
    );
    double inactiveMarkerWidth = AppResponsiveValue.resolve(
      context,
      compact: 21,
      medium: 23,
      expanded: 25,
    );

    double markerHeight = AppResponsiveValue.resolve(
      context,
      compact: 7,
      medium: 8,
      expanded: 9,
    );

    final colors = Theme.of(context).colorScheme;
    final typography = context.appTypography;

    // Let horizontal drags over the copy reach the pager.
    final copy = IgnorePointer(
      child: Column(
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
          const SizedBox(height: AppSpacing.titleToBodyGap),
          Text(description, style: typography.supportingBody),
          const SizedBox(height: AppSpacing.sectionGap),
          Wrap(
            spacing: AppSpacing.relatedItemGap,
            runSpacing: AppSpacing.relatedItemGap,
            children: [
              for (var dot = 0; dot < count; dot++)
                Container(
                  width: dot == index ? activeMarkerWidth : inactiveMarkerWidth,
                  height: markerHeight,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppRadius.progressIndicatorRadius),
                    ),
                    color: dot == index
                        ? colors.primary
                        : colors.onSurface.withValues(alpha: 0.22),
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    final action = Align(
      child: OnboardingCta(label: actionLabel, onPressed: onPressed),
    );

    Widget scroll(Widget child) => SingleChildScrollView(
      key: ValueKey(index),
      primary: false,
      hitTestBehavior: HitTestBehavior.translucent,
      child: child,
    );

    return AppSafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxForegroundWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Keep the action in the scroll when a pinned button leaves too little reading space.
            return Padding(
              padding: AppScreenInsets.resolve(constraints),
              child: constraints.maxHeight < _minHeightForPinnedAction
                  ? scroll(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          copy,
                          const SizedBox(height: AppSpacing.sectionGap),
                          action,
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) => scroll(
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional.bottomStart,
                                  child: copy,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),

                        action,
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
