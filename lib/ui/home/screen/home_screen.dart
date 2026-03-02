import 'package:architecture_study/data/repositories/todos/todo_repository_api.dart';
import 'package:architecture_study/ui/core/app_bar.dart';
import 'package:architecture_study/ui/home/view_model/home_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ホーム画面
class HomeScreen extends HookConsumerWidget {
  /// コンストラクタ
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(
      homeScreenProvider(ref.read(todoRepositoryAPIProvider)),
    );

    return Scaffold(
      appBar: const CoreAppBar(
        title: 'HomeScreen',
      ),
      body: SafeArea(
        child: switch (asyncValue) {
          AsyncLoading<HomeScreenState>() => const Center(
            child: CircularProgressIndicator(),
          ),
          AsyncData<HomeScreenState>(value: final vm) => _Body(vm: vm),
          AsyncError<HomeScreenState>() => const Center(child: Text('Error')),
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.vm});

  final HomeScreenState vm;

  @override
  Widget build(BuildContext context) {
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
