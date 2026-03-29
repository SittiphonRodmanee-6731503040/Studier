import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../context/user_provider.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';
import '../../components/atoms/star_rating.dart';
import '../../components/molecules/contact_button.dart';
import '../../components/molecules/review_item.dart';
import '../../components/organisms/tutor_header.dart';

/// TutorProfileScreen — detailed view with bio, reviews, contact buttons.
class TutorProfileScreen extends StatefulWidget {
  final String tutorId;

  const TutorProfileScreen({super.key, required this.tutorId});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  Tutor? _tutor;
  List<Review> _reviews = [];
  bool _loading = true;
  String? _loadError;
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = UserProvider.of(context);
    Tutor? tutor;
    List<Review> reviews = [];
    String? error;

    try {
      tutor = await auth.fetchTutor(widget.tutorId);
    } catch (e) {
      error = 'Unable to load tutor details.';
    }

    try {
      reviews = await auth.fetchReviews(widget.tutorId);
    } catch (_) {
      // Keep the page usable even if reviews query/index fails.
      reviews = [];
      error ??= 'Some tutor data could not be loaded.';
    }

    if (mounted) {
      setState(() {
        _tutor = tutor;
        _reviews = reviews;
        _loadError = error;
        _loading = false;
      });
    }
  }

  Future<void> _openLine(String? lineId) async {
    final raw = lineId?.trim() ?? '';
    if (raw.isEmpty) return;

    final normalized = raw.replaceFirst(RegExp(r'^@+'), '');
    final appUri = Uri.parse('line://ti/p/~$normalized');
    final webUri = Uri.parse('https://line.me/ti/p/~$normalized');

    if (await _tryLaunch(appUri)) return;
    if (await _tryLaunch(webUri, mode: LaunchMode.inAppBrowserView)) return;

    _showLaunchError('Unable to open Line on this device.');
  }

  Future<void> _openInstagram(String? handle) async {
    final raw = handle?.trim() ?? '';
    if (raw.isEmpty) return;

    final username = raw.replaceFirst(RegExp(r'^@+'), '');
    final appUri = Uri.parse('instagram://user?username=$username');
    final webUri = Uri.parse('https://instagram.com/$username');

    if (await _tryLaunch(appUri)) return;
    if (await _tryLaunch(webUri, mode: LaunchMode.inAppBrowserView)) return;

    _showLaunchError('Unable to open Instagram on this device.');
  }

  Future<void> _callPhone(String? phone) async {
    final value = phone?.trim() ?? '';
    if (value.isEmpty) return;

    final uri = Uri.parse('tel:$value');
    if (await _tryLaunch(uri)) return;

    _showLaunchError('Unable to open phone dialer on this device.');
  }

  Future<bool> _tryLaunch(
    Uri uri, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      return await launchUrl(uri, mode: mode);
    } catch (_) {
      return false;
    }
  }

  void _showLaunchError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _likeReview(int index) async {
    if (index < 0 || index >= _reviews.length) return;
    final auth = UserProvider.of(context);
    final uid = auth.currentUser?.id;
    final oldReview = _reviews[index];

    if (uid == null) return;
    final isLiked = oldReview.likedBy.contains(uid);
    final nextLikedBy = isLiked
        ? oldReview.likedBy.where((id) => id != uid).toList()
        : [...oldReview.likedBy, uid];
    final nextLikes = isLiked
        ? (oldReview.likes > 0 ? oldReview.likes - 1 : 0)
        : oldReview.likes + 1;

    setState(() {
      _reviews[index] = Review(
        id: oldReview.id,
        tutorId: oldReview.tutorId,
        likedBy: nextLikedBy,
        studentName: oldReview.studentName,
        studentAvatar: oldReview.studentAvatar,
        rating: oldReview.rating,
        comment: oldReview.comment,
        createdAt: oldReview.createdAt,
        likes: nextLikes,
        reviewerId: oldReview.reviewerId,
      );
    });

    try {
      final ok = await auth.likeReview(oldReview.id);
      if (!ok && mounted) {
        setState(() {
          _reviews[index] = oldReview;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _reviews[index] = oldReview;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageBackground = AppColors.backgroundDark;
    const panelBackground = AppColors.surfaceDark;

    if (_loading) {
      return Scaffold(
        backgroundColor: pageBackground,
        appBar: AppBar(
          backgroundColor: pageBackground,
          foregroundColor: AppColors.white,
          title: const Text('Tutor Profile'),
          elevation: 0.5,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final tutor = _tutor;

    if (tutor == null) {
      return Scaffold(
        backgroundColor: pageBackground,
        appBar: AppBar(
          backgroundColor: pageBackground,
          foregroundColor: AppColors.white,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tutor not found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please go back and try again.',
                style: TextStyle(color: AppColors.gray400),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final reviews = _reviews;
    final currentUid = UserProvider.of(context).currentUser?.id;
    final reviewCount = reviews.length;
    final averageRating = reviewCount == 0
        ? 0.0
        : reviews.fold<double>(0, (sum, r) => sum + r.rating) / reviewCount;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        foregroundColor: AppColors.white,
        title: const Text('Tutor Profile'),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header organism ──
            TutorHeader(
              tutor: tutor,
              averageRatingOverride: averageRating,
              totalReviewsOverride: reviewCount,
              isDark: true,
            ),

            _divider(),

            // ── Contact section ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: panelBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_loadError != null) ...[
                      Text(
                        _loadError!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray400,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    const Text(
                      'Contact Tutor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if ((tutor.lineId ?? '').trim().isNotEmpty)
                      ContactButton(
                        icon: Icons.chat,
                        label: 'Contact via Line',
                        onPressed: () => _openLine(tutor.lineId),
                        isDark: true,
                      ),
                    if ((tutor.instagramHandle ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ContactButton(
                        icon: Icons.camera_alt,
                        label: 'Contact via Instagram',
                        onPressed: () => _openInstagram(tutor.instagramHandle),
                        isDark: true,
                      ),
                    ],
                    if ((tutor.phoneNumber ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ContactButton(
                        icon: Icons.phone,
                        label: 'Call ${tutor.phoneNumber}',
                        onPressed: () => _callPhone(tutor.phoneNumber),
                        isDark: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            _divider(),

            // ── Reviews section ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: panelBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reviews (${reviews.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StarRating(rating: averageRating, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${averageRating.toStringAsFixed(1)} average',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...reviews
                        .take(5)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (entry) => ReviewItem(
                            review: entry.value,
                            isLiked:
                                currentUid != null &&
                                entry.value.likedBy.contains(currentUid),
                            onLike: () => _likeReview(entry.key),
                            isDark: true,
                          ),
                        ),
                    if (reviews.length > 5)
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See all reviews',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Add review button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      Routes.addReview,
                      arguments: tutor.id,
                    );
                    if (!mounted) return;
                    setState(() {
                      _loading = true;
                      _loadError = null;
                    });
                    await _loadData();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    backgroundColor: panelBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Write a Review',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    thickness: 1,
    color: Color(0x3327D960),
    indent: 16,
    endIndent: 16,
  );
}
