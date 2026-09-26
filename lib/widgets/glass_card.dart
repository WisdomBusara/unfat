import 'dart:ui';
import 'package:flutter/material.dart';

/// Frosted-glass surface — blurs whatever sits behind it (a gradient mesh,
/// a photo) rather than sitting on a flat card color. Reserved for the one
/// or two hero surfaces per screen that actually sit over something worth
/// blurring; everything else stays a plain [Card] so the effect keeps its
/// impact instead of becoming wallpaper.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = (isDark ? Colors.white : Colors.white).withOpacity(isDark ? 0.06 : 0.55);
    final border = (isDark ? Colors.white : Colors.white).withOpacity(isDark ? 0.14 : 0.7);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: borderRadius,
            border: Border.all(color: border),
          ),
          child: child,
        ),
      ),
    );
  }
}
