// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodosModel _$TodosModelFromJson(Map<String, dynamic> json) => _TodosModel(
  todos: (json['todos'] as List<dynamic>?)
      ?.map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TodosModelToJson(_TodosModel instance) =>
    <String, dynamic>{'todos': instance.todos};

_TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => _TodoModel(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  todo: json['todo'] as String?,
  completed: json['completed'] as bool?,
);

Map<String, dynamic> _$TodoModelToJson(_TodoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'todo': instance.todo,
      'completed': instance.completed,
    };
