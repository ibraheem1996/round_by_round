import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/onboarding/presentation/onboarding_page.dart';
import '../l10n/app_localizations.dart';
import 'theme/app_typography.dart';

GoRouter createAppRouter({
  required Listenable refreshListenable,
  required String Function() entryLocation,
  required Future<void> Function() completeOnboarding,
  required Widget Function() buildStartup,
  required Widget Function() buildLogin,
}) {
  return GoRouter(
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final path = state.uri.path;
      if (!const {'/', '/startup', '/onboarding', '/login'}.contains(path)) {
        return null;
      }
      final destination = entryLocation();
      return path == destination ? null : destination;
    },
    routes: [
      GoRoute(path: '/startup', builder: (context, state) => buildStartup()),
      GoRoute(
        path: '/',
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
        builder: (context, state) =>
            OnboardingPage(onComplete: completeOnboarding),
      ),
      GoRoute(path: '/login', builder: (context, state) => buildLogin()),
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
