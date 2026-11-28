import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_frame.dart';

class ExerciseDetailPlaceholderPage extends StatelessWidget {
  const ExerciseDetailPlaceholderPage({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.exerciseLibrary)),
      body: AppPageFrame(
        child: Center(
          child: Text(
            l.exerciseDetailsComing,
            style: context.appTypography.supportingBody,
          ),
        ),
      ),
    );
  }
}
