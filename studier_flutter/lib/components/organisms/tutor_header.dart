import 'package:flutter/material.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../atoms/avatar.dart';
import '../atoms/star_rating.dart';

/// Organism: The header section of a tutor profile page.
class TutorHeader extends StatelessWidget {
  final Tutor tutor;
  final double? averageRatingOverride;
  final int? totalReviewsOverride;
  final bool isDark;

  const TutorHeader({
    super.key,
    required this.tutor,
    this.averageRatingOverride,
    this.totalReviewsOverride,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final averageRating = averageRatingOverride ?? tutor.averageRating;
    final totalReviews = totalReviewsOverride ?? tutor.totalReviews;
    final backgroundColor = isDark ? AppColors.backgroundDark : AppColors.white;
    final primaryTextColor = isDark ? AppColors.white : AppColors.gray900;
    final secondaryTextColor = isDark ? AppColors.gray300 : AppColors.gray700;
    final tertiaryTextColor = isDark ? AppColors.gray400 : AppColors.gray500;
    final chipColor = isDark
        ? AppColors.surfaceDark
        : AppColors.backgroundLight;
    final chipTextColor = isDark ? AppColors.gray300 : AppColors.gray700;
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.gray100;

    return Container(
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar row
          Row(
            children: [
              Avatar(imageUrl: tutor.avatarUrl, radius: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            tutor.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        if (tutor.verified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tutor.university,
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                    if (tutor.major.trim().isNotEmpty)
                      Text(
                        tutor.major,
                        style: TextStyle(
                          fontSize: 13,
                          color: tertiaryTextColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bio
          _detailLine('Profession/Roles', tutor.profession),
          const SizedBox(height: 6),
          _detailLine('Education', tutor.education),
          const SizedBox(height: 6),
          _detailLine('Expertise/Interests', tutor.subjectTags.join(', ')),
          const SizedBox(height: 6),
          _detailLine('Bio', tutor.bio),

          const SizedBox(height: 12),

          // Subject tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tutor.subjectTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: chipTextColor,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: dividerColor)),
            ),
            child: Row(
              children: [
                _StatTile(
                  value: '${tutor.totalSessions}',
                  label: 'Sessions',
                  isDark: isDark,
                ),
                _divider(),
                _StatTile(
                  value: '${averageRating.toStringAsFixed(1)}',
                  label: 'Rating',
                  trailing: StarRating(rating: averageRating, size: 12),
                  isDark: isDark,
                ),
                _divider(),
                _StatTile(
                  value: totalReviews.toString(),
                  label: 'Reviews',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailLine(String label, String value) {
    final text = value.trim().isEmpty ? '-' : value.trim();
    return Text(
      '$label: $text',
      style: TextStyle(
        fontSize: 14,
        color: isDark ? AppColors.gray300 : AppColors.gray700,
        height: 1.4,
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 32,
    color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.gray100,
  );
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Widget? trailing;
  final bool isDark;

  const _StatTile({
    required this.value,
    required this.label,
    this.trailing,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (trailing != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trailing!,
                const SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.gray900,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : AppColors.gray900,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.gray400 : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
