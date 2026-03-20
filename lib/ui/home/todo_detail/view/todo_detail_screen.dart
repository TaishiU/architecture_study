import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/ui/home/todo_detail/view_model/todo_detail_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Todo詳細画面
class TodoDetailScreen extends HookConsumerWidget {
  /// コンストラクタ
  const TodoDetailScreen({
    required this.todoId,
    super.key,
  });

  /// パス
  static const path = '/todo_detail/:todoId';

  /// TodoのID
  final int todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModel を todoId で初期化
    final viewModel = ref.watch(todoDetailScreenProvider(todoId));

    return Scaffold(
      appBar: AppBar(title: const Text('Todo Detail')),
      body: switch (viewModel) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncData(value: final state) => _Body(todo: state.todo),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
      },
    );
  }
}


/// Todo詳細本体
class _Body extends HookConsumerWidget {
  const _Body({required this.todo});

  final Todo? todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return todo == null
        ? const Center(child: Text('Todo not found.'))
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${todo!.id}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Text(
                  'Todo: ${todo!.todo}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: todo!.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Completed:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Checkbox(
                      value: todo!.completed,
                      onChanged: (_) => ref
                          .read(todoDetailScreenProvider(todo!.id).notifier)
                          .toggleTodo(),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
