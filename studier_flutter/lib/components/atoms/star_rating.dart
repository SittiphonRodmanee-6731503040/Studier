import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Atom: Renders a row of star icons based on [rating].
class StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 16,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final int full = rating.floor();
    final bool hasHalf = (rating - full) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) {
        IconData icon;
        if (i < full) {
          icon = Icons.star;
        } else if (i == full && hasHalf) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
