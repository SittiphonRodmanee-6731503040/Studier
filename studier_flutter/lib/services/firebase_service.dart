import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user_model.dart';
import '../models/tutor_model.dart';

/// Singleton service wrapping all Firestore and Storage operations.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════════════════════════════════════
  // USERS
  // ═══════════════════════════════════════════════════════════════════════════

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _db.collection('users');

  /// Create or overwrite a user document (uses Firebase Auth UID as doc ID).
  Future<void> setUser(AppUser user) async {
    await _usersCol.doc(user.id).set(user.toMap(), SetOptions(merge: true));
  }

  /// Fetch a single user by ID.
  Future<AppUser?> getUser(String uid) async {
    final doc = await _usersCol.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  /// Fetch a user by email (for login lookup).
  Future<AppUser?> getUserByEmail(String email) async {
    final snap = await _usersCol
        .where('email', isEqualTo: email.toLowerCase())
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return AppUser.fromFirestore(snap.docs.first);
  }

  /// Update specific fields on a user document.
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _usersCol.doc(uid).update(data);
  }

  /// Delete user account data and related reviews.
  Future<void> deleteUserCompletely(String uid) async {
    // Fetch both query sets concurrently to reduce total latency.
    final results = await Future.wait([
      _reviewsCol.where('reviewerId', isEqualTo: uid).get(),
      _reviewsCol.where('tutorId', isEqualTo: uid).get(),
    ]);

    final byReviewer = results[0];
    final byTutor = results[1];

    // De-duplicate in case a review matches both queries.
    final reviewRefs = <DocumentReference<Map<String, dynamic>>>{
      ...byReviewer.docs.map((doc) => doc.reference),
      ...byTutor.docs.map((doc) => doc.reference),
    }.toList();

    await _deleteDocsInBatches(reviewRefs);

    // Delete user profile document.
    await _usersCol.doc(uid).delete();
  }

  Future<void> _deleteDocsInBatches(
    List<DocumentReference<Map<String, dynamic>>> refs,
  ) async {
    const chunkSize = 450;
    for (var i = 0; i < refs.length; i += chunkSize) {
      final end = (i + chunkSize < refs.length) ? i + chunkSize : refs.length;
      final chunk = refs.sublist(i, end);
      final batch = _db.batch();
      for (final ref in chunk) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TUTORS (users where isTutor == true)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Fetch all tutors.
  Future<List<Tutor>> getAllTutors() async {
    final snap = await _usersCol.where('isTutor', isEqualTo: true).get();
    final tutors = snap.docs
        .map((doc) => Tutor.fromMap(doc.data(), id: doc.id))
        .toList();
    return _mergeLiveReviewStats(tutors);
  }

  /// Fetch tutors filtered by a subject tag.
  Future<List<Tutor>> getTutorsBySubject(String subject) async {
    final snap = await _usersCol
        .where('isTutor', isEqualTo: true)
        .where('subjectTags', arrayContains: subject)
        .get();
    final tutors = snap.docs
        .map((doc) => Tutor.fromMap(doc.data(), id: doc.id))
        .toList();
    return _mergeLiveReviewStats(tutors);
  }

  /// Fetch a single tutor by ID.
  Future<Tutor?> getTutor(String tutorId) async {
    final doc = await _usersCol.doc(tutorId).get();
    if (!doc.exists) return null;
    final tutor = Tutor.fromMap(doc.data()!, id: doc.id);
    final reviews = await getReviewsForTutor(tutorId);
    final count = reviews.length;
    final avg = count == 0
        ? 0.0
        : reviews.fold<double>(0, (sum, r) => sum + r.rating) / count;
    return Tutor(
      id: tutor.id,
      name: tutor.name,
      avatarUrl: tutor.avatarUrl,
      profession: tutor.profession,
      education: tutor.education,
      bio: tutor.bio,
      hourlyRate: tutor.hourlyRate,
      currency: tutor.currency,
      subjectTags: tutor.subjectTags,
      averageRating: double.parse(avg.toStringAsFixed(1)),
      totalReviews: count,
      totalSessions: tutor.totalSessions,
      university: tutor.university,
      major: tutor.major,
      yearLevel: tutor.yearLevel,
      lineId: tutor.lineId,
      instagramHandle: tutor.instagramHandle,
      phoneNumber: tutor.phoneNumber,
      verified: tutor.verified,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REVIEWS
  // ═══════════════════════════════════════════════════════════════════════════

  CollectionReference<Map<String, dynamic>> get _reviewsCol =>
      _db.collection('reviews');

  /// Fetch all reviews for a tutor, ordered newest first.
  Future<List<Review>> getReviewsForTutor(String tutorId) async {
    try {
      final snap = await _reviewsCol
          .where('tutorId', isEqualTo: tutorId)
          .orderBy('createdAt', descending: true)
          .get();
      return snap.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (_) {
      // Fallback when composite index for (tutorId + createdAt) is unavailable.
      final snap = await _reviewsCol.where('tutorId', isEqualTo: tutorId).get();
      final reviews = snap.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reviews;
    }
  }

  /// Add a new review and update tutor stats.
  Future<void> addReview(Review review) async {
    // 1. Write the review document.
    await _reviewsCol.add(review.toMap());
  }

  /// Toggle like counter for authenticated user (like/unlike).
  Future<bool> likeReview(String reviewId) async {
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final ref = _reviewsCol.doc(reviewId);

    return _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return false;

      final data = snap.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? const []);
      if (likedBy.contains(uid)) {
        tx.update(ref, {
          'likes': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([uid]),
        });
        return true;
      }

      tx.update(ref, {
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([uid]),
      });

      return true;
    });
  }

  Future<List<Tutor>> _mergeLiveReviewStats(List<Tutor> tutors) async {
    if (tutors.isEmpty) return tutors;

    final reviewSnap = await _reviewsCol.get();
    final counts = <String, int>{};
    final sums = <String, double>{};

    for (final doc in reviewSnap.docs) {
      final data = doc.data();
      final tutorId = data['tutorId'] as String?;
      final rating = (data['rating'] as num?)?.toDouble() ?? 0;
      if (tutorId == null || tutorId.isEmpty) continue;
      counts[tutorId] = (counts[tutorId] ?? 0) + 1;
      sums[tutorId] = (sums[tutorId] ?? 0) + rating;
    }

    return tutors.map((t) {
      final count = counts[t.id] ?? 0;
      final avg = count == 0 ? 0.0 : (sums[t.id] ?? 0) / count;
      return Tutor(
        id: t.id,
        name: t.name,
        avatarUrl: t.avatarUrl,
        profession: t.profession,
        education: t.education,
        bio: t.bio,
        hourlyRate: t.hourlyRate,
        currency: t.currency,
        subjectTags: t.subjectTags,
        averageRating: double.parse(avg.toStringAsFixed(1)),
        totalReviews: count,
        totalSessions: t.totalSessions,
        university: t.university,
        major: t.major,
        yearLevel: t.yearLevel,
        lineId: t.lineId,
        instagramHandle: t.instagramHandle,
        phoneNumber: t.phoneNumber,
        verified: t.verified,
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEED (push mock data to Firestore — run once)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Seed Firestore with mock users and reviews.
  /// Safe to call multiple times — uses set() with merge.
  Future<void> seedMockData() async {
    // Avoid import cycle: we import mock_data inline.
    final mockData = await _getMockData();
    final users = mockData['users'] as List<AppUser>;
    final reviews = mockData['reviews'] as List<Review>;

    final batch = _db.batch();

    for (final user in users) {
      batch.set(_usersCol.doc(user.id), user.toMap(), SetOptions(merge: true));
    }

    for (final review in reviews) {
      // Use a deterministic ID so re-seeding doesn't duplicate.
      batch.set(
        _reviewsCol.doc('seed_${review.id}'),
        review.toMap(),
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }

  Future<Map<String, dynamic>> _getMockData() async {
    // Dynamic import to avoid pulling mock_data into production builds.
    final mock = await Future.value(_lazyMockData());
    return mock;
  }

  Map<String, dynamic> _lazyMockData() {
    // This will be filled in by the seed caller.
    // We keep it as a method so the import stays lazy.
    throw UnimplementedError(
      'Call FirebaseService.seedFromMockData() with explicit data instead.',
    );
  }

  /// Seed with explicit data (called from a dev/admin screen).
  Future<void> seedFromMockData({
    required List<AppUser> users,
    required List<Review> reviews,
  }) async {
    final batch = _db.batch();

    for (final user in users) {
      batch.set(_usersCol.doc(user.id), user.toMap(), SetOptions(merge: true));
    }

    for (final review in reviews) {
      batch.set(
        _reviewsCol.doc('seed_${review.id}'),
        review.toMap(),
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }
}
