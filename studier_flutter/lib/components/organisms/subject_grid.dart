import 'package:flutter/material.dart';
import '../atoms/subject_chip.dart';

/// Organism: A horizontal scrollable row of subject chips.
class SubjectGrid extends StatelessWidget {
  final List<String> subjects;
  final String? activeSubject;
  final ValueChanged<String>? onSubjectTap;

  const SubjectGrid({
    super.key,
    required this.subjects,
    this.activeSubject,
    this.onSubjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: subjects.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final subject = subjects[i];
          return SubjectChip(
            label: subject,
            isActive: subject == activeSubject,
            onTap: () => onSubjectTap?.call(subject),
          );
        },
      ),
    );
  }
}
