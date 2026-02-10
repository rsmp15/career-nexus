import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../api/auth_service.dart';
import '../api/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final ApiClient _apiClient;

  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider(this._authService, this._apiClient);

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        _apiClient.setToken(token);
        // Validate token by fetching user details
        try {
          _currentUser = await _authService.getMe();
        } catch (e) {
          // Token might be expired or invalid
          _apiClient.setToken(null);
          await prefs.remove('auth_token');
          _currentUser = null;
        }
      }
    } catch (e) {
      print('Auth Init Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle(String idToken, String role) async {
    _isLoading = true;
    notifyListeners();

    // Verify if this is the correct client ID from the user's file
    // "client_id":"972134944969-tb904i6n1q311sf0clrr61o7pm1rm2vo.apps.googleusercontent.com"
    // Ideally this should be in google-services.json, but since it's missing there, we force it.
    // Note: This logic belongs in the UI layer (LoginScreen) usually, but the provider is orchestrating.
    // Wait, the idToken is passed IN to this method. The GoogleSignIn call happens in the UI.

    try {
      final response = await _authService.loginWithGoogle(idToken, role: role);
      final token = response['token'];
      final user = User.fromJson(response['user']);

      _apiClient.setToken(token);
      _currentUser = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithOtp(String phone, String otp, String role) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.verifyOtp(phone, otp, role: role);
      final token = response['token'];
      final user = User.fromJson(response['user']);

      _apiClient.setToken(token);
      _currentUser = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _apiClient.setToken(null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    notifyListeners();
  }
}
