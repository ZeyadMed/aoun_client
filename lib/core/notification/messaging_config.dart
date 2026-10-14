import 'dart:developer';

class MessagingConfig {
  static bool _initializationComplete = false;

  static Future<void> initFirebaseMessaging() async {
    if (_initializationComplete) return;
    log('Firebase Messaging init skipped: Firebase not configured');
    _initializationComplete = true;
  }

  static Future<void> messageHandler(dynamic message) async {
    log('Background message handler skipped: Firebase not configured');
  }

  static void dispose() {
    _initializationComplete = false;
  }
}
