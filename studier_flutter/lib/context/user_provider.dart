import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Provides [AuthService] down the widget tree via InheritedWidget +
/// ListenableBuilder pattern.  Screens call `UserProvider.of(context)` to
/// access the service.
class UserProvider extends InheritedNotifier<AuthService> {
  const UserProvider({
    super.key,
    required AuthService authService,
    required super.child,
  }) : super(notifier: authService);

  static AuthService of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'No UserProvider found in context');
    return provider!.notifier!;
  }
}
