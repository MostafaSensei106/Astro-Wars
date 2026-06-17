import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_model.freezed.dart';
part 'api_error_model.g.dart';

@freezed
abstract class APIErrorModel with _$APIErrorModel {
  const factory APIErrorModel({
    @JsonKey(name: 'code') @Default(0) int code,
    @JsonKey(name: 'message') @Default('') String message,
    @JsonKey(name: 'errors') List<String>? errors,
    @JsonKey(name: 'success') @Default(false) bool success,
  }) = _APIErrorModel;

  factory APIErrorModel.fromJson(Map<String, dynamic> json) =>
      _$APIErrorModelFromJson(json);
}
