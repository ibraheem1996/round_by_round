import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:round_by_round/features/exercises/data/asset_exercise_catalog_repository.dart';
import 'package:round_by_round/features/exercises/domain/exercise_catalog_repository.dart';
import 'package:round_by_round/features/exercises/domain/exercise_definition.dart';
import 'package:round_by_round/features/exercises/presentation/catalog/exercise_catalog_cubit.dart';
import 'package:round_by_round/features/exercises/presentation/catalog/exercise_catalog_page.dart';
import 'package:round_by_round/features/exercises/presentation/details/exercise_detail_placeholder_page.dart';

import '../../support/mock_device_orientation.dart';
import '../../support/test_auth_gateway.dart';
import '../../support/test_preferences.dart';

void main() {
  final repository = AssetExerciseCatalogRepository();
  setUpAll(repository.loadAll);
  setUp(() => mockDeviceOrientation('PortraitUp'));

  testWidgets(
    'opens the packaged catalog and restores filtered results after details',
    (tester) async {
      final auth = TestAuthGateway(userId: 'owner');
      addTearDown(auth.close);
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await tester.pumpWidget(
        testApp(
          TestPreferences(completed: true),
          auth,
          createExerciseCatalog: () => ExerciseCatalogCubit(repository),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();
      expect(find.text('210 exercises'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Muscles'));
      await tester.pumpAndSettle();
      final cardio = find.widgetWithText(CheckboxListTile, 'Cardio');
      await tester.scrollUntilVisible(
        cardio,
        150,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.ensureVisible(cardio);
      await tester.pumpAndSettle();
      await tester.tap(cardio);
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      expect(find.text('14 exercises'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'treadmill');
      tester.testTextInput.hide();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(find.text('1 exercise'), findsOneWidget);
      final treadmill = find.byWidgetPredicate(
        (widget) =>
            widget is Text && (widget.data?.contains('Treadmill') ?? false),
      );
      await tester.ensureVisible(treadmill.first);
      await tester.tap(treadmill.first);
      await tester.pumpAndSettle();
      final details = tester.widget<ExerciseDetailPlaceholderPage>(
        find.byType(ExerciseDetailPlaceholderPage),
      );
      expect(details.exerciseId, 'builtin:treadmill_run');
      GoRouter.of(tester.element(find.byType(ExerciseDetailPlaceholderPage)))
          .pop();
      await tester.pumpAndSettle();
      expect(find.text('1 exercise'), findsOneWidget);
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(find.text('14 exercises'), findsOneWidget);
    },
  );

  testWidgets('renders catalog in Arabic with large text on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 610);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.localesTestValue = const [Locale('ar')];
    tester.platformDispatcher.textScaleFactorTestValue = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    final auth = TestAuthGateway(userId: 'owner');
    addTearDown(auth.close);
    final cubit = ExerciseCatalogCubit(repository);
    await tester.pumpWidget(
      testApp(
        TestPreferences(completed: true),
        auth,
        createExerciseCatalog: () => cubit,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('المكتبة'));
    await tester.pumpAndSettle();
    expect(find.byType(ExerciseCatalogPage), findsOneWidget);
    double scaleFor(Finder finder) =>
        MediaQuery.textScalerOf(tester.element(finder)).scale(10) / 10;

    expect(scaleFor(find.byType(TextField)), 1.5);
    expect(scaleFor(find.byType(FilledButton).first), 1.5);
    expect(scaleFor(find.byType(FilledButton).last), 1.5);
    expect(scaleFor(find.text('كل التمارين')), 3);
    cubit.toggleEquipment(Equipment.resistanceBand);
    await tester.pumpAndSettle();
    final chipLabel = find.text('أشرطة مقاومة وحبال تعليق').last;
    expect(scaleFor(chipLabel), 1.5);
    final localizations = MaterialLocalizations.of(tester.element(chipLabel));
    final delete = find.byTooltip(localizations.deleteButtonTooltip);
    for (var i = 0; i < 5 && delete.hitTestable().evaluate().isEmpty; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -180));
      await tester.pumpAndSettle();
    }
    await tester.tap(delete.hitTestable());
    await tester.pumpAndSettle();
    expect(cubit.state.equipment, isEmpty);
    expect(tester.takeException(), isNull);
    for (var i = 0; i < 5 && find.byType(Card).evaluate().isEmpty; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();
    }
    await tester.pumpAndSettle();
    expect(scaleFor(find.byType(Card).first), 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'retries a failed catalog and keeps results when images are missing',
    (tester) async {
      final auth = TestAuthGateway(userId: 'owner');
      addTearDown(auth.close);
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final failing = _RetryCatalog([
        for (final exercise in await repository.loadAll())
          exercise.copyWith(imageRef: 'assets/exercise_library/missing.webp'),
      ]);
      await tester.pumpWidget(
        testApp(
          TestPreferences(completed: true),
          auth,
          createExerciseCatalog: () => ExerciseCatalogCubit(failing),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();
      expect(find.text('Could not load exercises'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('210 exercises'), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsWidgets);
      await tester.enterText(find.byType(TextField), 'zzzzzz');
      await tester.pumpAndSettle();
      expect(find.text('No matching exercises'), findsOneWidget);
    },
  );
}

class _RetryCatalog implements ExerciseCatalogRepository {
  _RetryCatalog(this.definitions);

  final List<ExerciseDefinition> definitions;
  var _attempts = 0;

  @override
  Future<List<ExerciseDefinition>> loadAll() async {
    if (_attempts++ == 0) throw const FormatException('Bad catalog');
    return definitions;
  }
}
