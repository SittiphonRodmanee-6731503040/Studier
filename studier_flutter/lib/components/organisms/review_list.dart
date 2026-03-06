import 'package:flutter/material.dart';
import '../../models/tutor_model.dart';
import '../molecules/review_item.dart';

/// Organism: A non-scrollable list of ReviewItems.
class ReviewList extends StatelessWidget {
  final List<Review> reviews;

  const ReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (_, i) => ReviewItem(review: reviews[i]),
    );
  }
}
