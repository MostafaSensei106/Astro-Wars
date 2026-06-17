import 'package:flutter_bloc/flutter_bloc.dart';

mixin AutoRetryMixin<State> on Cubit<State> {
  void retryRequest();
  bool isNetworkFailureState(State state);
}
