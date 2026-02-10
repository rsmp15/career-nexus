import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<void> sendOtp(String phoneNumber) async {
    await apiClient.dio.post(
      '/api/auth/otp/send/',
      data: {'phone_number': phoneNumber},
    );
  }

  Future<Map<String, dynamic>> verifyOtp(
    String phoneNumber,
    String otp, {
    String role = 'FARMER',
  }) async {
    final response = await apiClient.dio.post(
      '/api/auth/otp/verify/',
      data: {'phone_number': phoneNumber, 'otp': otp, 'role': role},
    );

    // Returns { 'token': '...', 'user': {...} }
    return response.data;
  }

  Future<Map<String, dynamic>> loginWithGoogle(
    String idToken, {
    String role = 'FARMER',
  }) async {
    final response = await apiClient.dio.post(
      '/api/auth/google/',
      data: {'id_token': idToken, 'role': role},
    );

    // Returns { 'token': '...', 'user': {...} }
    return response.data;
  }

  Future<User> getMe() async {
    final response = await apiClient.dio.get('/api/auth/me/');
    return User.fromJson(response.data);
  }

  Future<void> logout() async {
    // Clear token locally
    apiClient.setToken(null);
  }
}
