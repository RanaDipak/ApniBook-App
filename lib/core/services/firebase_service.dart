import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class to handle Firebase operations
class FirebaseService {
  static FirebaseFirestore? _firestore;

  /// Initialize Firebase services
  static Future<void> initialize() async {
    try {
      // Firebase is already initialized in main.dart, just get the instance
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      // Handle Firebase initialization error
      throw Exception('Failed to initialize Firebase: $e');
    }
  }

  /// Get Firestore instance
  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception(
        'Firebase not initialized. Call FirebaseService.initialize() first.',
      );
    }
    return _firestore!;
  }

  /// Check if Firebase is initialized
  static bool get isInitialized => _firestore != null;
}
