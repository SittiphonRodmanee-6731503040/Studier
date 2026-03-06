import 'package:flutter/material.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../atoms/star_rating.dart';

/// Molecule: Displays a single review entry.
class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({super.key, required this.review});

  String _timeAgo() {
    final diff = DateTime.now().difference(review.createdAt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray100, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar, name, date, rating
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.gray200,
                backgroundImage: NetworkImage(review.studentAvatar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.studentName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                    Text(
                      _timeAgo(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),
              StarRating(rating: review.rating.toDouble(), size: 14),
            ],
          ),
          const SizedBox(height: 8),
          // Comment
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.gray700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          // Likes
          Row(
            children: [
              const Icon(Icons.thumb_up_outlined,
                  size: 14, color: AppColors.gray400),
              const SizedBox(width: 4),
              Text(
                '${review.likes}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
