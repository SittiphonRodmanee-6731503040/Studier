import 'package:flutter/material.dart';
import '../context/user_provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/search/tutor_list_screen.dart';
import '../screens/profile/tutor_profile_screen.dart';
import '../screens/profile/add_review_screen.dart';
import '../screens/tutor/create_tutor_profile_screen.dart';
import 'main_shell.dart';

/// Central navigator using named routes (no hardcoded strings).
/// Wraps the entire app in [UserProvider] so every screen can access
/// the shared [AuthService].
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return UserProvider(
      authService: _authService,
      child: MaterialApp(
        title: 'Studier',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.backgroundDark,
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surfaceDark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.backgroundDark,
            foregroundColor: AppColors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        initialRoute: Routes.login,
        routes: {
          Routes.login: (_) => const LoginScreen(),
          Routes.register: (_) => const RegisterScreen(),
          Routes.main: (_) => const MainShell(),
          Routes.createTutorProfile: (_) => const CreateTutorProfileScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.tutorList:
              final subject = settings.arguments as String? ?? 'All';
              return MaterialPageRoute(
                builder: (_) => TutorListScreen(subject: subject),
              );
            case Routes.tutorProfile:
              final tutorId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => TutorProfileScreen(tutorId: tutorId),
              );
            case Routes.addReview:
              final tutorId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => AddReviewScreen(tutorId: tutorId),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
