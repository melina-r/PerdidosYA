import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('Token: $token');
  }

  Future<void> handleNotifications(RemoteMessage? message) async {
    if (message == null) {
      return;
    }

    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      final title = notification.title;
      final body = notification.body;
      print('Title: $title, body: $body');
    }

    if (data != null) {
      final from = data['from'];
      final received = data['received'];
      print('From: $from, received: $received');
    }
  }
}