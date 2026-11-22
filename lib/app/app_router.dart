import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/account_setup/presentation/account_setup_cubit.dart';
import '../features/account_setup/presentation/account_setup_page.dart';
import '../features/account_setup/presentation/account_setup_state.dart';
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
  required Listenable refreshListenable,
  required LoginCubit Function() createLogin,
  required AccountSetupCubit Function(String uid) createAccountSetup,
}) {
  return GoRouter(
    refreshListenable: refreshListenable,
    redirect: (_, state) =>
        appRouteRedirect(state.uri, entry.state.destination),
    routes: [
      GoRoute(
        path: AppRoutes.startup,
        builder: (_, _) => BlocBuilder<AppEntryCubit, AppEntryState>(
          builder: (_, state) => StartupPage(
            checkingAccount: state.activeAccount != null,
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
        builder: (_, _) =>
            BlocSelector<AppEntryCubit, AppEntryState, EntryAccount?>(
              selector: (state) => switch (state) {
                EntrySetupRequired(:final account) => account,
                _ => null,
              },
              builder: (_, account) {
                // Dispose the old form even if a quick UID switch keeps the URI.
                if (account == null) {
                  return const StartupPage(checkingAccount: true);
                }
                return BlocProvider(
                  key: ValueKey(account.lifetime),
                  create: (_) => createAccountSetup(account.uid),
                  child: BlocListener<AccountSetupCubit, AccountSetupState>(
                    listenWhen: (_, current) => current is AccountSetupSaved,
                    listener: (_, _) => entry.completeAccountSetup(account),
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
