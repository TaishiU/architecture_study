import 'package:architecture_study/ui/core/components/core_app_bar.dart';
import 'package:architecture_study/ui/core/components/core_error.dart';
import 'package:architecture_study/ui/home/todo_list/view_model/todo_list_screen_state.dart';
import 'package:architecture_study/ui/home/todo_list/view_model/todo_list_screen_view_model.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Todoリスト画面
class TodoListScreen extends HookConsumerWidget {
  /// コンストラクタ
  const TodoListScreen({super.key});

  /// パス
  static const path = '/todo_list';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(todoListScreenProvider);

    return Scaffold(
      appBar: CoreAppBar(
        title: 'TodoListScreen',
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(todoListScreenProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: switch (viewModel) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncData(value: final result) => switch (result) {
          SuccessResult(value: final state) => _Body(state: state),
          FailureResult(:final error) => CoreError(
            error: error,
            onPressed: () =>
                ref.read(todoListScreenProvider.notifier).refresh(),
          ),
        },
        AsyncError(:final error) => CoreError(
          error: error as Exception,
          onPressed: () => ref.read(todoListScreenProvider.notifier).refresh(),
        ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(todoListScreenProvider.notifier).refresh(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

/// Todoリスト本体
class _Body extends HookConsumerWidget {
  const _Body({required this.state});

  final TodoListScreenState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = state.todos;

    if (todos.isEmpty) {
      return const Center(child: Text('No data found.'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(todoListScreenProvider.notifier).refresh(),
      child: ListView.separated(
        // ListViewが短くてもスクロール可能にして、Pull to refreshを常に有効にする
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return InkWell(
            onTap: () => context.go('${TodoListScreen.path}/${todo.id}'),
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: todo.completed ? Colors.blue.shade100 : Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${todo.id}: ${todo.todo}',
                      style: TextStyle(
                        fontSize: 18,
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: todo.completed,
                    onChanged: (value) async {
                      if (value != null) {
                        await ref
                            .read(todoListScreenProvider.notifier)
                            .toggleTodo(todo.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          );
        },
      ),
    );
  }
}
