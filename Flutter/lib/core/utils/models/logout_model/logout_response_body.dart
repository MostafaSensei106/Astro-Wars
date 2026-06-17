import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_response_body.g.dart';

@JsonSerializable()
final class LogoutResponseBody {
  const LogoutResponseBody({
    required this.success,
    required this.message,
    this.data,
  });

  factory LogoutResponseBody.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseBodyFromJson(json);

  final bool success;
  final String message;
  final String? data;

  Map<String, dynamic> toJson() => _$LogoutResponseBodyToJson(this);
}
