import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Atom: A small chip displaying a subject name.
class SubjectChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const SubjectChip({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Text(
          '#$label',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.backgroundDark : AppColors.gray300,
          ),
        ),
      ),
    );
  }
}
