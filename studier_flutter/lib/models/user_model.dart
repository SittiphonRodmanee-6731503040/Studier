import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for a user (student or tutor).
/// Tutors are users too — their tutor-specific fields are embedded here.
class AppUser {
  final String id;
  final String name;
  final String email;
  final String password; // Mock only — would be hashed server-side
  final String avatarUrl;
  final String university;
  final String major;
  final String? phoneNumber;

  // ── Tutor-specific fields (null when user is not a tutor) ──
  final bool isTutor;
  final String? profession; // e.g. "Senior Software Engineer"
  final String? education; // e.g. "BSc Computer Science"
  final String? bio;
  final double? hourlyRate;
  final String? currency;
  final List<String> subjectTags;
  final double averageRating;
  final int totalReviews;
  final int totalSessions;
  final String? yearLevel;
  final String? lineId;
  final String? instagramHandle;
  final bool verified;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.university,
    required this.major,
    this.phoneNumber,
    this.isTutor = false,
    this.profession,
    this.education,
    this.bio,
    this.hourlyRate,
    this.currency = 'THB',
    this.subjectTags = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.totalSessions = 0,
    this.yearLevel,
    this.lineId,
    this.instagramHandle,
    this.verified = false,
  });

  /// Create a copy with updated fields.
  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? avatarUrl,
    String? university,
    String? major,
    String? phoneNumber,
    bool? isTutor,
    String? profession,
    String? education,
    String? bio,
    double? hourlyRate,
    String? currency,
    List<String>? subjectTags,
    double? averageRating,
    int? totalReviews,
    int? totalSessions,
    String? yearLevel,
    String? lineId,
    String? instagramHandle,
    bool? verified,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      university: university ?? this.university,
      major: major ?? this.major,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isTutor: isTutor ?? this.isTutor,
      profession: profession ?? this.profession,
      education: education ?? this.education,
      bio: bio ?? this.bio,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      currency: currency ?? this.currency,
      subjectTags: subjectTags ?? this.subjectTags,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalSessions: totalSessions ?? this.totalSessions,
      yearLevel: yearLevel ?? this.yearLevel,
      lineId: lineId ?? this.lineId,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      verified: verified ?? this.verified,
    );
  }

  /// Convenience: convert to a map (ready for future JSON / Firestore).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // password intentionally excluded from serialisation
      'avatarUrl': avatarUrl,
      'university': university,
      'major': major,
      'phoneNumber': phoneNumber,
      'isTutor': isTutor,
      'profession': profession,
      'education': education,
      'bio': bio,
      'hourlyRate': hourlyRate,
      'currency': currency,
      'subjectTags': subjectTags,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'totalSessions': totalSessions,
      'yearLevel': yearLevel,
      'lineId': lineId,
      'instagramHandle': instagramHandle,
      'verified': verified,
    };
  }

  /// Create an AppUser from a Firestore document map.
  factory AppUser.fromMap(Map<String, dynamic> map, {String? id}) {
    return AppUser(
      id: id ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: '', // never stored in Firestore
      avatarUrl: map['avatarUrl'] as String? ?? '',
      university: map['university'] as String? ?? '',
      major: map['major'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String?,
      isTutor: map['isTutor'] as bool? ?? false,
      profession: map['profession'] as String?,
      education: map['education'] as String?,
      bio: map['bio'] as String?,
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble(),
      currency: map['currency'] as String? ?? 'THB',
      subjectTags: List<String>.from(map['subjectTags'] ?? []),
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] as int? ?? 0,
      totalSessions: map['totalSessions'] as int? ?? 0,
      yearLevel: map['yearLevel'] as String?,
      lineId: map['lineId'] as String?,
      instagramHandle: map['instagramHandle'] as String?,
      verified: map['verified'] as bool? ?? false,
    );
  }

  /// Create from a Firestore DocumentSnapshot.
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    return AppUser.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
  }
}
