import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Top-level background message handler (must be a top-level function).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No-op: Firebase will show the notification automatically.
  // If you need to process data in background, do it here.
  print('Background message received: ${message.messageId}');
}

class PushNotificationsHandler {
  static final PushNotificationsHandler _instance =
      PushNotificationsHandler._internal();
  factory PushNotificationsHandler() => _instance;
  PushNotificationsHandler._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _initialized = false;

  /// Initialize push notifications. Call once at app startup.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Register the background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission (iOS will show a dialog, Android 13+ will also ask)
    await _requestPermission();

    // Get and store the FCM token
    await _getAndStoreToken();

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _storeTokenInFirestore(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.notification?.title}');
      // Foreground messages don't show a notification by default on Android.
      // The notification is displayed automatically on iOS.
      // For Android, you could use flutter_local_notifications to show it,
      // but for simplicity we'll let the system handle it.
    });

    // Handle notification tap when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification tapped: ${message.data}');
      // Navigate based on message data if needed
    });

    // Check if the app was opened from a terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state via notification: ${initialMessage.data}');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Push notification permission: ${settings.authorizationStatus}');
    }
  }

  Future<void> _getAndStoreToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _storeTokenInFirestore(token);
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  Future<void> _storeTokenInFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'fcm_tokens': FieldValue.arrayUnion([token]),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error storing FCM token: $e');
    }
  }

  /// Remove the current token from Firestore (call on sign out).
  Future<void> removeToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
          {
            'fcm_tokens': FieldValue.arrayRemove([token]),
          },
        );
      }
    } catch (e) {
      print('Error removing FCM token: $e');
    }
  }
}
