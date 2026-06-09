import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService();
});

class TokenService {
  static const String _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  //Save token to secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
//Get token from secure storage
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }
//Remove token from secure storage
  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
