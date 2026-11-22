import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/shared/design_system/app_text_scale_value.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/assets/app_assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/app_control_sizes.dart';
import '../../../../shared/design_system/app_radius.dart';
import '../../../../shared/design_system/app_responsive_value.dart';
import '../../../../shared/design_system/app_spacing.dart';
import '../../../../shared/design_system/app_window_class.dart';
import '../../../../shared/widgets/app_page_frame.dart';
import '../../../../shared/widgets/app_safe_area.dart';
import '../../auth_gateway.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Theme(
        data: darkTheme,
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final short = isShortWindow(MediaQuery.sizeOf(context));
              final heroFraction = AppResponsiveValue.resolve(
                context,
                compact: AppTextScaleValue.resolve(
                  context,
                  normal: 0.44,
                  large: 0.41,
                  extraLarge: 0.39,
                ),
                medium: AppTextScaleValue.resolve(
                  context,
                  normal: 0.45,
                  large: 0.43,
                  extraLarge: 0.41,
                ),
                expanded: AppTextScaleValue.resolve(
                  context,
                  normal: 0.47,
                  large: 0.45,
                  extraLarge: 0.43,
                ),
              );
              final heroHeight = short
                  ? (height * .3).clamp(64.0, 140.0)
                  : (height * heroFraction).clamp(190.0, 430.0);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: heroHeight, child: const _LoginHero()),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: AppSafeArea(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 460),
                            child: Padding(
                              padding: AppScreenInsets.resolve(constraints),
                              child: BlocBuilder<LoginCubit, LoginState>(
                                builder: (context, state) => _LoginContent(
                                  state: state,
                                  onGoogle: () => context
                                      .read<LoginCubit>()
                                      .signIn(SignInProvider.google),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.onboardingGrip,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -.32),
          excludeFromSemantics: true,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                surface.withValues(alpha: .16),
                Colors.transparent,
                surface,
              ],
              stops: const [0, .24, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent({required this.state, required this.onGoogle});

  final LoginState state;
  final VoidCallback onGoogle;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final typography = context.appTypography;
    final signingIn = state is LoginSubmitting;
    final signInError = switch (state) {
      LoginFailure(error: SignInResult.networkError) => strings.authOffline,
      LoginFailure(error: SignInResult.serviceUnavailable) =>
        strings.authProviderUnavailable,
      LoginFailure(error: SignInResult.accountConflict) =>
        strings.authAccountConflict,
      LoginFailure(error: SignInResult.failed) => strings.authSignInFailed,
      _ => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          strings.authWelcome,
          style: typography.pageTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.titleToBodyGap),
        Text(
          strings.authDescription,
          style: typography.supportingBody,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        // Apple activation is deferred. Keep the button visible and inert.
        FilledButton(
          onPressed: null,
          style: FilledButton.styleFrom(
            disabledBackgroundColor: Colors.white,
            disabledForegroundColor: Colors.black,
            minimumSize: const Size(0, AppControlSizes.minimumTapTarget),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonHorizontalPadding,
              vertical: AppSpacing.buttonVerticalPadding,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.primaryButtonRadius),
              ),
            ),
            textStyle: typography.buttonLabel,
          ),
          child: Text(strings.authContinueApple, textAlign: TextAlign.center),
        ),
        const SizedBox(height: AppSpacing.relatedItemGap),
        OutlinedButton(
          onPressed: signingIn ? null : onGoogle,
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF131314),
            foregroundColor: const Color(0xFFE3E3E3),
            disabledForegroundColor: scheme.onSurfaceVariant,
            side: const BorderSide(color: Color(0xFF8E918F)),
            minimumSize: const Size(0, AppControlSizes.minimumTapTarget),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonHorizontalPadding,
              vertical: AppSpacing.buttonVerticalPadding,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.primaryButtonRadius),
              ),
            ),
            textStyle: typography.buttonLabel.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (signingIn)
                const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Image.asset(
                  AppAssets.googleSignIn,
                  width: AppTextScaleValue.resolve(
                    context,
                    normal: 30,
                    large: 33,
                    extraLarge: 35,
                  ),
                  height: AppTextScaleValue.resolve(
                    context,
                    normal: 30,
                    large: 33,
                    extraLarge: 35,
                  ),
                  excludeFromSemantics: true,
                ),
              const SizedBox(width: AppSpacing.relatedItemGap),
              Flexible(
                child: Text(
                  signingIn
                      ? strings.authSigningIn
                      : strings.authContinueGoogle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        if (signInError != null) ...[
          const SizedBox(height: AppSpacing.relatedItemGap),
          Text(
            signInError,
            style: typography.supportingBody.copyWith(color: scheme.error),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        Text(
          strings.authInternetRequired,
          style: typography.supportingBody,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
