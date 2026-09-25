import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kaza_loader.dart';
import '../onboarding/onboarding_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _entrance.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
    );

    if (!mounted) return;

    if (success && authProvider.currentUser != null) {
      // The backend already created the account + a default profile row on
      // signup; sync it into UserProvider so the rest of the app can read
      // it, then send the user to onboarding to fill in the real details.
      context.read<UserProvider>().setFromAuth(authProvider.currentUser!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Sign up failed')),
      );
    }
  }

  /// Staggered fade + rise for entrance — matches LoginScreen's pattern so
  /// the two auth screens feel like one continuous flow.
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
              _staggered(0.0, Text('Get started', style: Theme.of(context).textTheme.displayLarge)),
              const SizedBox(height: 8),
              _staggered(
                0.1,
                Text(
                  'Create your account and start your fitness journey',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 48),
              _staggered(
                0.15,
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Full name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _staggered(
                0.25,
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
                0.35,
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
                0.45,
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleSignup,
                        child: authProvider.isLoading
                            ? const KazaLoader(size: 20, color: AppTheme.onAccent)
                            : const Text('Create Account'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _staggered(
                0.55,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Sign in'),
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
