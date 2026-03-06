import 'package:flutter/material.dart';
import '../../models/tutor_model.dart';
import '../molecules/tutor_card.dart';

/// Organism: A vertical list of TutorCards.
class TutorList extends StatelessWidget {
  final List<Tutor> tutors;
  final ValueChanged<Tutor>? onTutorTap;

  const TutorList({
    super.key,
    required this.tutors,
    this.onTutorTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tutors.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        final tutor = tutors[i];
        return TutorCard(
          tutor: tutor,
          onTap: () => onTutorTap?.call(tutor),
        );
      },
    );
  }
}
