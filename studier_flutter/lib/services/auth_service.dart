import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user_model.dart';
import '../models/tutor_model.dart';
import '../utils/app_config.dart';
import '../utils/mock_data.dart';
import 'firebase_service.dart';

/// Authentication + user-data service.
///
/// When [AppConfig.useMockData] is `true`  → in-memory mock (no network).
/// When `false`                            → Firebase Auth + Firestore.
class AuthService extends ChangeNotifier {
  AuthService() {
    if (!AppConfig.useMockData) {
      // Listen for Firebase auth state changes (e.g. token refresh, sign-out).
      fb.FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
    }
  }

  // ── State ─────────────────────────────────────────────────────────────────

  AppUser? _currentUser;
  final List<AppUser> _users = List.from(kMockUsers); // mock-mode only

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isTutor => _currentUser?.isTutor ?? false;

  /// All users marked as tutors (mock mode).
  List<AppUser> get tutors => _users.where((u) => u.isTutor).toList();

  /// All users in the database (mock mode).
  List<AppUser> get allUsers => List.unmodifiable(_users);

  // ── Firebase auth-state listener ──────────────────────────────────────────

  Future<void> _onAuthStateChanged(fb.User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
      notifyListeners();
      return;
    }
    // Fetch the Firestore user doc.
    _currentUser = await FirebaseService.instance.getUser(firebaseUser.uid);
    notifyListeners();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ══════════════════════════════════════════════════════════════════════════

  /// Log in with email + password.
  /// Returns `true` on success, `false` on failure.
  Future<bool> login(String email, String password) async {
    if (AppConfig.useMockData) {
      return _mockLogin(email, password);
    }
    try {
      final cred = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (cred.user == null) return false;
      _currentUser = await FirebaseService.instance.getUser(cred.user!.uid);
      notifyListeners();
      return _currentUser != null;
    } on fb.FirebaseAuthException {
      return false;
    }
  }

  /// Quick mock login — bypass password (for demo / testing).
  void loginAsUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Register a new account.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String university = '',
    String major = '',
  }) async {
    if (AppConfig.useMockData) {
      return _mockRegister(
        name: name,
        email: email,
        password: password,
        university: university,
        major: major,
      );
    }
    try {
      final cred = await fb.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      final uid = cred.user!.uid;
      final newUser = AppUser(
        id: uid,
        name: name,
        email: email.trim().toLowerCase(),
        password: '', // not stored in Firestore
        avatarUrl: '',
        university: university,
        major: major,
      );
      await FirebaseService.instance.setUser(newUser);
      _currentUser = newUser;
      notifyListeners();
      return true;
    } on fb.FirebaseAuthException {
      return false;
    }
  }

  /// Sign out.
  Future<void> logout() async {
    if (!AppConfig.useMockData) {
      await fb.FirebaseAuth.instance.signOut();
    }
    _currentUser = null;
    notifyListeners();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROFILE
  // ══════════════════════════════════════════════════════════════════════════

  /// Update the current user's profile fields.
  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
    String? university,
    String? major,
    String? phoneNumber,
  }) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      avatarUrl: avatarUrl,
      university: university,
      major: major,
      phoneNumber: phoneNumber,
    );

    if (AppConfig.useMockData) {
      _syncUser(_currentUser!);
    } else {
      await FirebaseService.instance.updateUser(_currentUser!.id, {
        if (name != null) 'name': name,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (university != null) 'university': university,
        if (major != null) 'major': major,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      });
    }
    notifyListeners();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TUTOR REGISTRATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Register the current user as a tutor.
  Future<bool> registerAsTutor({
    required String profession,
    required String education,
    required String bio,
    required double hourlyRate,
    required List<String> subjectTags,
    String? lineId,
    String? instagramHandle,
    String? phoneNumber,
  }) async {
    if (_currentUser == null) return false;
    if (_currentUser!.isTutor) return false;

    _currentUser = _currentUser!.copyWith(
      isTutor: true,
      profession: profession,
      education: education,
      bio: bio,
      hourlyRate: hourlyRate,
      subjectTags: subjectTags,
      currency: 'THB',
      yearLevel: 'Student',
      verified: false,
      lineId: lineId,
      instagramHandle: instagramHandle,
      phoneNumber: phoneNumber,
    );

    if (AppConfig.useMockData) {
      _syncUser(_currentUser!);
    } else {
      await FirebaseService.instance.setUser(_currentUser!);
    }
    notifyListeners();
    return true;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TUTORS & REVIEWS (Firebase pass-through)
  // ══════════════════════════════════════════════════════════════════════════

  /// Fetch all tutors — used by HomeScreen / search.
  Future<List<Tutor>> fetchAllTutors() async {
    if (AppConfig.useMockData) return kMockTutors;
    return FirebaseService.instance.getAllTutors();
  }

  /// Fetch tutors filtered by subject.
  Future<List<Tutor>> fetchTutorsBySubject(String subject) async {
    if (AppConfig.useMockData) {
      return kMockTutors.where((t) => t.subjectTags.contains(subject)).toList();
    }
    return FirebaseService.instance.getTutorsBySubject(subject);
  }

  /// Fetch a single tutor.
  Future<Tutor?> fetchTutor(String tutorId) async {
    if (AppConfig.useMockData) {
      final matches = kMockTutors.where((t) => t.id == tutorId);
      return matches.isNotEmpty ? matches.first : null;
    }
    return FirebaseService.instance.getTutor(tutorId);
  }

  /// Fetch reviews for a tutor.
  Future<List<Review>> fetchReviews(String tutorId) async {
    if (AppConfig.useMockData) {
      return kMockReviews.where((r) => r.tutorId == tutorId).toList();
    }
    return FirebaseService.instance.getReviewsForTutor(tutorId);
  }

  /// Submit a new review.
  Future<void> submitReview(Review review) async {
    if (AppConfig.useMockData) {
      kMockReviews.insert(0, review);
      return;
    }
    await FirebaseService.instance.addReview(review);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MOCK-ONLY helpers (unchanged from original)
  // ══════════════════════════════════════════════════════════════════════════

  bool _mockLogin(String email, String password) {
    final match = _users.where(
      (u) =>
          u.email.toLowerCase() == email.toLowerCase() &&
          u.password == password,
    );
    if (match.isNotEmpty) {
      _currentUser = match.first;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool _mockRegister({
    required String name,
    required String email,
    required String password,
    String university = '',
    String major = '',
  }) {
    if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return false;
    }
    final newUser = AppUser(
      id: 'u${_users.length + 1}',
      name: name,
      email: email,
      password: password,
      avatarUrl: 'https://i.pravatar.cc/300?img=${50 + _users.length}',
      university: university,
      major: major,
    );
    _users.add(newUser);
    _currentUser = newUser;
    notifyListeners();
    return true;
  }

  void _syncUser(AppUser user) {
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx >= 0) {
      _users[idx] = user;
    }
  }

  /// Look up any user by ID.
  AppUser? getUserById(String id) {
    final matches = _users.where((u) => u.id == id);
    return matches.isNotEmpty ? matches.first : null;
  }
}
