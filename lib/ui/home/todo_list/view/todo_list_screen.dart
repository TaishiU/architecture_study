import 'package:architecture_study/ui/home/todo_list/view_model/todo_list_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ホーム画面
class TodoListScreen extends HookConsumerWidget {
  /// コンストラクタ
  const TodoListScreen({super.key});

  /// パス
  static const path = '/todo_list';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(todoListScreenProvider);

    return switch (asyncValue) {
      AsyncLoading<TodoListScreenState>() => const Center(
        child: CircularProgressIndicator(),
      ),
      AsyncData<TodoListScreenState>(value: final vm) => _Body(vm: vm),
      AsyncError<TodoListScreenState>() => const Center(child: Text('Error')),
    };
  }
}

class _Body extends HookConsumerWidget {
  const _Body({required this.vm});

  final TodoListScreenState vm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: vm.todos.todos.length,
      itemBuilder: (context, index) {
        final todo = vm.todos.todos[index];
        return Container(
          height: 50,
          color: index.isEven ? Colors.yellow.shade300 : Colors.blue.shade300,
          child: Text(
            '${todo.id}: ${todo.todo}',
            style: const TextStyle(fontSize: 30),
          ),
        );
      },
    );
  }
}
