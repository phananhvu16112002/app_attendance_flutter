import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    print('Write local successfully');
    await storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'No Data Found';
    // print('Data read from secure storage: $value');
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    print('Delete successfully');
    await storage.delete(key: key);
  }
}
