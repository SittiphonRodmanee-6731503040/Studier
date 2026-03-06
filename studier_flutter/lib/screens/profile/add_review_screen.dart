import 'package:flutter/material.dart';
import '../../context/user_provider.dart';
import '../../models/tutor_model.dart';
import '../../utils/constants.dart';

/// AddReviewScreen — form to submit a review with star rating.
class AddReviewScreen extends StatefulWidget {
  final String tutorId;

  const AddReviewScreen({super.key, required this.tutorId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _commentCtrl = TextEditingController();
  int _rating = 0;
  bool _submitting = false;

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a rating')));
      return;
    }
    if (_commentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a comment')));
      return;
    }

    setState(() => _submitting = true);

    final auth = UserProvider.of(context);
    final user = auth.currentUser;

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tutorId: widget.tutorId,
      studentName: user?.name ?? 'Anonymous',
      studentAvatar: user?.avatarUrl ?? '',
      rating: _rating,
      comment: _commentCtrl.text.trim(),
      createdAt: DateTime.now(),
    );

    await auth.submitReview(review);

    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review submitted!')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        title: const Text('Add Review'),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap a star to rate',
              style: TextStyle(fontSize: 14, color: AppColors.gray500),
            ),
            const SizedBox(height: 16),

            // Interactive star rating
            Row(
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Comment
            const Text(
              'Your review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your experience with this tutor...',
                hintStyle: const TextStyle(color: AppColors.gray400),
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.backgroundDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.backgroundDark,
                        ),
                      )
                    : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
