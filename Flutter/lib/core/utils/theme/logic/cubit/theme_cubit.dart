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

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final index = json['themeMode'] as int?;
    if (index != null) {
      return ThemeState(themeMode: ThemeMode.values[index]);
    }
    return const ThemeState();
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'themeMode': state.themeMode.index};
  }
}
