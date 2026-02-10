import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../theme/app_design.dart'; // For AppDesign colors
import 'main_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '972134944969-f5o2coieffjjjpjha34i39c0u69ioenu.apps.googleusercontent.com',
  );

  @override
  void initState() {
    super.initState();
    // Check if already authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        _navigateToHome();
      }
    });
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        if (mounted) {
          await context.read<AuthProvider>().loginWithGoogle(idToken, 'FARMER');
          if (mounted) {
            _navigateToHome();
          }
        }
      } else {
        throw Exception('Could not get ID Token from Google');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScaffold()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppDesign.booking.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.agriculture,
                  size: 60,
                  color: AppDesign.booking,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome to AgriSetu',
                style: AppDesign.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppDesign.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Connect with machines and farmers nearby.',
                textAlign: TextAlign.center,
                style: AppDesign.bodyLarge.copyWith(
                  color: AppDesign.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              _isLoading
                  ? const CircularProgressIndicator(color: AppDesign.booking)
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleGoogleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Placeholder for Google Logo - using Icon for now
                            // In real app use: Image.asset('assets/google_logo.png', height: 24),
                            const Icon(
                              Icons.g_mobiledata,
                              size: 32,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Sign in with Google',
                              style: AppDesign.labelLarge.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              const SizedBox(height: 24),
              Text(
                'By signing in, you agree to our Terms and Privacy Policy',
                textAlign: TextAlign.center,
                style: AppDesign.caption.copyWith(
                  color: AppDesign.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
