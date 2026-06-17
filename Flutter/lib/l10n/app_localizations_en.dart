// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get error_full_name_invalid_characters =>
      'Invalid characters in full name';

  @override
  String get error_phone_number_cant_be_empty => 'Phone number cannot be empty';

  @override
  String get error_password_cant_be_empty => 'Password cannot be empty';

  @override
  String get error_password_empty => 'Password is required';

  @override
  String get error_password_too_short_min_8_chars =>
      'Password must be at least 8 characters';

  @override
  String get error_password_emojis => 'Password cannot contain emojis';

  @override
  String get error_password_spaces => 'Password cannot contain spaces';

  @override
  String get error_password_invalid => 'Invalid password';

  @override
  String get error_username_empty => 'Username is required';

  @override
  String get error_username_too_short => 'Username is too short';

  @override
  String get error_username_special_chars =>
      'Username cannot contain special characters';

  @override
  String get error_username_spaces => 'Username cannot contain spaces';

  @override
  String get error_username_emojis => 'Username cannot contain emojis';

  @override
  String get error_username_arabic =>
      'Username cannot contain Arabic characters';

  @override
  String get error_username_too_long => 'Username is too long';

  @override
  String get error_username_invalid => 'Invalid username';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get please_wait => 'Please wait...';

  @override
  String get ok => 'OK';

  @override
  String get session_expired => 'Session Expired';

  @override
  String get session_expired_description =>
      'Your session has expired. Please log in again.';

  @override
  String get error => 'Error';

  @override
  String get info => 'Info';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get error_full_name_cant_be_empty => 'Full name cannot be empty';

  @override
  String get error_full_name_too_long_max_255_chars =>
      'Full name cannot exceed 255 characters';
}
