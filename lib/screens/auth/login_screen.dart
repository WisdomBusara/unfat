import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kaza_loader.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _entrance.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Login failed')),
      );
    }
  }

  /// Staggered fade + rise for entrance — each element starts a little
  /// after the one before it rather than everything appearing at once.
  Widget _staggered(double start, Widget child) {
    final interval = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, (start + 0.4).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: interval,
      builder: (context, _) {
        return Opacity(
          opacity: interval.value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - interval.value)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _staggered(0.0, Text('Welcome back', style: Theme.of(context).textTheme.displayLarge)),
              const SizedBox(height: 8),
              _staggered(
                0.1,
                Text('Sign in to your fitness journey', style: Theme.of(context).textTheme.bodyLarge),
              ),
              const SizedBox(height: 48),
              _staggered(
                0.2,
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),
              _staggered(
                0.3,
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 32),
              _staggered(
                0.4,
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleLogin,
                        child: authProvider.isLoading
                            ? const KazaLoader(size: 20, color: AppTheme.onAccent)
                            : const Text('Sign In'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _staggered(
                0.5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _staggered(
                0.6,
                Center(
                  child: Text(
                    '@wisdomBusara',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
