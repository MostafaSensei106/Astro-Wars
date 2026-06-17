import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

final class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('🟢 onCreate -- ${bloc.runtimeType}', name: 'BlocObserver');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log(
      '🔵 onEvent -- ${bloc.runtimeType}, Event: $event',
      name: 'BlocObserver',
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(
      '🟡 onChange -- ${bloc.runtimeType}, Change: $change',
      name: 'BlocObserver',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(
      '🟣 onTransition -- ${bloc.runtimeType}, Transition: $transition',
      name: 'BlocObserver',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(
      '🔴 onError -- ${bloc.runtimeType}, Error: $error',
      name: 'BlocObserver',
      error: error,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('⚫ onClose -- ${bloc.runtimeType}', name: 'BlocObserver');
  }
}
