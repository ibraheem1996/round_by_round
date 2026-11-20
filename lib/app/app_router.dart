import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/onboarding/presentation/onboarding_page.dart';
import '../l10n/app_localizations.dart';
import 'theme/app_typography.dart';

GoRouter createAppRouter({
  required bool initialOnboardingComplete,
  required Future<void> Function() saveOnboardingCompletion,
}) {
  var completed = initialOnboardingComplete;
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => completed ? null : '/onboarding',
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.appName,
                style: context.appTypography.pageTitle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        redirect: (context, state) => completed ? '/' : null,
        builder: (context, state) => OnboardingPage(
          onComplete: () async {
            await saveOnboardingCompletion();
            completed = true;
            if (context.mounted) context.go('/');
          },
        ),
      ),
    ],
    errorBuilder: (context, state) {
      final strings = AppLocalizations.of(context)!;
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: OverflowBar(
                alignment: MainAxisAlignment.start,
                overflowAlignment: OverflowBarAlignment.start,
                children: [
                  Text(strings.pageNotFound),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: Text(strings.backToStart),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
