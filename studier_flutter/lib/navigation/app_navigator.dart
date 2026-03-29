import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../context/user_provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/landing/landing_page.dart';
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
      child: MaterialApp(
        title: 'Studier',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        // Always enter through '/' and let InitGate decide once ready.
        initialRoute: '/',
        routes: {
          Routes.welcome: (_) => const LandingPage(),
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
            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => _InitGate(authService: _authService),
              );
          }
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

class _BootLoadingScreen extends StatelessWidget {
  const _BootLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

/// Waits for AuthService to fully initialize, then redirects.
class _InitGate extends StatefulWidget {
  final AuthService authService;

  const _InitGate({required this.authService});

  @override
  State<_InitGate> createState() => _InitGateState();
}

class _InitGateState extends State<_InitGate> {
  bool _hasRedirected = false;

  @override
  void initState() {
    super.initState();
    _waitAndRedirect();
  }

  Future<void> _waitAndRedirect() async {
    while (!widget.authService.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
    }
    if (!mounted || _hasRedirected) return;
    _hasRedirected = true;

    // Defer navigation until after the current frame to avoid
    // Navigator lock assertions in debug mode.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final loggedOutRoute = kIsWeb ? Routes.welcome : Routes.login;
      Navigator.of(context).pushReplacementNamed(
        widget.authService.isLoggedIn ? Routes.main : loggedOutRoute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
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

    // Wait for auth to initialize before checking login status
    if (!auth.isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (!auth.isLoggedIn) {
      // If deletion/logout is already handling navigation, don't race it.
      if (!auth.isNavigatingAway) {
        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != Routes.login) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
          });
        }
      }

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
