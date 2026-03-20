import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/ui/home/todo_list/view_model/todo_list_screen_view_model.dart';
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
    // 1. ViewModelを監視して AsyncValue<TodoListScreenState> を取得
    final viewModel = ref.watch(todoListScreenProvider);

    // 2. AsyncValueの状態に応じて表示を分岐
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: switch (viewModel) {
        // ロード中
        AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        // データ取得完了（または更新完了）
        AsyncData(value: final state) => _Body(todos: state.todos),
        // エラー発生時
        AsyncError(:final error) => Center(child: Text('Error: $error')),
      },
      // 更新ボタン (例としてRefresh呼び出し)
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(todoListScreenProvider.notifier).refresh(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

/// Todoリスト本体
class _Body extends HookConsumerWidget {
  const _Body({required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // color: index.isEven
              //     ? Colors.yellow.shade100
              //     : Colors.blue.shade100,
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
        separatorBuilder: (BuildContext context, int index) {
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
