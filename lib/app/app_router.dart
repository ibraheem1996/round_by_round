import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/account_setup/presentation/account_setup_cubit.dart';
import '../features/account_setup/presentation/account_setup_page.dart';
import '../features/authentication/presentation/login/login_cubit.dart';
import '../features/authentication/presentation/login/login_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../l10n/app_localizations.dart';
import 'app_route_guard.dart';
import 'startup/app_entry_cubit.dart';
import 'startup/app_entry_state.dart';
import 'startup/startup_page.dart';
import 'theme/app_typography.dart';

GoRouter createAppRouter({
  required AppEntryCubit entry,
  required LoginCubit Function() createLogin,
  required AccountSetupCubit Function(String uid) createAccountSetup,
}) {
  return GoRouter(
    redirect: (_, state) =>
        appRouteRedirect(state.uri, entry.state.destination),
    routes: [
      GoRoute(
        path: AppRoutes.startup,
        builder: (_, _) => BlocBuilder<AppEntryCubit, AppEntryState>(
          builder: (_, state) => StartupPage(
            checkingAccount: state.activeUid != null,
            onRetry: switch (state) {
              EntrySessionUnavailable() ||
              EntryAccountUnavailable() => entry.retry,
              _ => null,
            },
          ),
        ),
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
        builder: (_, _) => OnboardingPage(onComplete: entry.completeIntro),
      ),
      GoRoute(
        path: AppRoutes.accountSetup,
        builder: (_, _) => BlocSelector<AppEntryCubit, AppEntryState, String?>(
          selector: (state) => switch (state) {
            EntrySetupRequired(:final uid) => uid,
            _ => null,
          },
          builder: (_, uid) {
            if (uid == null) {
              return const StartupPage(checkingAccount: true);
            }
            return BlocProvider(
              key: ValueKey(uid),
              create: (_) => createAccountSetup(uid),
              child: BlocListener<AccountSetupCubit, AccountSetupState>(
                listenWhen: (_, current) =>
                    current.saveStatus == WeightSaveStatus.saved,
                listener: (_, _) => entry.completeAccountSetup(uid),
                child: const AccountSetupPage(),
              ),
            );
          },
        ),
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

void refreshAppRoute(GoRouter router, EntryDestination destination) {
  final redirect = appRouteRedirect(
    router.routeInformationProvider.value.uri,
    destination,
  );
  // Replace the stack when the entry gate changes the destination.
  if (redirect != null) router.go(redirect);
}
