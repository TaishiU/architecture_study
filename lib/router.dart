import 'package:architecture_study/ui/home/todo_detail/view/todo_detail_screen.dart';
import 'package:architecture_study/ui/home/todo_list/view/todo_list_screen.dart';
import 'package:architecture_study/ui/login/view/login_screen.dart';
import 'package:architecture_study/ui/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('フィード画面'));
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('メッセージ画面'));
}

class Tab1Screen extends StatelessWidget {
  const Tab1Screen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('タブ1画面'));
}

class Tab2Screen extends StatelessWidget {
  const Tab2Screen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('タブ2画面'));
}

class Tab3Screen extends StatelessWidget {
  const Tab3Screen({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('タブ3画面'));
}

class Tab1DetailsScreen extends StatelessWidget {
  const Tab1DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('タブ1詳細')),
    body: const Center(child: Text('タブ1詳細画面')),
  );
}

class Tab2DetailsScreen extends StatelessWidget {
  const Tab2DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('タブ2詳細')),
    body: const Center(child: Text('タブ2詳細画面')),
  );
}

class Tab3DetailsScreen extends StatelessWidget {
  const Tab3DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('タブ3詳細')),
    body: const Center(child: Text('タブ3詳細画面')),
  );
}

class FeedDetailsScreen extends StatelessWidget {
  const FeedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('フィード詳細')),
    body: const Center(child: Text('フィード詳細画面')),
  );
}

class MessageDetailsScreen extends StatelessWidget {
  const MessageDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('メッセージ詳細')),
    body: const Center(child: Text('メッセージ詳細画面')),
  );
}

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('プロフィール編集')),
    body: const Center(child: Text('プロフィール編集画面')),
  );
}

// --- 共通UIシェルのウィジェット (例: Bottom Navigation Barを持つScaffold) ---
class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // ここに現在のGoRouteの画面が表示される
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // GoRouterを使ってナビゲーション
          switch (index) {
            case 0:
              context.go(TodoListScreen.path); // /home ではなく /home/tab1 に直接遷移
            case 1:
              context.go('/feed');
            case 2:
              context.go('/messages');
            case 3:
              context.go(ProfileScreen.path);
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// --- 共通UIシェルのウィジェット (例: Tab Barを持つScaffold) ---
class ScaffoldWithTabBar extends StatefulWidget {
  const ScaffoldWithTabBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<ScaffoldWithTabBar> createState() => _ScaffoldWithTabBarState();
}

class _ScaffoldWithTabBarState extends State<ScaffoldWithTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 現在のパスに基づいてタブの初期インデックスを設定
    final currentPath = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;
    var initialIndex = 0;
    if (currentPath.startsWith('/home/tab2')) {
      initialIndex = 1;
    } else if (currentPath.startsWith('/home/tab3')) {
      initialIndex = 2;
    }
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      // タブが変更されたときにGoRouterでナビゲート
      switch (_tabController.index) {
        case 0:
          context.go(TodoListScreen.path);
        case 1:
          context.go('/home/tab2');
        case 2:
          context.go('/home/tab3');
      }
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabSelection)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'タブ1'),
            Tab(text: 'タブ2'),
            Tab(text: 'タブ3'),
          ],
        ),
      ),
      body: widget.child, // ここに現在のGoRouteの画面が表示される
    );
  }
}

// --- Navigator Keys (ShellRouteごとに異なるキーを使用) ---
// Root Navigator Key (MaterialApp.routerのnavigatorKey)
final _rootNavigatorKey = GlobalKey<NavigatorState>();
// ボトムナビゲーション用のShellRouteのNavigator Key
final _shellNavigatorKey = GlobalKey<NavigatorState>();
// Homeタブ内のタブバー用のShellRouteのNavigator Key
final _homeTabNavigatorKey = GlobalKey<NavigatorState>();

// --- GoRouterの定義 ---
/// プロバイダ
final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      // initialLocation: '/home/tab1', // 初期表示されるパスをTab1に
      // initialLocation: LoginScreen.path,
      initialLocation: TodoListScreen.path,
      navigatorKey: _rootNavigatorKey,
      // ルートのNavigator Key
      routes: [
        // GoRoute(
        //   path: TodoListScreen.path,
        //   // name: 'tab1',
        //   builder: (context, state) => const TodoListScreen(),
        //   routes: [
        //     GoRoute(
        //       path: ':todoId', // /todo_list/:todoId
        //       builder: (context, state) {
        //         final todoId = int.parse(
        //           state.pathParameters['todoId']!,
        //         );
        //         return TodoDetailScreen(todoId: todoId);
        //       },
        //     ),
        //   ],
        // ),

        // ログイン画面 (共通のShellRouteとは独立したルート)
        GoRoute(
          path: LoginScreen.path,
          builder: (context, state) => const LoginScreen(),
        ),

        // Bottom Navigation Bar を持つShellRoute
        ShellRoute(
          navigatorKey: _shellNavigatorKey, // このShellRoute専用のNavigator Key
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            // Homeタブに対応するルート群
            ShellRoute(
              // parentNavigatorKey を _shellNavigatorKey に設定することで、
              // このShellRouteが_shellNavigatorKeyのNavigator内に存在することを指定
              // ここで独自のnavigatorKey(_homeTabNavigatorKey)を持つことで、タブバー内の遷移が独立する
              parentNavigatorKey: _shellNavigatorKey,
              navigatorKey: _homeTabNavigatorKey,
              builder: (context, state, child) {
                // ここでAppBarとTabBarを持つScaffoldを返す
                return ScaffoldWithTabBar(child: child);
              },
              routes: [
                // Home内のタブ1
                GoRoute(
                  path: TodoListScreen.path,
                  // name: 'tab1',
                  builder: (context, state) => const TodoListScreen(),
                  routes: [
                    GoRoute(
                      path: ':todoId', // /todo_list/:todoId
                      builder: (context, state) {
                        final todoId = int.parse(
                          state.pathParameters['todoId']!,
                        );
                        return TodoDetailScreen(todoId: todoId);
                      },
                    ),
                    GoRoute(
                      path: 'details', // /home/tab1/details
                      name: 'tab1Details',
                      builder: (context, state) => const Tab1DetailsScreen(),
                    ),
                  ],
                ),
                // Home内のタブ2
                GoRoute(
                  path: '/home/tab2',
                  // name: 'tab2',
                  builder: (context, state) => const Tab2Screen(),
                  routes: [
                    GoRoute(
                      path: 'details', // /home/tab2/details
                      name: 'tab2Details',
                      builder: (context, state) => const Tab2DetailsScreen(),
                    ),
                  ],
                ),
                // Home内のタブ3
                GoRoute(
                  path: '/home/tab3',
                  // name: 'tab3',
                  builder: (context, state) => const Tab3Screen(),
                  routes: [
                    GoRoute(
                      path: 'details', // /home/tab3/details
                      name: 'tab3Details',
                      builder: (context, state) => const Tab3DetailsScreen(),
                    ),
                  ],
                ),
              ],
            ),

            // Feedタブに対応するルート
            GoRoute(
              path: '/feed',
              name: 'feed',
              builder: (context, state) => const FeedScreen(),
              routes: [
                GoRoute(
                  path: 'details', // /feed/details
                  name: 'feedDetails',
                  builder: (context, state) => const FeedDetailsScreen(),
                ),
              ],
            ),

            // Messagesタブに対応するルート
            GoRoute(
              path: '/messages',
              name: 'messages',
              builder: (context, state) => const MessagesScreen(),
              routes: [
                GoRoute(
                  path: 'details', // /messages/details
                  name: 'messageDetails',
                  builder: (context, state) => const MessageDetailsScreen(),
                ),
              ],
            ),

            // Profileタブに対応するルート
            GoRoute(
              path: ProfileScreen.path,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit', // /profile/edit
                  name: 'profileEdit',
                  builder: (context, state) => const ProfileEditScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      // refreshListenable: ref.read(authRepositoryProvider),
      // redirect: (context, state) async {
      //   final loggedIn = await checkIsLoggedIn(ref);
      //   final loggingIn = state.matchedLocation == LoginScreen.path;
      //   // ユーザーがログインしていない場合は、ログイン画面へ
      //   if (!loggedIn) {
      //     return LoginScreen.path;
      //   }
      //   // ログイン済みのユーザーがまだログイン画面にいる場合は、ホームのTodoリスト画面へ
      //   if (loggingIn) {
      //     return TodoListScreen.path;
      //   }
      //   return null;
      // },
      // エラーハンドリング (オプション)
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('エラー')),
        body: Center(child: Text('エラー: ${state.error}')),
      ),
    );
  },
);
