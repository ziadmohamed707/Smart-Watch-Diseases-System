
import 'package:hive/hive.dart';

class TokenStorage {
  static final _authBox = Hive.box('authBox');

  static Future<void> setToken(String token) async {
    await _authBox.put('authToken', token);
  }

  static String? getToken() {
    return _authBox.get('authToken');
  }

  static Future<void> clearToken() async {
    await _authBox.delete('authToken');
  }
}
