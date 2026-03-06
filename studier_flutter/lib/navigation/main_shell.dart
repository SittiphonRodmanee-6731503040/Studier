import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../screens/search/home_screen.dart';
import '../screens/profile/user_profile_screen.dart';
import '../context/user_provider.dart';

/// Main shell with a 3-button bottom bar: Home · + (Become Tutor) · Profile.
/// The plus button is an elevated FAB-style button in the centre.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Only 2 real tabs (Home=0, Profile=1). The plus button is an action, not a tab.
  static const _pages = <Widget>[HomeScreen(), UserProfileScreen()];

  void _onPlusTap() {
    final auth = UserProvider.of(context);
    if (auth.currentUser != null && auth.currentUser!.isTutor) {
      // Already a tutor — show info dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are already registered as a tutor!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.pushNamed(context, Routes.createTutorProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ── Home ──
                _NavButton(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),

                // ── Plus / Become Tutor ──
                GestureDetector(
                  onTap: _onPlusTap,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                ),

                // ── Profile ──
                _NavButton(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  isActive: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A single bottom-nav item.
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.gray400;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
