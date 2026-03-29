import 'package:flutter/material.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../atoms/star_rating.dart';

/// Molecule: Displays a single review entry.
class ReviewItem extends StatelessWidget {
  final Review review;
  final VoidCallback? onLike;
  final bool isLiked;
  final bool isDark;

  const ReviewItem({
    super.key,
    required this.review,
    this.onLike,
    this.isLiked = false,
    this.isDark = false,
  });

  String _timeAgo() {
    final diff = DateTime.now().difference(review.createdAt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    return 'Just now';
  }

  ImageProvider? _avatarImage() {
    final url = review.studentAvatar.trim();
    if (url.startsWith('https://') || url.startsWith('http://')) {
      return NetworkImage(url);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _avatarImage();
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.gray100;
    final avatarBackground = isDark ? AppColors.surfaceDark : AppColors.gray200;
    final titleColor = isDark ? AppColors.white : AppColors.gray900;
    final metaColor = isDark ? AppColors.gray500 : AppColors.gray400;
    final bodyColor = isDark ? AppColors.gray300 : AppColors.gray700;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar, name, date, rating
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: avatarBackground,
                backgroundImage: avatar,
                child: avatar == null
                    ? Icon(
                        Icons.person,
                        size: 18,
                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.studentName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      _timeAgo(),
                      style: TextStyle(fontSize: 11, color: metaColor),
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
            style: TextStyle(fontSize: 13, color: bodyColor, height: 1.4),
          ),
          const SizedBox(height: 6),
          // Likes
          Row(
            children: [
              InkWell(
                onTap: onLike,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 14,
                    color: isLiked ? AppColors.primary : AppColors.gray400,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${review.likes}',
                style: TextStyle(fontSize: 12, color: metaColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
