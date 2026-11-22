// Keep the picker provided by the pinned Flutter SDK.
// ignore: deprecated_member_use
import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/app_control_sizes.dart';
import '../../../shared/design_system/app_radius.dart';
import '../../../shared/design_system/app_responsive_value.dart';
import '../../../shared/design_system/app_spacing.dart';
import '../../../shared/widgets/app_page_frame.dart';
import '../account_profile.dart';
import 'account_setup_cubit.dart';
import 'account_setup_state.dart';

class AccountSetupPage extends StatelessWidget {
  const AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Theme(
        data: darkTheme,
        child: Scaffold(
          body: AppPageFrame(
            maxContentWidth: AppResponsiveValue.resolve(
              context,
              compact: 440,
              medium: 480,
              expanded: 520,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sectionGap,
                        ),
                        child: Text(
                          strings.accountWeightTitle,
                          textAlign: TextAlign.center,
                          style: context.appTypography.pageTitle,
                        ),
                      ),
                      Align(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 340),
                          child: _WeightWheel(
                            shortWindow: constraints.maxHeight < 480,
                          ),
                        ),
                      ),
                      const _SaveWeightAction(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeightWheel extends StatefulWidget {
  const _WeightWheel({required this.shortWindow});

  final bool shortWindow;

  @override
  State<_WeightWheel> createState() => _WeightWheelState();
}

class _WeightWheelState extends State<_WeightWheel> {
  static const _step = AccountProfile.weightStep;
  static const _minimum = AccountProfile.minWeight;
  static final _itemCount =
      ((AccountProfile.maxWeight - _minimum) / _step).round() + 1;
  static const _magnification = 1.15;

  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    final weight = context.read<AccountSetupCubit>().state.weight;
    _controller = FixedExtentScrollController(
      initialItem: ((weight - _minimum) / _step).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final valueStyle = context.appTypography.weightPickerValue;
    final unitStyle = context.appTypography.weightPickerUnit;
    final numbers = NumberFormat('0.0', strings.localeName);
    final weight = context.select(
      (AccountSetupCubit cubit) => cubit.state.weight,
    );
    final saving = context.select(
      (AccountSetupCubit cubit) => switch (cubit.state) {
        AccountSetupEditing(saveStatus: WeightSaveStatus.saving) ||
        AccountSetupSaved() => true,
        _ => false,
      },
    );
    final rowHeight =
        MediaQuery.textScalerOf(context).scale(valueStyle.fontSize!) * 1.25 +
        12;

    return SizedBox(
      height: rowHeight * (widget.shortWindow ? 3 : 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: rowHeight * _magnification,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          AbsorbPointer(
            absorbing: saving,
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0, 0.27, 0.73, 1],
              ).createShader(bounds),
              child: CupertinoPicker.builder(
                scrollController: _controller,
                itemExtent: rowHeight,
                childCount: _itemCount,
                diameterRatio: 1.35,
                useMagnifier: true,
                magnification: _magnification,
                selectionOverlay: null,
                onSelectedItemChanged: (index) => context
                    .read<AccountSetupCubit>()
                    .selectWeight(_minimum + index * _step),
                itemBuilder: (context, index) {
                  final value = _minimum + index * _step;
                  final number = numbers.format(value);
                  final selected = value == weight;
                  return Center(
                    child: Text.rich(
                      TextSpan(
                        text: number,
                        children: selected
                            ? [
                                TextSpan(
                                  text: '  ${strings.accountWeightUnit}',
                                  style: unitStyle,
                                ),
                              ]
                            : null,
                      ),
                      semanticsLabel: strings.accountWeightReading(number),
                      style: valueStyle.copyWith(
                        color: selected
                            ? colors.onSurface
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SaveWeightAction extends StatelessWidget {
  const _SaveWeightAction();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final status = context.select(
      (AccountSetupCubit cubit) => switch (cubit.state) {
        AccountSetupEditing(:final saveStatus) => saveStatus,
        _ => WeightSaveStatus.saving,
      },
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (status == WeightSaveStatus.failed) ...[
            Text(
              strings.accountWeightSaveFailed,
              style: context.appTypography.supportingBody.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.relatedItemGap),
          ],
          FilledButton(
            onPressed: status == WeightSaveStatus.saving
                ? null
                : context.read<AccountSetupCubit>().save,
            style: FilledButton.styleFrom(
              textStyle: context.appTypography.buttonLabel,
              minimumSize: const Size(
                0,
                AppControlSizes.primaryButtonMinHeight,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.buttonHorizontalPadding,
                vertical: AppSpacing.buttonVerticalPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppRadius.primaryButtonRadius,
                ),
              ),
            ),
            child: Wrap(
              spacing: AppSpacing.relatedItemGap,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(strings.accountWeightContinue),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
