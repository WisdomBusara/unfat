import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/kaza_loader.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

/// Animated cold-start entrance. Waits for both the entrance animation and
/// the real session check (AuthProvider restoring stored tokens) to finish
/// before navigating, so it neither flashes instantly on a fast device nor
/// gets cut short on a slow one.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _wordmarkScale;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _loaderOpacity;
  late final Animation<double> _creditOpacity;

  bool _minimumTimeElapsed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _wordmarkOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _wordmarkScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic)),
    );
    _taglineOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
    );
    _loaderOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.75, curve: Curves.easeOut),
    );
    _creditOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      _minimumTimeElapsed = true;
      _maybeNavigate();
    });
  }

  void _maybeNavigate() {
    if (_navigated || !_minimumTimeElapsed || !mounted) return;
    final auth = context.read<AuthProvider>();
    if (auth.isCheckingSession) return;

    _navigated = true;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: auth.isAuthenticated ? const HomeScreen() : const LoginScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isCheckingSession) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _maybeNavigate());
        }

        return Scaffold(
          backgroundColor: AppTheme.darkBg,
          body: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _wordmarkOpacity.value,
                      child: Transform.scale(
                        scale: _wordmarkScale.value,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppTheme.accent, AppTheme.accentDeep],
                          ).createShader(bounds),
                          child: const Text(
                            'Kaza',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: _taglineOpacity.value,
                      child: Text(
                        'Tighten. Strengthen.',
                        style: TextStyle(fontSize: 14, color: AppTheme.darkTextSecondary),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Opacity(
                      opacity: _loaderOpacity.value,
                      child: const KazaLoader(size: 28),
                    ),
                    const SizedBox(height: 64),
                    Opacity(
                      opacity: _creditOpacity.value,
                      child: Text(
                        '@wisdomBusara',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          color: AppTheme.darkTextSecondary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
