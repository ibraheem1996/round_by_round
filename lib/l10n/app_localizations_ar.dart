// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'جولة بجولة';

  @override
  String get pageNotFound => 'الصفحة غير موجودة';

  @override
  String get backToStart => 'العودة إلى البداية';

  @override
  String get onboardingLogTitle => 'سجّل كل جولة.';

  @override
  String get onboardingLogEmphasis => 'اصنع تقدّمك.';

  @override
  String get onboardingLogDescription =>
      'تتبّع أوزانك وتكراراتك بسهولة وركّز على تمرينك.';

  @override
  String get onboardingPreviousTitle => 'كل تمرين يبدأ';

  @override
  String get onboardingPreviousEmphasis => 'من آخر إنجاز.';

  @override
  String get onboardingPreviousDescription =>
      'راجع أوزانك وتكراراتك السابقة قبل كل جولة، واعرف من أين تتابع.';

  @override
  String get onboardingRoutinesTitle => 'الروتينات الجاهزة،';

  @override
  String get onboardingRoutinesEmphasis => 'أسرع انطلاقة.';

  @override
  String get onboardingRoutinesDescription =>
      'اختر روتينًا جاهزًا وابدأ تمرينك بخطة واضحة.';

  @override
  String get onboardingContinue => 'متابعة';

  @override
  String get onboardingStart => 'ابدأ الآن';

  @override
  String get onboardingSaveFailed => 'تعذّر حفظ اكتمال التعريف. حاول مرة أخرى.';

  @override
  String get authWelcome => 'مرحبًا بك في رفيق تدريبك';

  @override
  String get authDescription => 'سجّل الدخول للاحتفاظ بسجل تمارينك في حسابك.';

  @override
  String get authContinueApple => 'المتابعة باستخدام Apple';

  @override
  String get authContinueGoogle => 'المتابعة باستخدام Google';

  @override
  String get authInternetRequired => 'اتصل بالإنترنت لتسجيل الدخول لأول مرة.';

  @override
  String get authRestoring => 'جارٍ التحقق من جلستك…';

  @override
  String get authStartupFailed => 'تعذّر التحقق من جلستك. حاول مرة أخرى.';

  @override
  String get authRetry => 'إعادة المحاولة';

  @override
  String get authSigningIn => 'جارٍ تسجيل الدخول…';

  @override
  String get authOffline => 'تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String get authProviderUnavailable =>
      'خيار الدخول هذا غير متاح. حاول مرة أخرى لاحقًا.';

  @override
  String get authAccountConflict =>
      'سجّل الدخول باستخدام مزوّد الدخول الذي استخدمته أول مرة لهذا الحساب.';

  @override
  String get authSignInFailed => 'تعذّر تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get accountChecking => 'جارٍ التحقق من حسابك…';

  @override
  String get accountCheckFailed => 'تعذّر التحقق من حسابك. حاول مرة أخرى.';

  @override
  String get accountWeightTitle => 'أدخل وزنك الحالي';

  @override
  String get accountWeightUnit => 'كجم';

  @override
  String accountWeightReading(String weight) {
    return '$weight كيلوغرام';
  }

  @override
  String get accountWeightContinue => 'لنبدأ';

  @override
  String get accountWeightSaveFailed => 'تعذّر حفظ وزنك. حاول مرة أخرى.';
}
