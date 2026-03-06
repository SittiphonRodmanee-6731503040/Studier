import 'package:flutter_test/flutter_test.dart';
import 'package:studier_flutter/navigation/app_navigator.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AppNavigator());
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
  });
}
