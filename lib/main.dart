import 'package:architecture_study/data/services/local_storage/preferences/shared_preferences_service_impl.dart';
import 'package:architecture_study/router/router.dart';
import 'package:architecture_study/utils/unauthorized_error_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferencesWithCache の初期化
  final sharedPreferencesWithCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      // アプリケーションで利用するキーをallowListに指定
      allowList: <String>{
        'access_token',
        'refresh_token',
      },
    ),
  );

  // SharedPreferencesServiceImpl のインスタンス作成
  final sharedPreferencesServiceImpl = SharedPreferencesServiceImpl(
    sharedPreferencesWithCache,
  );

  runApp(
    ProviderScope(
      observers: [UnauthorizedErrorObserver()],
      overrides: [
        sharedPreferencesServiceImplProvider.overrideWithValue(
          sharedPreferencesServiceImpl,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

///
class MyApp extends ConsumerWidget {
  /// コンストラクタ
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routerConfig: router,
    );
  }
}
