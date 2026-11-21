import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../core/services/logger_service.dart';
import '../features/authentication/presentation/auth_cubit.dart';
import '../features/authentication/presentation/auth_state.dart';
import '../features/authentication/presentation/login_page.dart';
import '../features/onboarding/data/onboarding_completion.dart';
import '../l10n/app_localizations.dart';
import '../shared/design_system/app_spacing.dart';
import '../shared/widgets/app_page_frame.dart';
import 'app_router.dart';
import 'theme/app_theme.dart';
import 'theme/app_typography.dart';

typedef AppStartup = ({
  OnboardingCompletion onboardingCompletion,
  AuthCubit authCubit,
});

class MainApp extends StatefulWidget {
  const MainApp({required this.initialize, super.key});

  final Future<AppStartup> Function() initialize;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;
  final _routing = _RouteRefresh();
  AppStartup? _services;
  StreamSubscription<AuthState>? _authChanges;
  bool _onboardingComplete = false;
  bool _initializing = false;
  bool _initializationFailed = false;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      refreshListenable: _routing,
      entryLocation: _entryLocation,
      completeOnboarding: _completeOnboarding,
      buildStartup: _buildStartup,
      buildLogin: () => LoginPage(authCubit: _services!.authCubit),
    );
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    if (_initializing) return;
    _initializing = true;
    _initializationFailed = false;
    _routing.refresh();

    AppStartup? starting;
    try {
      starting = await widget.initialize();
      final completed = await starting.onboardingCompletion.read();
      if (!mounted) {
        await starting.authCubit.close();
        return;
      }
      _onboardingComplete = completed;
      _services = starting;
      _authChanges = starting.authCubit.stream.listen(
        (_) => _routing.refresh(),
      );
      unawaited(starting.authCubit.restoreSession());
    } catch (error) {
      await starting?.authCubit.close();
      LoggerService.warning(
        'App initialization failed (${error.runtimeType}).',
      );
      if (!mounted) return;
      _initializationFailed = true;
      _routing.refresh();
    } finally {
      _initializing = false;
    }
  }

  String _entryLocation() => switch (_services?.authCubit.state) {
    AuthSignedIn() => '/',
    AuthSignedOut() ||
    AuthSigningIn() => _onboardingComplete ? '/login' : '/onboarding',
    _ => '/startup',
  };

  Future<void> _completeOnboarding() async {
    await _services!.onboardingCompletion.save();
    if (!mounted) return;
    _onboardingComplete = true;
    _routing.refresh();
  }

  Widget _buildStartup() => ListenableBuilder(
    listenable: _routing,
    builder: (context, _) {
      final auth = _services?.authCubit;
      return _StartupPage(
        failed: _initializationFailed || auth?.state is AuthUnavailable,
        onRetry: auth?.restoreSession ?? _initialize,
      );
    },
  );

  @override
  void dispose() {
    _router.dispose();
    unawaited(_authChanges?.cancel());
    unawaited(_services?.authCubit.close());
    _routing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (preferred, supported) =>
          basicLocaleListResolution(preferred, [
            const Locale('ar'),
            ...supported.where((locale) => locale.languageCode != 'ar'),
          ]),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
    );
  }
}

final class _RouteRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

class _StartupPage extends StatelessWidget {
  const _StartupPage({required this.failed, required this.onRetry});

  final bool failed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      body: AppPageFrame(
        maxContentWidth: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!failed) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: AppSpacing.sectionGap),
              ],
              Text(
                failed ? strings.authStartupFailed : strings.authRestoring,
                style: context.appTypography.supportingBody,
                textAlign: TextAlign.center,
              ),
              if (failed) ...[
                const SizedBox(height: AppSpacing.sectionGap),
                FilledButton(
                  onPressed: onRetry,
                  child: Text(strings.authRetry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
