class ApiConfig {
  // Use your computer's local IP address here for physical device testing.
  // Make sure your computer and device are on the same Wi-Fi network.
  static const String _localIp = '172.16.88.67';

  static const String devUrl = 'http://$_localIp:8000';
  static const String prodUrl = 'https://api.agrisetu.com'; // Placeholder

  static const String baseUrl = devUrl;
}
