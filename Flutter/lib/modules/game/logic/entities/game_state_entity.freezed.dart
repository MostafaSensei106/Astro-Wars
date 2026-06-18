// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameStateEntity {

 int get score; int get health; bool get isGameOver;
/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateEntityCopyWith<GameStateEntity> get copyWith => _$GameStateEntityCopyWithImpl<GameStateEntity>(this as GameStateEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStateEntity&&(identical(other.score, score) || other.score == score)&&(identical(other.health, health) || other.health == health)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver));
}


@override
int get hashCode => Object.hash(runtimeType,score,health,isGameOver);

@override
String toString() {
  return 'GameStateEntity(score: $score, health: $health, isGameOver: $isGameOver)';
}


}

/// @nodoc
abstract mixin class $GameStateEntityCopyWith<$Res>  {
  factory $GameStateEntityCopyWith(GameStateEntity value, $Res Function(GameStateEntity) _then) = _$GameStateEntityCopyWithImpl;
@useResult
$Res call({
 int score, int health, bool isGameOver
});




}
/// @nodoc
class _$GameStateEntityCopyWithImpl<$Res>
    implements $GameStateEntityCopyWith<$Res> {
  _$GameStateEntityCopyWithImpl(this._self, this._then);

  final GameStateEntity _self;
  final $Res Function(GameStateEntity) _then;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? health = null,Object? isGameOver = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as int,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GameStateEntity].
extension GameStateEntityPatterns on GameStateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameStateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameStateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameStateEntity value)  $default,){
final _that = this;
switch (_that) {
case _GameStateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameStateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GameStateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  int health,  bool isGameOver)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameStateEntity() when $default != null:
return $default(_that.score,_that.health,_that.isGameOver);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  int health,  bool isGameOver)  $default,) {final _that = this;
switch (_that) {
case _GameStateEntity():
return $default(_that.score,_that.health,_that.isGameOver);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  int health,  bool isGameOver)?  $default,) {final _that = this;
switch (_that) {
case _GameStateEntity() when $default != null:
return $default(_that.score,_that.health,_that.isGameOver);case _:
  return null;

}
}

}

/// @nodoc


class _GameStateEntity implements GameStateEntity {
  const _GameStateEntity({this.score = 0, this.health = 3, this.isGameOver = false});
  

@override@JsonKey() final  int score;
@override@JsonKey() final  int health;
@override@JsonKey() final  bool isGameOver;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateEntityCopyWith<_GameStateEntity> get copyWith => __$GameStateEntityCopyWithImpl<_GameStateEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameStateEntity&&(identical(other.score, score) || other.score == score)&&(identical(other.health, health) || other.health == health)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver));
}


@override
int get hashCode => Object.hash(runtimeType,score,health,isGameOver);

@override
String toString() {
  return 'GameStateEntity(score: $score, health: $health, isGameOver: $isGameOver)';
}


}

/// @nodoc
abstract mixin class _$GameStateEntityCopyWith<$Res> implements $GameStateEntityCopyWith<$Res> {
  factory _$GameStateEntityCopyWith(_GameStateEntity value, $Res Function(_GameStateEntity) _then) = __$GameStateEntityCopyWithImpl;
@override @useResult
$Res call({
 int score, int health, bool isGameOver
});




}
/// @nodoc
class __$GameStateEntityCopyWithImpl<$Res>
    implements _$GameStateEntityCopyWith<$Res> {
  __$GameStateEntityCopyWithImpl(this._self, this._then);

  final _GameStateEntity _self;
  final $Res Function(_GameStateEntity) _then;

/// Create a copy of GameStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? health = null,Object? isGameOver = null,}) {
  return _then(_GameStateEntity(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as int,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
