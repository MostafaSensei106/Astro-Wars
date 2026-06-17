part of 'localization_cubit.dart';

@freezed
sealed class LocalizationState with _$LocalizationState {
  const factory LocalizationState({required String langCode}) =
      _LocalizationState;
}

extension LocalizationStateX on LocalizationState {
  ui.Locale get locale => ui.Locale(langCode);
}
