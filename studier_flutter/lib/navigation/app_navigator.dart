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

/// Central navigator using named routes.
/// SECURITY: Protected routes require authentication.
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
      child: ListenableBuilder(
        listenable: _authService,
        builder: (context, _) {
          // Show loading while checking auth state
          if (!_authService.isInitialized) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: _buildTheme(),
              home: const Scaffold(
                backgroundColor: AppColors.backgroundDark,
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            );
          }

          return MaterialApp(
            title: 'Studier',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(),
            // Start on main if logged in, login if not
            initialRoute: _authService.isLoggedIn ? Routes.main : Routes.login,
            routes: {
              Routes.login: (_) => const LoginScreen(),
              Routes.register: (_) => const RegisterScreen(),
              Routes.main: (_) => const _AuthGuard(child: MainShell()),
              Routes.createTutorProfile: (_) =>
                  const _AuthGuard(child: CreateTutorProfileScreen()),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case Routes.tutorList:
                  final subject = settings.arguments as String? ?? 'All';
                  return MaterialPageRoute(
                    builder: (_) =>
                        _AuthGuard(child: TutorListScreen(subject: subject)),
                  );
                case Routes.tutorProfile:
                  final tutorId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (_) =>
                        _AuthGuard(child: TutorProfileScreen(tutorId: tutorId)),
                  );
                case Routes.addReview:
                  final tutorId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (_) =>
                        _AuthGuard(child: AddReviewScreen(tutorId: tutorId)),
                  );
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
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
    );
  }
}

/// SECURITY: Auth guard that redirects unauthenticated users to login.
class _AuthGuard extends StatelessWidget {
  final Widget child;

  const _AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = UserProvider.of(context);

    if (!auth.isLoggedIn) {
      // Redirect to login after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
      });

      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return child;
  }
}
