// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_list_screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodoListScreenState {

/// 表示するTodoアイテムのリスト
 Todos get todos;
/// Create a copy of TodoListScreenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoListScreenStateCopyWith<TodoListScreenState> get copyWith => _$TodoListScreenStateCopyWithImpl<TodoListScreenState>(this as TodoListScreenState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoListScreenState&&(identical(other.todos, todos) || other.todos == todos));
}


@override
int get hashCode => Object.hash(runtimeType,todos);

@override
String toString() {
  return 'TodoListScreenState(todos: $todos)';
}


}

/// @nodoc
abstract mixin class $TodoListScreenStateCopyWith<$Res>  {
  factory $TodoListScreenStateCopyWith(TodoListScreenState value, $Res Function(TodoListScreenState) _then) = _$TodoListScreenStateCopyWithImpl;
@useResult
$Res call({
 Todos todos
});


$TodosCopyWith<$Res> get todos;

}
/// @nodoc
class _$TodoListScreenStateCopyWithImpl<$Res>
    implements $TodoListScreenStateCopyWith<$Res> {
  _$TodoListScreenStateCopyWithImpl(this._self, this._then);

  final TodoListScreenState _self;
  final $Res Function(TodoListScreenState) _then;

/// Create a copy of TodoListScreenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todos = null,}) {
  return _then(_self.copyWith(
todos: null == todos ? _self.todos : todos // ignore: cast_nullable_to_non_nullable
as Todos,
  ));
}
/// Create a copy of TodoListScreenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodosCopyWith<$Res> get todos {
  
  return $TodosCopyWith<$Res>(_self.todos, (value) {
    return _then(_self.copyWith(todos: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodoListScreenState].
extension TodoListScreenStatePatterns on TodoListScreenState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoListScreenState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoListScreenState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoListScreenState value)  $default,){
final _that = this;
switch (_that) {
case _TodoListScreenState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoListScreenState value)?  $default,){
final _that = this;
switch (_that) {
case _TodoListScreenState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Todos todos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoListScreenState() when $default != null:
return $default(_that.todos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Todos todos)  $default,) {final _that = this;
switch (_that) {
case _TodoListScreenState():
return $default(_that.todos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Todos todos)?  $default,) {final _that = this;
switch (_that) {
case _TodoListScreenState() when $default != null:
return $default(_that.todos);case _:
  return null;

}
}

}

/// @nodoc


class _TodoListScreenState implements TodoListScreenState {
  const _TodoListScreenState({required this.todos});
  

/// 表示するTodoアイテムのリスト
@override final  Todos todos;

/// Create a copy of TodoListScreenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoListScreenStateCopyWith<_TodoListScreenState> get copyWith => __$TodoListScreenStateCopyWithImpl<_TodoListScreenState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoListScreenState&&(identical(other.todos, todos) || other.todos == todos));
}


@override
int get hashCode => Object.hash(runtimeType,todos);

@override
String toString() {
  return 'TodoListScreenState(todos: $todos)';
}


}

/// @nodoc
abstract mixin class _$TodoListScreenStateCopyWith<$Res> implements $TodoListScreenStateCopyWith<$Res> {
  factory _$TodoListScreenStateCopyWith(_TodoListScreenState value, $Res Function(_TodoListScreenState) _then) = __$TodoListScreenStateCopyWithImpl;
@override @useResult
$Res call({
 Todos todos
});


@override $TodosCopyWith<$Res> get todos;

}
/// @nodoc
class __$TodoListScreenStateCopyWithImpl<$Res>
    implements _$TodoListScreenStateCopyWith<$Res> {
  __$TodoListScreenStateCopyWithImpl(this._self, this._then);

  final _TodoListScreenState _self;
  final $Res Function(_TodoListScreenState) _then;

/// Create a copy of TodoListScreenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todos = null,}) {
  return _then(_TodoListScreenState(
todos: null == todos ? _self.todos : todos // ignore: cast_nullable_to_non_nullable
as Todos,
  ));
}

/// Create a copy of TodoListScreenState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodosCopyWith<$Res> get todos {
  
  return $TodosCopyWith<$Res>(_self.todos, (value) {
    return _then(_self.copyWith(todos: value));
  });
}
}

// dart format on
