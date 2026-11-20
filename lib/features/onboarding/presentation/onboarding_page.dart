import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/assets/app_assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/app_responsive_value.dart';
import '../../../shared/design_system/app_text_scale_limits.dart';
import 'widgets/onboarding_backdrop.dart';
import 'widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.onComplete, super.key});

  final Future<void> Function() onComplete;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _advance(bool isLast) async {
    if (_saving ||
        !_controller.hasClients ||
        _controller.position.isScrollingNotifier.value) {
      return;
    }

    if (!isLast) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onComplete();
    } on Exception {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.onboardingSaveFailed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final slides = [
      (
        title: strings.onboardingLogTitle,
        emphasis: strings.onboardingLogEmphasis,
        description: strings.onboardingLogDescription,
        image: AppAssets.onboardingGrip,
      ),
      (
        title: strings.onboardingPreviousTitle,
        emphasis: strings.onboardingPreviousEmphasis,
        description: strings.onboardingPreviousDescription,
        image: AppAssets.onboardingDeadlift,
      ),
      (
        title: strings.onboardingRoutinesTitle,
        emphasis: strings.onboardingRoutinesEmphasis,
        description: strings.onboardingRoutinesDescription,
        image: AppAssets.onboardingWeightPlates,
      ),
    ];
    final slide = slides[_index];
    final isLast = _index == slides.length - 1;
    final alignment = AppResponsiveValue.isCompact(context)
        ? Alignment.topCenter
        : const Alignment(0, -0.22);

    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: AppTextScaleLimits.onboarding,
          child: Theme(
            data: darkTheme,
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) => setState(() => _index = index),
                    physics: _saving
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    itemCount: slides.length,
                    itemBuilder: (context, index) => OnboardingBackdrop(
                      image: slides[index].image,
                      alignment: alignment,
                    ),
                  ),
                  OnboardingContent(
                    title: slide.title,
                    emphasis: slide.emphasis,
                    description: slide.description,
                    index: _index,
                    count: slides.length,
                    actionLabel: isLast
                        ? strings.onboardingStart
                        : strings.onboardingContinue,
                    onPressed: _saving ? null : () => _advance(isLast),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
