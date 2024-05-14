import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Add data to secure storage
  Future<void> addData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Get data from secure storage
  Future<String?> getData(String key) async {
    String id = '';
    try {
      id = await _storage.read(key: key) ?? '';
    } catch (e) {}
    return id;
  }

  // Delete data from secure storage
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all data from secure storage
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
