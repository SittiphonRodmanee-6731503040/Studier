/// App-wide configuration.
/// Flip [useMockData] to `true` to use in-memory mock data instead of Firebase.
class AppConfig {
  /// When `true`, the app uses local mock data (no network calls).
  /// When `false`, the app connects to Firebase Auth + Firestore.
  static const bool useMockData = false;
}
