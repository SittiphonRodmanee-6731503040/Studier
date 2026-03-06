import 'package:flutter/material.dart';
import '../../context/user_provider.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../../components/molecules/search_bar.dart' as app;
import '../../components/organisms/subject_grid.dart';
import '../../components/organisms/tutor_list.dart';

/// HomeScreen — subject search with clickable category chips & featured tutors.
/// The bottom navigation is now handled by MainShell; this screen has no
/// BottomNavigationBar of its own.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _activeSubject;
  String _searchQuery = '';
  List<Tutor> _allTutors = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTutors();
  }

  Future<void> _loadTutors() async {
    final auth = UserProvider.of(context);
    final tutors = await auth.fetchAllTutors();
    if (mounted)
      setState(() {
        _allTutors = tutors;
        _loading = false;
      });
  }

  void _onSubjectTap(String subject) {
    setState(() => _activeSubject = subject);
    Navigator.pushNamed(context, Routes.tutorList, arguments: subject);
  }

  /// Filter tutors based on current search query.
  List<Tutor> get _filteredTutors {
    if (_searchQuery.trim().isEmpty) return _allTutors;
    final q = _searchQuery.toLowerCase();
    return _allTutors.where((t) {
      return t.name.toLowerCase().contains(q) ||
          t.university.toLowerCase().contains(q) ||
          t.major.toLowerCase().contains(q) ||
          t.subjectTags.any((s) => s.toLowerCase().contains(q));
    }).toList();
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
            // ── Header (only "Welcome back!") ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Search bar (wired up) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: app.SearchBar(
                onChanged: (value) => setState(() => _searchQuery = value),
                onFilterTap: () {},
              ),
            ),

            const SizedBox(height: 20),

            // ── Subject chips ──
            SubjectGrid(
              subjects: kSubjects,
              activeSubject: _activeSubject,
              onSubjectTap: _onSubjectTap,
            ),

            const SizedBox(height: 24),

            // ── Tutor results ──
            Expanded(
              child: tutors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: AppColors.gray400.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No tutors found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.gray400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try a different search term',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Featured Tutors'
                                    : 'Results (${tutors.length})',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              if (_searchQuery.isEmpty)
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    Routes.tutorList,
                                    arguments: 'All',
                                  ),
                                  child: const Text(
                                    'See All',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TutorList(
                            tutors: tutors,
                            onTutorTap: (tutor) => Navigator.pushNamed(
                              context,
                              Routes.tutorProfile,
                              arguments: tutor.id,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
