import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KazaNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const KazaNavItem({required this.icon, required this.label, IconData? activeIcon})
      : activeIcon = activeIcon ?? icon;
}

/// Floating pill-shaped bottom nav — the frosted, rounded, margin-inset bar
/// that's replaced the edge-to-edge Material bottom bar across most current
/// mobile app designs. Selected tabs get a soft accent capsule and reveal
/// their label; unselected tabs stay icon-only to keep the bar compact.
class KazaNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<KazaNavItem> items;

  const KazaNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = (isDark ? AppTheme.darkSurfaceElevated : Colors.white).withOpacity(0.78);
    final borderColor = (isDark ? Colors.white : Colors.black).withOpacity(0.08);
    final inactiveColor = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final selected = i == currentIndex;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.accent.withOpacity(0.16) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected ? item.activeIcon : item.icon,
                            color: selected ? AppTheme.accent : inactiveColor,
                            size: 22,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            child: selected
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      item.label,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.accent,
                                      ),
                                    ),
                                  )
                                : const SizedBox(width: 0, height: 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
