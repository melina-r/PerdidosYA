import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications {
  static Future<void> initNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.title}, ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from notification: ${message.notification?.title}');
    });
  }

  static Future<void> saveToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    String? token = await messaging.getToken();
    String? userMail = FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: userMail)
      .get();

    querySnapshot.docs.first.reference.update({'notification_token': token});
  }

  static Future<List> getUsersWithZone(String zone) async {
    final users = await FirebaseFirestore.instance
    .collection('users')
    .where('zones', arrayContains: zone)
    .get();

    return users.docs.map((doc) => doc['notification_token']).toList();
  }
}