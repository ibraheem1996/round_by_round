// Keep the picker provided by the pinned Flutter SDK.
// ignore: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/shared/design_system/app_window_class.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/app_control_sizes.dart';
import '../../../shared/design_system/app_radius.dart';
import '../../../shared/design_system/app_responsive_value.dart';
import '../../../shared/design_system/app_spacing.dart';
import '../../../shared/widgets/app_page_frame.dart';
import '../../../shared/widgets/app_wheel_picker.dart';
import '../account_profile.dart';
import 'account_setup_cubit.dart';

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
                            shortWindow: isShortWindow(
                              MediaQuery.sizeOf(context),
                            ),
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
    final canEdit = context.select(
      (AccountSetupCubit cubit) => cubit.state.saveStatus.canEdit,
    );
    final rowHeight =
        MediaQuery.textScalerOf(context).scale(valueStyle.fontSize!) * 1.34;

    return AppWheelPicker(
      controller: _controller,
      itemExtent: rowHeight,
      itemCount: _itemCount,
      visibleItemCount: widget.shortWindow ? 3 : 5,
      canEdit: canEdit,
      onSelectedItemChanged: (index) {
        context.read<AccountSetupCubit>().selectWeight(
          _minimum + index * _step,
        );
      },
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
              color: selected ? colors.onSurface : colors.onSurfaceVariant,
            ),
          ),
        );
      },
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
      (AccountSetupCubit cubit) => cubit.state.saveStatus,
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
            onPressed: status.canEdit
                ? context.read<AccountSetupCubit>().save
                : null,
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
                if (status == WeightSaveStatus.saving)
                  const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      backgroundColor: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
