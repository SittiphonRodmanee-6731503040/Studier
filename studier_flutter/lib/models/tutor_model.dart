import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for a tutor profile.
class Tutor {
  final String id;
  final String name;
  final String avatarUrl;
  final String bio;
  final double hourlyRate;
  final String currency;
  final List<String> subjectTags;
  final double averageRating;
  final int totalReviews;
  final int totalSessions;
  final String university;
  final String major;
  final String yearLevel;
  final String? lineId;
  final String? instagramHandle;
  final String? phoneNumber;
  final bool verified;

  const Tutor({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.hourlyRate,
    this.currency = 'THB',
    required this.subjectTags,
    required this.averageRating,
    required this.totalReviews,
    required this.totalSessions,
    required this.university,
    required this.major,
    required this.yearLevel,
    this.lineId,
    this.instagramHandle,
    this.phoneNumber,
    this.verified = false,
  });

  /// Create a Tutor from a Firestore user document map.
  factory Tutor.fromMap(Map<String, dynamic> map, {String? id}) {
    return Tutor(
      id: id ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0,
      currency: map['currency'] as String? ?? 'THB',
      subjectTags: List<String>.from(map['subjectTags'] ?? []),
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] as int? ?? 0,
      totalSessions: map['totalSessions'] as int? ?? 0,
      university: map['university'] as String? ?? '',
      major: map['major'] as String? ?? '',
      yearLevel: map['yearLevel'] as String? ?? '',
      lineId: map['lineId'] as String?,
      instagramHandle: map['instagramHandle'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      verified: map['verified'] as bool? ?? false,
    );
  }
}

/// Data model for a review.
class Review {
  final String id;
  final String tutorId;
  final String studentName;
  final String studentAvatar;
  final int rating;
  final String comment;
  final int likes;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.tutorId,
    required this.studentName,
    required this.studentAvatar,
    required this.rating,
    required this.comment,
    this.likes = 0,
    required this.createdAt,
  });

  /// Convert to Firestore map.
  Map<String, dynamic> toMap() {
    return {
      'tutorId': tutorId,
      'studentName': studentName,
      'studentAvatar': studentAvatar,
      'rating': rating,
      'comment': comment,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a Review from a Firestore document map.
  factory Review.fromMap(Map<String, dynamic> map, {String? id}) {
    return Review(
      id: id ?? map['id'] as String? ?? '',
      tutorId: map['tutorId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentAvatar: map['studentAvatar'] as String? ?? '',
      rating: map['rating'] as int? ?? 0,
      comment: map['comment'] as String? ?? '',
      likes: map['likes'] as int? ?? 0,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                DateTime.now(),
    );
  }

  /// Create from a Firestore DocumentSnapshot.
  factory Review.fromFirestore(DocumentSnapshot doc) {
    return Review.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
  }
}
