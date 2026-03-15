import 'package:architecture_study/data/services/local/preferences/shared_preferences_service_impl.dart';
import 'package:architecture_study/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferencesWithCache の初期化
  final sharedPreferencesWithCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      // アプリケーションで利用するキーをallowListに指定してください。
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

  // This view is the root of your application.
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

//////////////////////////////////////////////////////////////
