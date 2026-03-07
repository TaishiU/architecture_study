// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todos_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodosModel {

 List<TodoModel>? get todos;
/// Create a copy of TodosModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodosModelCopyWith<TodosModel> get copyWith => _$TodosModelCopyWithImpl<TodosModel>(this as TodosModel, _$identity);

  /// Serializes this TodosModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodosModel&&const DeepCollectionEquality().equals(other.todos, todos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(todos));

@override
String toString() {
  return 'TodosModel(todos: $todos)';
}


}

/// @nodoc
abstract mixin class $TodosModelCopyWith<$Res>  {
  factory $TodosModelCopyWith(TodosModel value, $Res Function(TodosModel) _then) = _$TodosModelCopyWithImpl;
@useResult
$Res call({
 List<TodoModel>? todos
});




}
/// @nodoc
class _$TodosModelCopyWithImpl<$Res>
    implements $TodosModelCopyWith<$Res> {
  _$TodosModelCopyWithImpl(this._self, this._then);

  final TodosModel _self;
  final $Res Function(TodosModel) _then;

/// Create a copy of TodosModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todos = freezed,}) {
  return _then(_self.copyWith(
todos: freezed == todos ? _self.todos : todos // ignore: cast_nullable_to_non_nullable
as List<TodoModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TodosModel].
extension TodosModelPatterns on TodosModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodosModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodosModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodosModel value)  $default,){
final _that = this;
switch (_that) {
case _TodosModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodosModel value)?  $default,){
final _that = this;
switch (_that) {
case _TodosModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TodoModel>? todos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodosModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TodoModel>? todos)  $default,) {final _that = this;
switch (_that) {
case _TodosModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TodoModel>? todos)?  $default,) {final _that = this;
switch (_that) {
case _TodosModel() when $default != null:
return $default(_that.todos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodosModel implements TodosModel {
  const _TodosModel({final  List<TodoModel>? todos}): _todos = todos;
  factory _TodosModel.fromJson(Map<String, dynamic> json) => _$TodosModelFromJson(json);

 final  List<TodoModel>? _todos;
@override List<TodoModel>? get todos {
  final value = _todos;
  if (value == null) return null;
  if (_todos is EqualUnmodifiableListView) return _todos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TodosModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodosModelCopyWith<_TodosModel> get copyWith => __$TodosModelCopyWithImpl<_TodosModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodosModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodosModel&&const DeepCollectionEquality().equals(other._todos, _todos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_todos));

@override
String toString() {
  return 'TodosModel(todos: $todos)';
}


}

/// @nodoc
abstract mixin class _$TodosModelCopyWith<$Res> implements $TodosModelCopyWith<$Res> {
  factory _$TodosModelCopyWith(_TodosModel value, $Res Function(_TodosModel) _then) = __$TodosModelCopyWithImpl;
@override @useResult
$Res call({
 List<TodoModel>? todos
});




}
/// @nodoc
class __$TodosModelCopyWithImpl<$Res>
    implements _$TodosModelCopyWith<$Res> {
  __$TodosModelCopyWithImpl(this._self, this._then);

  final _TodosModel _self;
  final $Res Function(_TodosModel) _then;

/// Create a copy of TodosModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todos = freezed,}) {
  return _then(_TodosModel(
todos: freezed == todos ? _self._todos : todos // ignore: cast_nullable_to_non_nullable
as List<TodoModel>?,
  ));
}


}


/// @nodoc
mixin _$TodoModel {

/// ID
 int? get id;/// ユーザーID
 int? get userId;/// タイトル
@JsonKey(name: 'todo') String? get todo;/// 完了したかどうか
 bool? get completed;
/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoModelCopyWith<TodoModel> get copyWith => _$TodoModelCopyWithImpl<TodoModel>(this as TodoModel, _$identity);

  /// Serializes this TodoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.todo, todo) || other.todo == todo)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,todo,completed);

@override
String toString() {
  return 'TodoModel(id: $id, userId: $userId, todo: $todo, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $TodoModelCopyWith<$Res>  {
  factory $TodoModelCopyWith(TodoModel value, $Res Function(TodoModel) _then) = _$TodoModelCopyWithImpl;
@useResult
$Res call({
 int? id, int? userId,@JsonKey(name: 'todo') String? todo, bool? completed
});




}
/// @nodoc
class _$TodoModelCopyWithImpl<$Res>
    implements $TodoModelCopyWith<$Res> {
  _$TodoModelCopyWithImpl(this._self, this._then);

  final TodoModel _self;
  final $Res Function(TodoModel) _then;

/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? todo = freezed,Object? completed = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,todo: freezed == todo ? _self.todo : todo // ignore: cast_nullable_to_non_nullable
as String?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [TodoModel].
extension TodoModelPatterns on TodoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoModel value)  $default,){
final _that = this;
switch (_that) {
case _TodoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoModel value)?  $default,){
final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? userId, @JsonKey(name: 'todo')  String? todo,  bool? completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
return $default(_that.id,_that.userId,_that.todo,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? userId, @JsonKey(name: 'todo')  String? todo,  bool? completed)  $default,) {final _that = this;
switch (_that) {
case _TodoModel():
return $default(_that.id,_that.userId,_that.todo,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? userId, @JsonKey(name: 'todo')  String? todo,  bool? completed)?  $default,) {final _that = this;
switch (_that) {
case _TodoModel() when $default != null:
return $default(_that.id,_that.userId,_that.todo,_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodoModel implements TodoModel {
  const _TodoModel({this.id, this.userId, @JsonKey(name: 'todo') this.todo, this.completed});
  factory _TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);

/// ID
@override final  int? id;
/// ユーザーID
@override final  int? userId;
/// タイトル
@override@JsonKey(name: 'todo') final  String? todo;
/// 完了したかどうか
@override final  bool? completed;

/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoModelCopyWith<_TodoModel> get copyWith => __$TodoModelCopyWithImpl<_TodoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.todo, todo) || other.todo == todo)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,todo,completed);

@override
String toString() {
  return 'TodoModel(id: $id, userId: $userId, todo: $todo, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$TodoModelCopyWith<$Res> implements $TodoModelCopyWith<$Res> {
  factory _$TodoModelCopyWith(_TodoModel value, $Res Function(_TodoModel) _then) = __$TodoModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? userId,@JsonKey(name: 'todo') String? todo, bool? completed
});




}
/// @nodoc
class __$TodoModelCopyWithImpl<$Res>
    implements _$TodoModelCopyWith<$Res> {
  __$TodoModelCopyWithImpl(this._self, this._then);

  final _TodoModel _self;
  final $Res Function(_TodoModel) _then;

/// Create a copy of TodoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? todo = freezed,Object? completed = freezed,}) {
  return _then(_TodoModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,todo: freezed == todo ? _self.todo : todo // ignore: cast_nullable_to_non_nullable
as String?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
