final class ValidationRegex {
  ValidationRegex._();

  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp simplePasswordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final RegExp strongPasswordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&#]{8,}$',
  );

  static final RegExp phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

  static final RegExp arabicRegExp = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  static final RegExp nameRegExp = RegExp(r'^[\p{L}\s]+$', unicode: true);

  static final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9._]{3,20}$');

  static final RegExp urlRegExp = RegExp(
    r'^(https?:\/\/)?([\w\d\-]+\.)+\w{2,}(\/.+)?$',
  );

  static final RegExp creditCardRegExp = RegExp(r'^(\d{4}[- ]?){3}\d{4}$');

  static final RegExp hexColorRegExp = RegExp(
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$',
  );

  static final RegExp digitsOnlyRegExp = RegExp(r'^\d+$');

  static final RegExp ipv4RegExp = RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
  );

  static final RegExp max20CharsRegExp = RegExp(r'^.{0,20}$');

  static final RegExp min8CharsRegExp = RegExp(r'^.{8,}$');

  static final RegExp min3CharsRegExp = RegExp(r'^.{3,}$');

  static final RegExp noWhitespaceRegExp = RegExp(r'^\S+$');

  static final RegExp emojiRegExp = RegExp(
    r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
    unicode: true,
  );

  static final RegExp invalidSpecialCharsRegExp = RegExp(
    r'[!@#$%^&*(),.?":{}|<>]',
  );
}
