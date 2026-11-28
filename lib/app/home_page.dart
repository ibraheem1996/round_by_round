import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import '../shared/design_system/app_spacing.dart';
import '../shared/widgets/app_page_frame.dart';
import 'theme/app_typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.onOpenLibrary, super.key});

  final VoidCallback onOpenLibrary;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: AppPageFrame(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.relatedItemGap,
              children: [
                Text(
                  l.appName,
                  style: context.appTypography.pageTitle,
                  textAlign: TextAlign.center,
                ),
                FilledButton.tonal(
                  onPressed: onOpenLibrary,
                  child: Text(l.exerciseLibrary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
