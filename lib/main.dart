import 'package:architecture_study/data/services/preferences/shared_preferences_service_impl.dart';
import 'package:architecture_study/ui/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
class MyApp extends StatelessWidget {
  /// コンストラクタ
  const MyApp({super.key});

  // This screen is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const HomeScreen(),
    );
  }
}
