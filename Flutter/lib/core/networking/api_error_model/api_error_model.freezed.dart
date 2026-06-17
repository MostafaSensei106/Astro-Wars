// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_error_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$APIErrorModel {

@JsonKey(name: 'code') int get code;@JsonKey(name: 'message') String get message;@JsonKey(name: 'errors') List<String>? get errors;@JsonKey(name: 'success') bool get success;
/// Create a copy of APIErrorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$APIErrorModelCopyWith<APIErrorModel> get copyWith => _$APIErrorModelCopyWithImpl<APIErrorModel>(this as APIErrorModel, _$identity);

  /// Serializes this APIErrorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is APIErrorModel&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(errors),success);

@override
String toString() {
  return 'APIErrorModel(code: $code, message: $message, errors: $errors, success: $success)';
}


}

/// @nodoc
abstract mixin class $APIErrorModelCopyWith<$Res>  {
  factory $APIErrorModelCopyWith(APIErrorModel value, $Res Function(APIErrorModel) _then) = _$APIErrorModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') int code,@JsonKey(name: 'message') String message,@JsonKey(name: 'errors') List<String>? errors,@JsonKey(name: 'success') bool success
});




}
/// @nodoc
class _$APIErrorModelCopyWithImpl<$Res>
    implements $APIErrorModelCopyWith<$Res> {
  _$APIErrorModelCopyWithImpl(this._self, this._then);

  final APIErrorModel _self;
  final $Res Function(APIErrorModel) _then;

/// Create a copy of APIErrorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? errors = freezed,Object? success = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [APIErrorModel].
extension APIErrorModelPatterns on APIErrorModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _APIErrorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _APIErrorModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _APIErrorModel value)  $default,){
final _that = this;
switch (_that) {
case _APIErrorModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _APIErrorModel value)?  $default,){
final _that = this;
switch (_that) {
case _APIErrorModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'code')  int code, @JsonKey(name: 'message')  String message, @JsonKey(name: 'errors')  List<String>? errors, @JsonKey(name: 'success')  bool success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _APIErrorModel() when $default != null:
return $default(_that.code,_that.message,_that.errors,_that.success);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'code')  int code, @JsonKey(name: 'message')  String message, @JsonKey(name: 'errors')  List<String>? errors, @JsonKey(name: 'success')  bool success)  $default,) {final _that = this;
switch (_that) {
case _APIErrorModel():
return $default(_that.code,_that.message,_that.errors,_that.success);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'code')  int code, @JsonKey(name: 'message')  String message, @JsonKey(name: 'errors')  List<String>? errors, @JsonKey(name: 'success')  bool success)?  $default,) {final _that = this;
switch (_that) {
case _APIErrorModel() when $default != null:
return $default(_that.code,_that.message,_that.errors,_that.success);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _APIErrorModel implements APIErrorModel {
  const _APIErrorModel({@JsonKey(name: 'code') this.code = 0, @JsonKey(name: 'message') this.message = '', @JsonKey(name: 'errors') final  List<String>? errors, @JsonKey(name: 'success') this.success = false}): _errors = errors;
  factory _APIErrorModel.fromJson(Map<String, dynamic> json) => _$APIErrorModelFromJson(json);

@override@JsonKey(name: 'code') final  int code;
@override@JsonKey(name: 'message') final  String message;
 final  List<String>? _errors;
@override@JsonKey(name: 'errors') List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'success') final  bool success;

/// Create a copy of APIErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$APIErrorModelCopyWith<_APIErrorModel> get copyWith => __$APIErrorModelCopyWithImpl<_APIErrorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$APIErrorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _APIErrorModel&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(_errors),success);

@override
String toString() {
  return 'APIErrorModel(code: $code, message: $message, errors: $errors, success: $success)';
}


}

/// @nodoc
abstract mixin class _$APIErrorModelCopyWith<$Res> implements $APIErrorModelCopyWith<$Res> {
  factory _$APIErrorModelCopyWith(_APIErrorModel value, $Res Function(_APIErrorModel) _then) = __$APIErrorModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') int code,@JsonKey(name: 'message') String message,@JsonKey(name: 'errors') List<String>? errors,@JsonKey(name: 'success') bool success
});




}
/// @nodoc
class __$APIErrorModelCopyWithImpl<$Res>
    implements _$APIErrorModelCopyWith<$Res> {
  __$APIErrorModelCopyWithImpl(this._self, this._then);

  final _APIErrorModel _self;
  final $Res Function(_APIErrorModel) _then;

/// Create a copy of APIErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? errors = freezed,Object? success = null,}) {
  return _then(_APIErrorModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
