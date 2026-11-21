// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Round by Round'**
  String get appName;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @backToStart.
  ///
  /// In en, this message translates to:
  /// **'Back to start'**
  String get backToStart;

  /// No description provided for @onboardingLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log every set.'**
  String get onboardingLogTitle;

  /// No description provided for @onboardingLogEmphasis.
  ///
  /// In en, this message translates to:
  /// **'Build your progress.'**
  String get onboardingLogEmphasis;

  /// No description provided for @onboardingLogDescription.
  ///
  /// In en, this message translates to:
  /// **'Track weights and reps easily and stay focused on your workout.'**
  String get onboardingLogDescription;

  /// No description provided for @onboardingPreviousTitle.
  ///
  /// In en, this message translates to:
  /// **'Every workout starts'**
  String get onboardingPreviousTitle;

  /// No description provided for @onboardingPreviousEmphasis.
  ///
  /// In en, this message translates to:
  /// **'with your last lift.'**
  String get onboardingPreviousEmphasis;

  /// No description provided for @onboardingPreviousDescription.
  ///
  /// In en, this message translates to:
  /// **'See your previous weight and reps before each set, so you know where to pick up.'**
  String get onboardingPreviousDescription;

  /// No description provided for @onboardingRoutinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready-made routines,'**
  String get onboardingRoutinesTitle;

  /// No description provided for @onboardingRoutinesEmphasis.
  ///
  /// In en, this message translates to:
  /// **'a faster start.'**
  String get onboardingRoutinesEmphasis;

  /// No description provided for @onboardingRoutinesDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick a routine and start your workout with a plan.'**
  String get onboardingRoutinesDescription;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save your onboarding progress. Try again.'**
  String get onboardingSaveFailed;

  /// No description provided for @authWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your training companion'**
  String get authWelcome;

  /// No description provided for @authDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your workout history with your account.'**
  String get authDescription;

  /// No description provided for @authContinueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueApple;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authInternetRequired.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to sign in for the first time.'**
  String get authInternetRequired;

  /// No description provided for @authRestoring.
  ///
  /// In en, this message translates to:
  /// **'Checking your session…'**
  String get authRestoring;

  /// No description provided for @authStartupFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t check your session. Try again.'**
  String get authStartupFailed;

  /// No description provided for @authRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get authRetry;

  /// No description provided for @authSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get authSigningIn;

  /// No description provided for @authOffline.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get authOffline;

  /// No description provided for @authProviderUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This sign-in option is unavailable. Try again later.'**
  String get authProviderUnavailable;

  /// No description provided for @authAccountConflict.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the provider you originally used for this account.'**
  String get authAccountConflict;

  /// No description provided for @authSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t sign in. Try again.'**
  String get authSignInFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
