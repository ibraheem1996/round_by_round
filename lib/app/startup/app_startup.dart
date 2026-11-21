import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/services/logger_service.dart';
import '../../features/authentication/presentation/login/login_cubit.dart';
import '../../features/authentication/presentation/session/session_cubit.dart';
import '../../features/authentication/presentation/session/session_state.dart';
import '../../features/onboarding/data/onboarding_intro_completion.dart';
import '../app.dart';
import '../app_route_guard.dart';
import '../app_router.dart';
import 'startup_page.dart';

/// Coordinates initialization and keeps the router alive through startup retries.
class AppStartup extends StatefulWidget {
  const AppStartup({
    required this.initialize,
    required this.getIntroCompletion,
    required this.createLogin,
    super.key,
  });

  final Future<void> Function() initialize;

  final OnboardingIntroCompletion Function() getIntroCompletion;

  final LoginCubit Function() createLogin;

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  late final GoRouter _router;
  final _routing = _RouteRefresh();
  SessionCubit? _sessionCubit;

  OnboardingIntroCompletion? _introCompletion;

  StreamSubscription<SessionState>? _sessionChanges;
  bool _introCompleted = false;
  bool _initializing = false;
  bool _initializationFailed = false;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      refreshListenable: _routing,
      redirect: (uri) => appRouteRedirect(
        uri,
        session: _sessionCubit?.state ?? SessionState.restoring(),
        introCompleted: _introCompleted,
      ),
      completeIntro: _completeIntro,
      buildStartup: _buildStartup,
      createLogin: widget.createLogin,
    );
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    if (_initializing) return;
    _initializing = true;
    if (_initializationFailed) {
      _initializationFailed = false;
      _routing.refresh();
    }

    try {
      // 1. Initialize Firebase
      await widget.initialize();
      if (!mounted) return;

      // 2. Read onboarding completion
      final introCompletion = widget.getIntroCompletion();
      final completed = await introCompletion.read();
      if (!mounted) return;

      // 3. Resolve SessionCubit after initialization
      final session = context.read<SessionCubit>();

      // 4. Save initialized dependencies and state
      _introCompletion = introCompletion;
      _introCompleted = completed;
      _sessionCubit = session;

      // 5. Listen to session changes
      _sessionChanges = session.stream.listen((_) => _routing.refresh());

      // 6. Refresh routing and restore the session
      _routing.refresh();
      unawaited(session.restoreSession());
    } catch (error) {
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

  Future<void> _completeIntro() async {
    await _introCompletion!.save();
    if (!mounted) return;
    _introCompleted = true;
    _routing.refresh();
  }

  Widget _buildStartup() {
    return ListenableBuilder(
      listenable: _routing,
      builder: (context, _) => StartupPage(
        failed:
            _initializationFailed || _sessionCubit?.state is SessionUnavailable,
        onRetry: () {
          if (_initializationFailed) {
            unawaited(_initialize());
          } else {
            unawaited(_sessionCubit?.restoreSession());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    unawaited(_sessionChanges?.cancel());
    _routing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MainApp(router: _router);
}

final class _RouteRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}
