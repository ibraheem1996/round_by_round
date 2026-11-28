// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Round by Round';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get backToStart => 'Back to start';

  @override
  String get onboardingLogTitle => 'Log every set.';

  @override
  String get onboardingLogEmphasis => 'Build your progress.';

  @override
  String get onboardingLogDescription =>
      'Track weights and reps easily and stay focused on your workout.';

  @override
  String get onboardingPreviousTitle => 'Every workout starts';

  @override
  String get onboardingPreviousEmphasis => 'with your last lift.';

  @override
  String get onboardingPreviousDescription =>
      'See your previous weight and reps before each set, so you know where to pick up.';

  @override
  String get onboardingRoutinesTitle => 'Ready-made routines,';

  @override
  String get onboardingRoutinesEmphasis => 'a faster start.';

  @override
  String get onboardingRoutinesDescription =>
      'Pick a routine and start your workout with a plan.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingSaveFailed =>
      'Couldn’t save your onboarding progress. Try again.';

  @override
  String get authWelcome => 'Welcome to your training companion';

  @override
  String get authDescription =>
      'Sign in to keep your workout history with your account.';

  @override
  String get authContinueApple => 'Continue with Apple';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authInternetRequired =>
      'Connect to the internet to sign in for the first time.';

  @override
  String get authRestoring => 'Checking your session…';

  @override
  String get authStartupFailed => 'Couldn’t check your session. Try again.';

  @override
  String get authRetry => 'Try again';

  @override
  String get authSigningIn => 'Signing in…';

  @override
  String get authOffline => 'Check your internet connection and try again.';

  @override
  String get authProviderUnavailable =>
      'This sign-in option is unavailable. Try again later.';

  @override
  String get authAccountConflict =>
      'Sign in with the provider you originally used for this account.';

  @override
  String get authSignInFailed => 'Couldn’t sign in. Try again.';

  @override
  String get accountChecking => 'Checking your account…';

  @override
  String get accountCheckFailed => 'Couldn’t check your account. Try again.';

  @override
  String get accountWeightTitle => 'Enter your current weight';

  @override
  String get accountWeightUnit => 'kg';

  @override
  String accountWeightReading(String weight) {
    return '$weight kilograms';
  }

  @override
  String get accountWeightContinue => 'Let’s start';

  @override
  String get accountWeightSaveFailed => 'Couldn’t save your weight. Try again.';

  @override
  String get exerciseLibrary => 'Library';

  @override
  String get allExercises => 'All exercises';

  @override
  String get searchExercises => 'Search exercises';

  @override
  String get clearExerciseSearch => 'Clear search';

  @override
  String get exerciseMuscles => 'Muscles';

  @override
  String get exerciseEquipment => 'Equipment';

  @override
  String get exerciseRetry => 'Retry';

  @override
  String get exerciseLoadFailed => 'Could not load exercises';

  @override
  String get noMatchingExercises => 'No matching exercises';

  @override
  String get exerciseDetailsComing => 'Exercise details are coming soon';

  @override
  String exerciseMusclesCount(int count) {
    return 'Muscles ($count)';
  }

  @override
  String exerciseEquipmentCount(int count) {
    return 'Equipment ($count)';
  }

  @override
  String exerciseResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleOther => 'Other';

  @override
  String get muscleCardio => 'Cardio';

  @override
  String get equipmentMachines => 'Machines';

  @override
  String get equipmentNoEquipment => 'No equipment';

  @override
  String get equipmentDumbbell => 'Dumbbell';

  @override
  String get equipmentBarbell => 'Barbell';

  @override
  String get equipmentBands => 'Resistance bands and suspension straps';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentOther => 'Other';

  @override
  String get exerciseLegs => 'Legs';
}
