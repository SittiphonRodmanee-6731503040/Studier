import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Molecule: A row button with icon + label for contacting a tutor.
class ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isDark;

  const ContactButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark ? AppColors.surfaceDark : AppColors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.gray200;
    final textColor = isDark ? AppColors.white : AppColors.gray900;
    final trailingColor = isDark ? AppColors.gray500 : AppColors.gray400;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 20, color: trailingColor),
          ],
        ),
      ),
    );
  }
}
