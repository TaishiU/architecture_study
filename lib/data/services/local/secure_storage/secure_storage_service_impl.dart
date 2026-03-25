import 'package:architecture_study/data/services/local/secure_storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final secureStorageServiceImplProvider = Provider<SecureStorageServiceImpl>(
  (ref) => const SecureStorageServiceImpl(FlutterSecureStorage()),
);

/// [SecureStorageService] の実装クラス。
class SecureStorageServiceImpl implements SecureStorageService {
  /// コンストラクタ
  const SecureStorageServiceImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) async {
    return await _storage.read(key:key);
  }

  @override
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
