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

  @override
  String get exerciseLibrary => 'المكتبة';

  @override
  String get allExercises => 'كل التمارين';

  @override
  String get searchExercises => 'ابحث عن تمرين';

  @override
  String get clearExerciseSearch => 'مسح البحث';

  @override
  String get exerciseMuscles => 'العضلات';

  @override
  String get exerciseEquipment => 'المعدات';

  @override
  String get exerciseRetry => 'إعادة المحاولة';

  @override
  String get exerciseLoadFailed => 'تعذّر تحميل التمارين';

  @override
  String get noMatchingExercises => 'لا توجد تمارين مطابقة';

  @override
  String get exerciseDetailsComing => 'تفاصيل التمرين قريبًا';

  @override
  String exerciseMusclesCount(int count) {
    return 'العضلات ($count)';
  }

  @override
  String exerciseEquipmentCount(int count) {
    return 'المعدات ($count)';
  }

  @override
  String exerciseResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمرينًا',
      few: '$count تمارين',
      two: 'تمرينان',
      one: 'تمرين واحد',
      zero: 'لا نتائج',
    );
    return '$_temp0';
  }

  @override
  String get muscleChest => 'الصدر';

  @override
  String get muscleBack => 'الظهر';

  @override
  String get muscleShoulders => 'الأكتاف';

  @override
  String get muscleBiceps => 'البايسبس';

  @override
  String get muscleTriceps => 'الترايسبس';

  @override
  String get muscleOther => 'أخرى';

  @override
  String get muscleCardio => 'كارديو';

  @override
  String get equipmentMachines => 'أجهزة';

  @override
  String get equipmentNoEquipment => 'بدون أدوات';

  @override
  String get equipmentDumbbell => 'دمبل';

  @override
  String get equipmentBarbell => 'بار';

  @override
  String get equipmentBands => 'أشرطة مقاومة وحبال تعليق';

  @override
  String get equipmentKettlebell => 'كيتل بيل';

  @override
  String get equipmentOther => 'أخرى';

  @override
  String get exerciseLegs => 'الأرجل';
}
