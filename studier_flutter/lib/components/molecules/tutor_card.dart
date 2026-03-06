import 'package:flutter/material.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../atoms/avatar.dart';
import '../atoms/price_tag.dart';
import '../atoms/star_rating.dart';

/// Molecule: A pressable card displaying a tutor's summary info.
/// Contains: circular avatar, name, bio (2-line truncate), horizontal
/// scrollable subject chips, star rating, review count, hourly rate.
class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final VoidCallback? onTap;

  const TutorCard({super.key, required this.tutor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: avatar
            Avatar(
              imageUrl: tutor.avatarUrl,
              radius: 40,
              showOnlineBadge: tutor.verified,
            ),
            const SizedBox(width: 16),

            // Right: info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + price row
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                tutor.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (tutor.verified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified,
                                  size: 16, color: AppColors.primary),
                            ],
                          ],
                        ),
                      ),
                      PriceTag(
                        amount: tutor.hourlyRate,
                        currency: tutor.currency,
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // University
                  Text(
                    tutor.university,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray400,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Bio (2-line truncate)
                  Text(
                    tutor.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray300,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Horizontal scrollable subject chips
                  SizedBox(
                    height: 28,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tutor.subjectTags.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tutor.subjectTags[i],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating + review count
                  Row(
                    children: [
                      StarRating(rating: tutor.averageRating, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${tutor.averageRating}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${tutor.totalReviews} reviews)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
