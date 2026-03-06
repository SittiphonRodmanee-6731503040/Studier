import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Molecule: A styled search bar with icon and filter button.
class SearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const SearchBar({
    super.key,
    this.hint = 'Subject, tutor, or university...',
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: AppColors.gray400),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(fontSize: 15, color: AppColors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.gray400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onFilterTap != null)
            GestureDetector(
              onTap: onFilterTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.tune,
                    size: 18, color: AppColors.gray300),
              ),
            ),
        ],
      ),
    );
  }
}
