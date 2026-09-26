import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Soft blurred colour blobs for a dashboard header — the "gradient mesh"
/// look currently everywhere on mobile dashboard designs, used here as a
/// quiet backdrop rather than a loud hero image. Blurs pre-drawn shapes via
/// [ImageFiltered] rather than [BackdropFilter], so it never has to blur
/// live scrolling content underneath — cheap enough to sit behind a
/// [ListView] without jank.
class GradientMeshBackdrop extends StatelessWidget {
  final double height;

  const GradientMeshBackdrop({Key? key, this.height = 220}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boost = isDark ? 1.0 : 0.6; // blobs read as louder on a dark base

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ClipRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: Stack(
            children: [
              Positioned(
                top: -70,
                left: -50,
                child: _blob(AppTheme.accent.withOpacity(0.35 * boost), 240),
              ),
              Positioned(
                top: -30,
                right: -70,
                child: _blob(const Color(0xFF60A5FA).withOpacity(0.22 * boost), 200),
              ),
              Positioned(
                top: 70,
                left: 90,
                child: _blob(AppTheme.accentDeep.withOpacity(0.18 * boost), 170),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
