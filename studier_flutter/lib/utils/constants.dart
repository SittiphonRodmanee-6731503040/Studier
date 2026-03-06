import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  static const Color primary = Color(0xFF13EC5B);
  static const Color primaryDark = Color(0xFF0FAE43);
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102216);
  static const Color surfaceDark = Color(0xFF183221);
  static const Color cardDark = Color(0xFF1A2E22);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Gray scale
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
}

/// Route name constants (no hardcoded strings)
class Routes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main'; // Tab shell (Home / + / Profile)
  static const String home = '/home';
  static const String tutorList = '/tutor-list';
  static const String tutorProfile = '/tutor-profile';
  static const String addReview = '/add-review';
  static const String createTutorProfile = '/create-tutor-profile';
  static const String userProfile = '/user-profile';
  static const String editProfile = '/edit-profile';
}

/// Subject list (8 subjects as required)
const List<String> kSubjects = [
  'Calculus',
  'Physics',
  'General Math',
  'Chemistry',
  'Biology',
  'Computer Science',
  'English',
  'History',
];
