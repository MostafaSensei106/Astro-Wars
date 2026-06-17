// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent()';
}


}

/// @nodoc
class $GameEventCopyWith<$Res>  {
$GameEventCopyWith(GameEvent _, $Res Function(GameEvent) __);
}


/// Adds pattern-matching-related methods to [GameEvent].
extension GameEventPatterns on GameEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ScoreIncreased value)?  scoreIncreased,TResult Function( _PlayerDamaged value)?  playerDamaged,TResult Function( _GameRestarted value)?  gameRestarted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreIncreased() when scoreIncreased != null:
return scoreIncreased(_that);case _PlayerDamaged() when playerDamaged != null:
return playerDamaged(_that);case _GameRestarted() when gameRestarted != null:
return gameRestarted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ScoreIncreased value)  scoreIncreased,required TResult Function( _PlayerDamaged value)  playerDamaged,required TResult Function( _GameRestarted value)  gameRestarted,}){
final _that = this;
switch (_that) {
case _ScoreIncreased():
return scoreIncreased(_that);case _PlayerDamaged():
return playerDamaged(_that);case _GameRestarted():
return gameRestarted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ScoreIncreased value)?  scoreIncreased,TResult? Function( _PlayerDamaged value)?  playerDamaged,TResult? Function( _GameRestarted value)?  gameRestarted,}){
final _that = this;
switch (_that) {
case _ScoreIncreased() when scoreIncreased != null:
return scoreIncreased(_that);case _PlayerDamaged() when playerDamaged != null:
return playerDamaged(_that);case _GameRestarted() when gameRestarted != null:
return gameRestarted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int amount)?  scoreIncreased,TResult Function( int damage)?  playerDamaged,TResult Function()?  gameRestarted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreIncreased() when scoreIncreased != null:
return scoreIncreased(_that.amount);case _PlayerDamaged() when playerDamaged != null:
return playerDamaged(_that.damage);case _GameRestarted() when gameRestarted != null:
return gameRestarted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int amount)  scoreIncreased,required TResult Function( int damage)  playerDamaged,required TResult Function()  gameRestarted,}) {final _that = this;
switch (_that) {
case _ScoreIncreased():
return scoreIncreased(_that.amount);case _PlayerDamaged():
return playerDamaged(_that.damage);case _GameRestarted():
return gameRestarted();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int amount)?  scoreIncreased,TResult? Function( int damage)?  playerDamaged,TResult? Function()?  gameRestarted,}) {final _that = this;
switch (_that) {
case _ScoreIncreased() when scoreIncreased != null:
return scoreIncreased(_that.amount);case _PlayerDamaged() when playerDamaged != null:
return playerDamaged(_that.damage);case _GameRestarted() when gameRestarted != null:
return gameRestarted();case _:
  return null;

}
}

}

/// @nodoc


class _ScoreIncreased implements GameEvent {
  const _ScoreIncreased(this.amount);
  

 final  int amount;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreIncreasedCopyWith<_ScoreIncreased> get copyWith => __$ScoreIncreasedCopyWithImpl<_ScoreIncreased>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreIncreased&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'GameEvent.scoreIncreased(amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$ScoreIncreasedCopyWith<$Res> implements $GameEventCopyWith<$Res> {
  factory _$ScoreIncreasedCopyWith(_ScoreIncreased value, $Res Function(_ScoreIncreased) _then) = __$ScoreIncreasedCopyWithImpl;
@useResult
$Res call({
 int amount
});




}
/// @nodoc
class __$ScoreIncreasedCopyWithImpl<$Res>
    implements _$ScoreIncreasedCopyWith<$Res> {
  __$ScoreIncreasedCopyWithImpl(this._self, this._then);

  final _ScoreIncreased _self;
  final $Res Function(_ScoreIncreased) _then;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(_ScoreIncreased(
null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _PlayerDamaged implements GameEvent {
  const _PlayerDamaged(this.damage);
  

 final  int damage;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerDamagedCopyWith<_PlayerDamaged> get copyWith => __$PlayerDamagedCopyWithImpl<_PlayerDamaged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerDamaged&&(identical(other.damage, damage) || other.damage == damage));
}


@override
int get hashCode => Object.hash(runtimeType,damage);

@override
String toString() {
  return 'GameEvent.playerDamaged(damage: $damage)';
}


}

/// @nodoc
abstract mixin class _$PlayerDamagedCopyWith<$Res> implements $GameEventCopyWith<$Res> {
  factory _$PlayerDamagedCopyWith(_PlayerDamaged value, $Res Function(_PlayerDamaged) _then) = __$PlayerDamagedCopyWithImpl;
@useResult
$Res call({
 int damage
});




}
/// @nodoc
class __$PlayerDamagedCopyWithImpl<$Res>
    implements _$PlayerDamagedCopyWith<$Res> {
  __$PlayerDamagedCopyWithImpl(this._self, this._then);

  final _PlayerDamaged _self;
  final $Res Function(_PlayerDamaged) _then;

/// Create a copy of GameEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? damage = null,}) {
  return _then(_PlayerDamaged(
null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _GameRestarted implements GameEvent {
  const _GameRestarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameRestarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent.gameRestarted()';
}


}




/// @nodoc
mixin _$GameState {

 GameStateEntity get entity;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.entity, entity) || other.entity == entity));
}


@override
int get hashCode => Object.hash(runtimeType,entity);

@override
String toString() {
  return 'GameState(entity: $entity)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 GameStateEntity entity
});


$GameStateEntityCopyWith<$Res> get entity;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entity = null,}) {
  return _then(_self.copyWith(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as GameStateEntity,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateEntityCopyWith<$Res> get entity {
  
  return $GameStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Playing value)?  playing,TResult Function( _GameOver value)?  gameOver,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Playing() when playing != null:
return playing(_that);case _GameOver() when gameOver != null:
return gameOver(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Playing value)  playing,required TResult Function( _GameOver value)  gameOver,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Playing():
return playing(_that);case _GameOver():
return gameOver(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Playing value)?  playing,TResult? Function( _GameOver value)?  gameOver,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Playing() when playing != null:
return playing(_that);case _GameOver() when gameOver != null:
return gameOver(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( GameStateEntity entity)?  initial,TResult Function( GameStateEntity entity)?  playing,TResult Function( GameStateEntity entity)?  gameOver,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.entity);case _Playing() when playing != null:
return playing(_that.entity);case _GameOver() when gameOver != null:
return gameOver(_that.entity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( GameStateEntity entity)  initial,required TResult Function( GameStateEntity entity)  playing,required TResult Function( GameStateEntity entity)  gameOver,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.entity);case _Playing():
return playing(_that.entity);case _GameOver():
return gameOver(_that.entity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( GameStateEntity entity)?  initial,TResult? Function( GameStateEntity entity)?  playing,TResult? Function( GameStateEntity entity)?  gameOver,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.entity);case _Playing() when playing != null:
return playing(_that.entity);case _GameOver() when gameOver != null:
return gameOver(_that.entity);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements GameState {
  const _Initial(this.entity);
  

@override final  GameStateEntity entity;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.entity, entity) || other.entity == entity));
}


@override
int get hashCode => Object.hash(runtimeType,entity);

@override
String toString() {
  return 'GameState.initial(entity: $entity)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 GameStateEntity entity
});


@override $GameStateEntityCopyWith<$Res> get entity;

}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entity = null,}) {
  return _then(_Initial(
null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as GameStateEntity,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateEntityCopyWith<$Res> get entity {
  
  return $GameStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}
}

/// @nodoc


class _Playing implements GameState {
  const _Playing(this.entity);
  

@override final  GameStateEntity entity;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayingCopyWith<_Playing> get copyWith => __$PlayingCopyWithImpl<_Playing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Playing&&(identical(other.entity, entity) || other.entity == entity));
}


@override
int get hashCode => Object.hash(runtimeType,entity);

@override
String toString() {
  return 'GameState.playing(entity: $entity)';
}


}

/// @nodoc
abstract mixin class _$PlayingCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$PlayingCopyWith(_Playing value, $Res Function(_Playing) _then) = __$PlayingCopyWithImpl;
@override @useResult
$Res call({
 GameStateEntity entity
});


@override $GameStateEntityCopyWith<$Res> get entity;

}
/// @nodoc
class __$PlayingCopyWithImpl<$Res>
    implements _$PlayingCopyWith<$Res> {
  __$PlayingCopyWithImpl(this._self, this._then);

  final _Playing _self;
  final $Res Function(_Playing) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entity = null,}) {
  return _then(_Playing(
null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as GameStateEntity,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateEntityCopyWith<$Res> get entity {
  
  return $GameStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}
}

/// @nodoc


class _GameOver implements GameState {
  const _GameOver(this.entity);
  

@override final  GameStateEntity entity;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameOverCopyWith<_GameOver> get copyWith => __$GameOverCopyWithImpl<_GameOver>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameOver&&(identical(other.entity, entity) || other.entity == entity));
}


@override
int get hashCode => Object.hash(runtimeType,entity);

@override
String toString() {
  return 'GameState.gameOver(entity: $entity)';
}


}

/// @nodoc
abstract mixin class _$GameOverCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameOverCopyWith(_GameOver value, $Res Function(_GameOver) _then) = __$GameOverCopyWithImpl;
@override @useResult
$Res call({
 GameStateEntity entity
});


@override $GameStateEntityCopyWith<$Res> get entity;

}
/// @nodoc
class __$GameOverCopyWithImpl<$Res>
    implements _$GameOverCopyWith<$Res> {
  __$GameOverCopyWithImpl(this._self, this._then);

  final _GameOver _self;
  final $Res Function(_GameOver) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entity = null,}) {
  return _then(_GameOver(
null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as GameStateEntity,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateEntityCopyWith<$Res> get entity {
  
  return $GameStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}
}

// dart format on
