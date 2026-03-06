import 'package:flutter/material.dart';
import '../../context/user_provider.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../../components/molecules/tutor_card.dart';

/// TutorListScreen — scrollable list of tutors filtered by subject.
class TutorListScreen extends StatefulWidget {
  final String subject;

  const TutorListScreen({super.key, required this.subject});

  @override
  State<TutorListScreen> createState() => _TutorListScreenState();
}

class _TutorListScreenState extends State<TutorListScreen> {
  final Set<String> _activeFilters = {};
  List<Tutor> _tutors = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTutors();
  }

  Future<void> _loadTutors() async {
    final auth = UserProvider.of(context);
    final tutors = widget.subject == 'All'
        ? await auth.fetchAllTutors()
        : await auth.fetchTutorsBySubject(widget.subject);
    if (mounted)
      setState(() {
        _tutors = tutors;
        _loading = false;
      });
  }

  List<Tutor> get _filteredTutors => _tutors;

  void _toggleFilter(String filter) {
    setState(() {
      if (_activeFilters.contains(filter)) {
        _activeFilters.remove(filter);
      } else {
        _activeFilters.add(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    final tutors = _filteredTutors;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: AppColors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '#${widget.subject}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          '${tutors.length} tutors available',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 24,
                      color: AppColors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Filter chips ──
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _PrimaryFilterChip(onTap: () {}),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'Under ฿400/hr',
                    active: _activeFilters.contains('price'),
                    onTap: () => _toggleFilter('price'),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: '5 Stars',
                    active: _activeFilters.contains('rating'),
                    onTap: () => _toggleFilter('rating'),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'Available Now',
                    active: _activeFilters.contains('available'),
                    onTap: () => _toggleFilter('available'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Tutor list ──
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tutors.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (_, i) {
                  return TutorCard(
                    tutor: tutors[i],
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.tutorProfile,
                      arguments: tutors[i].id,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ──

class _PrimaryFilterChip extends StatelessWidget {
  final VoidCallback onTap;
  const _PrimaryFilterChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Icon(Icons.tune, size: 18, color: AppColors.backgroundDark),
            SizedBox(width: 6),
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.backgroundDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? AppColors.backgroundDark : AppColors.gray300,
          ),
        ),
      ),
    );
  }
}
