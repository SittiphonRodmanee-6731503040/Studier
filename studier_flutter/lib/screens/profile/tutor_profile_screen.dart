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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = UserProvider.of(context);
    final results = await Future.wait([
      auth.fetchTutor(widget.tutorId),
      auth.fetchReviews(widget.tutorId),
    ]);
    if (mounted) {
      setState(() {
        _tutor = results[0] as Tutor?;
        _reviews = results[1] as List<Review>;
        _loading = false;
      });
    }
  }

  Future<void> _openLine(String? lineId) async {
    if (lineId == null) return;
    final uri = Uri.parse('https://line.me/ti/p/~$lineId');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openInstagram(String? handle) async {
    if (handle == null) return;
    final uri = Uri.parse('https://instagram.com/$handle');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _callPhone(String? phone) async {
    if (phone == null) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.gray900,
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
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tutor not found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please go back and try again.',
                style: TextStyle(color: AppColors.gray600),
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

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        title: const Text('Tutor Profile'),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header organism ──
            TutorHeader(tutor: tutor),

            _divider(),

            // ── Contact section ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Tutor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ContactButton(
                    icon: Icons.chat,
                    label: 'Contact via Line',
                    onPressed: () => _openLine(tutor.lineId),
                  ),
                  const SizedBox(height: 12),
                  ContactButton(
                    icon: Icons.camera_alt,
                    label: 'Contact via Instagram',
                    onPressed: () => _openInstagram(tutor.instagramHandle),
                  ),
                  if (tutor.phoneNumber != null) ...[
                    const SizedBox(height: 12),
                    ContactButton(
                      icon: Icons.phone,
                      label: 'Call ${tutor.phoneNumber}',
                      onPressed: () => _callPhone(tutor.phoneNumber),
                    ),
                  ],
                ],
              ),
            ),

            _divider(),

            // ── Reviews section ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reviews (${reviews.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StarRating(rating: tutor.averageRating, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${tutor.averageRating} average',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...reviews.take(5).map((r) => ReviewItem(review: r)),
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

            // ── Add review button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.addReview,
                    arguments: tutor.id,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
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
    color: AppColors.gray200,
    indent: 16,
    endIndent: 16,
  );
}
