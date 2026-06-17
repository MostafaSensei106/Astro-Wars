// ignore_for_file: sort_constructors_first

enum FontFamily {
  arabic('ar', 'Rubik'),
  english('en', 'Rubik'),
  japanese('ja', 'KaiseiTokumin');

  final String code;
  final String font;

  const FontFamily(this.code, this.font);

  static String getFontFamily(String langCode) {
    return FontFamily.values
        .firstWhere(
          (lang) => lang.code == langCode,
          orElse: () => FontFamily.english,
        )
        .font;
  }
}
