import 'package:flutter/material.dart';
import '../../context/user_provider.dart';
import '../../utils/constants.dart';

/// LoginScreen — email / password with validation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  bool _loading = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      final auth = UserProvider.of(context);
      final success = await auth.login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      if (success) {
        Navigator.pushReplacementNamed(context, Routes.main);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 32,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Studier',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Connect with peer tutors',
                    style: TextStyle(fontSize: 16, color: AppColors.gray400),
                  ),
                  const SizedBox(height: 48),

                  // Email field
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.white),
                    decoration: _inputDecoration('Email'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    style: const TextStyle(color: AppColors.white),
                    decoration: _inputDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.gray400,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) {
                        return 'At least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.backgroundDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.backgroundDark,
                              ),
                            )
                          : const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Register link
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.register),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(color: AppColors.gray400),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.gray400),
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
