// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get error_full_name_invalid_characters => 'أحرف غير صالحة في الاسم';

  @override
  String get error_phone_number_cant_be_empty => 'رقم الهاتف مطلوب';

  @override
  String get error_password_cant_be_empty => 'كلمة المرور مطلوبة';

  @override
  String get error_password_empty => 'كلمة المرور مطلوبة';

  @override
  String get error_password_too_short_min_8_chars =>
      'يجب أن تتكون من 8 أحرف على الأقل';

  @override
  String get error_password_emojis => 'لا يمكن أن تحتوي على رموز تعبيرية';

  @override
  String get error_password_spaces => 'لا يمكن أن تحتوي على مسافات';

  @override
  String get error_password_invalid => 'كلمة المرور غير صالحة';

  @override
  String get error_username_empty => 'اسم المستخدم مطلوب';

  @override
  String get error_username_too_short => 'اسم المستخدم قصير جداً';

  @override
  String get error_username_special_chars => 'لا يمكن أن يحتوي على رموز خاصة';

  @override
  String get error_username_spaces => 'لا يمكن أن يحتوي على مسافات';

  @override
  String get error_username_emojis => 'لا يمكن أن يحتوي على رموز تعبيرية';

  @override
  String get error_username_arabic => 'لا يمكن أن يحتوي على أحرف عربية';

  @override
  String get error_username_too_long => 'اسم المستخدم طويل جداً';

  @override
  String get error_username_invalid => 'اسم مستخدم غير صالح';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get please_wait => 'يرجى الانتظار...';

  @override
  String get ok => 'حسناً';

  @override
  String get session_expired => 'انتهت الجلسة';

  @override
  String get session_expired_description =>
      'لقد انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get error => 'خطأ';

  @override
  String get info => 'معلومة';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get error_full_name_cant_be_empty => 'الاسم بالكامل مطلوب';

  @override
  String get error_full_name_too_long_max_255_chars => 'الاسم طويل جداً';
}
