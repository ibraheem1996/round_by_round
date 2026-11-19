import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';

GoRouter createAppRouter() => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Center(child: Text(AppLocalizations.of(context)!.appName)),
        ),
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
