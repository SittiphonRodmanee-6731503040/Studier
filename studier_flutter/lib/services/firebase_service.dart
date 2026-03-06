import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../models/tutor_model.dart';

/// Singleton service wrapping all Firestore and Storage operations.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // ═══════════════════════════════════════════════════════════════════════════
  // TUTORS (users where isTutor == true)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Fetch all tutors.
  Future<List<Tutor>> getAllTutors() async {
    final snap = await _usersCol.where('isTutor', isEqualTo: true).get();
    return snap.docs
        .map((doc) => Tutor.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  /// Fetch tutors filtered by a subject tag.
  Future<List<Tutor>> getTutorsBySubject(String subject) async {
    final snap = await _usersCol
        .where('isTutor', isEqualTo: true)
        .where('subjectTags', arrayContains: subject)
        .get();
    return snap.docs
        .map((doc) => Tutor.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  /// Fetch a single tutor by ID.
  Future<Tutor?> getTutor(String tutorId) async {
    final doc = await _usersCol.doc(tutorId).get();
    if (!doc.exists) return null;
    return Tutor.fromMap(doc.data()!, id: doc.id);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REVIEWS
  // ═══════════════════════════════════════════════════════════════════════════

  CollectionReference<Map<String, dynamic>> get _reviewsCol =>
      _db.collection('reviews');

  /// Fetch all reviews for a tutor, ordered newest first.
  Future<List<Review>> getReviewsForTutor(String tutorId) async {
    final snap = await _reviewsCol
        .where('tutorId', isEqualTo: tutorId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((doc) => Review.fromFirestore(doc)).toList();
  }

  /// Add a new review and update tutor stats.
  Future<void> addReview(Review review) async {
    // 1. Write the review document.
    await _reviewsCol.add(review.toMap());

    // 2. Recalculate tutor's average rating and review count.
    final allReviews = await getReviewsForTutor(review.tutorId);
    final count = allReviews.length;
    final avg = allReviews.fold<double>(0, (sum, r) => sum + r.rating) / count;

    await _usersCol.doc(review.tutorId).update({
      'totalReviews': count,
      'averageRating': double.parse(avg.toStringAsFixed(1)),
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STORAGE (avatar uploads)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Upload avatar bytes and return the download URL.
  Future<String> uploadAvatar(String uid, List<int> bytes) async {
    final ref = _storage.ref('avatars/$uid.jpg');
    await ref.putData(
      bytes as dynamic,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await ref.getDownloadURL();
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
