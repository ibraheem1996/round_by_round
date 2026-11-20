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
}
