import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/design_system/app_spacing.dart';
import '../../shared/widgets/app_page_frame.dart';
import '../theme/app_typography.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({
    required this.failed,
    required this.checkingAccount,
    required this.onRetry,
    super.key,
  });

  final bool failed;
  final bool checkingAccount;
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
                switch ((checkingAccount, failed)) {
                  (true, true) => strings.accountCheckFailed,
                  (true, false) => strings.accountChecking,
                  (false, true) => strings.authStartupFailed,
                  (false, false) => strings.authRestoring,
                },
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
