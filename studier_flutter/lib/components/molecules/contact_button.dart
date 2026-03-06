import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Molecule: A row button with icon + label for contacting a tutor.
class ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const ContactButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.gray900,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
