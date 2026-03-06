import 'package:logger/logger.dart';

/// カスタムログプリンタ。
/// loggerパッケージの [LogPrinter] を継承し、シンプルなログ出力形式を提供します。
/// 各ログレベルに応じた絵文字と色でメッセージを表示します。
class SimpleLogPrinter extends LogPrinter {
  /// コンストラクタ
  SimpleLogPrinter();

  /// 指定されたログイベントを処理し、整形された文字列リストを返します。
  ///
  /// [event] ログに出力するイベント。
  /// ログレベルに基づいて色と絵文字を適用し、単一の文字列として返します。
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    return [color!('$emoji${event.message}')];
  }
}

/// アプリケーション全体で使用されるロガーインスタンス。
/// [SimpleLogPrinter] を使用してログを整形し出力します。
final logger = Logger(printer: SimpleLogPrinter());
