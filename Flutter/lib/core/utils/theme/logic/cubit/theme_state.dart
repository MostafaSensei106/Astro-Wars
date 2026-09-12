part of 'theme_cubit.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const ThemeState._();

  const factory ThemeState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(0xFF7C4DFF) int accentValue,
  }) = _ThemeState;

  Color get accent => Color(accentValue);
}
