import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/authentication/presentation/login/login_cubit.dart';
import '../features/authentication/presentation/login/login_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../l10n/app_localizations.dart';
import 'app_route_guard.dart';
import 'theme/app_typography.dart';

GoRouter createAppRouter({
  required Listenable refreshListenable,
  required String? Function(Uri) redirect,
  required Future<void> Function() completeIntro,
  required Widget Function() buildStartup,
  required LoginCubit Function() createLogin,
}) {
  return GoRouter(
    refreshListenable: refreshListenable,
    redirect: (context, state) => redirect(state.uri),
    routes: [
      GoRoute(
        path: AppRoutes.startup,
        builder: (context, state) => buildStartup(),
      ),
      GoRoute(
        path: AppRoutes.home,
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
        path: AppRoutes.onboarding,
        builder: (context, state) => OnboardingPage(onComplete: completeIntro),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => createLogin(),
          child: const LoginPage(),
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
                    onPressed: () => context.go(AppRoutes.home),
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
