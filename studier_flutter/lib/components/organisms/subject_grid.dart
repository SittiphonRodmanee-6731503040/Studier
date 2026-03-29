import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
    final chipRow = Row(
      children: [
        for (var i = 0; i < subjects.length; i++) ...[
          SubjectChip(
            label: subjects[i],
            isActive: subjects[i] == activeSubject,
            onTap: () => onSubjectTap?.call(subjects[i]),
          ),
          if (i != subjects.length - 1) const SizedBox(width: 12),
        ],
      ],
    );

    return SizedBox(
      height: 44,
      child: Scrollbar(
        thumbVisibility: false,
        thickness: 2,
        radius: const Radius.circular(999),
        child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
            },
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: chipRow,
          ),
        ),
      ),
    );
  }
}
