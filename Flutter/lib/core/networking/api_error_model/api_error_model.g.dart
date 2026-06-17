// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_APIErrorModel _$APIErrorModelFromJson(Map<String, dynamic> json) =>
    _APIErrorModel(
      code: (json['code'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      success: json['success'] as bool? ?? false,
    );

Map<String, dynamic> _$APIErrorModelToJson(_APIErrorModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'errors': instance.errors,
      'success': instance.success,
    };
