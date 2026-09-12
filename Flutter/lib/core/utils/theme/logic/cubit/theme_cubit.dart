import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

@lazySingleton
class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  Future<void> changeTheme(ThemeMode newMode) async {
    if (state.themeMode == newMode) return;

    emit(state.copyWith(themeMode: newMode));
  }

  Future<void> changeAccent(int accentValue) async {
    if (state.accentValue == accentValue) return;
    emit(state.copyWith(accentValue: accentValue));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final index = json['themeMode'] as int?;
    final accent = json['accentValue'] as int?;
    if (index == null && accent == null) return const ThemeState();
    return ThemeState(
      themeMode: index != null ? ThemeMode.values[index] : ThemeMode.system,
      accentValue: accent ?? 0xFF7C4DFF,
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'themeMode': state.themeMode.index, 'accentValue': state.accentValue};
  }
}
