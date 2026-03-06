import 'package:flutter/material.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../atoms/avatar.dart';
import '../atoms/star_rating.dart';

/// Organism: The header section of a tutor profile page.
class TutorHeader extends StatelessWidget {
  final Tutor tutor;

  const TutorHeader({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
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
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray900,
                            ),
                          ),
                        ),
                        if (tutor.verified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified,
                              size: 18, color: AppColors.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tutor.university,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray700,
                      ),
                    ),
                    Text(
                      '${tutor.major} · ${tutor.yearLevel}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bio
          Text(
            tutor.bio,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.gray700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Subject tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tutor.subjectTags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray700,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.gray100),
              ),
            ),
            child: Row(
              children: [
                _StatTile(
                    value: '${tutor.totalSessions}', label: 'Sessions'),
                _divider(),
                _StatTile(
                  value: '${tutor.averageRating}',
                  label: 'Rating',
                  trailing: StarRating(
                      rating: tutor.averageRating, size: 12),
                ),
                _divider(),
                _StatTile(
                    value: '${tutor.totalReviews}', label: 'Reviews'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: AppColors.gray100,
      );
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Widget? trailing;

  const _StatTile({required this.value, required this.label, this.trailing});

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
                Text(value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900)),
              ],
            )
          else
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900)),
          const SizedBox(height: 4),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.gray500)),
        ],
      ),
    );
  }
}
