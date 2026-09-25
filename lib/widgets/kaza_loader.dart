import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Branded loading indicator — a rotating open arc with a slow pulse,
/// used everywhere a plain CircularProgressIndicator would otherwise sit
/// (buttons, splash, full-screen loads) so the app reads as one system
/// instead of falling back to stock Material chrome for state that shows
/// up constantly.
class KazaLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const KazaLoader({
    Key? key,
    this.size = 24,
    this.color,
    double? strokeWidth,
  })  : strokeWidth = strokeWidth ?? (size < 20 ? 2 : 3),
        super(key: key);

  @override
  State<KazaLoader> createState() => _KazaLoaderState();
}

class _KazaLoaderState extends State<KazaLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.accent;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ArcPainter(
              progress: _controller.value,
              color: color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  final double strokeWidth;

  _ArcPainter({required this.progress, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    // Slow breathing scale on top of the rotation so the loader reads as
    // alive rather than a spinning ring — subtle, not distracting.
    final pulse = 0.92 + 0.08 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi));
    final scaledRadius = radius * pulse;

    final rotation = progress * 2 * math.pi;
    const arcSweep = math.pi * 1.5; // 270°, leaving a visible gap

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: scaledRadius),
      rotation,
      arcSweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
