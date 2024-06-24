import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

import 'local_notification.dart';

class NotificationLogic {
  static final NotificationLogic _instance = NotificationLogic._internal();

  factory NotificationLogic() => _instance;

  NotificationLogic._internal();

  final String projectId = 'employee-307bb';

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    if (message.notification != null) {
      NotificationService().showNotification(
          message.notification!.title!, message.notification!.body!);
    }
  }

  Future<void> initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    messaging.subscribeToTopic("allDevices");
    messaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.notification?.title}");
      NotificationService().showNotification(
          message.notification!.title!, message.notification!.body!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.notification?.title}");
    });
  }

  Future<auth.AccessToken> _getAccessToken() async {
    final accountCredentials = auth.ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "employee-307bb",
      "private_key_id": "f4337d2c5ad34427f90d23f9ee9196afb7b100e8",
      "private_key":
      "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDBtb+iz8EzVvFe\n+gnUgoNGxaNRbNYpwiSadWeySV1TMcnKRkRinr77o5ESzfTZ2e8QQiFtvL/48B4Y\n6Ahpwb0+sNI7xvzyrcEKHoFb0JmgMeeh5v/2VajAH5F0dW9Ve9BzDzgtBqXXug6F\nLfM8RRvhSSZ2czvps6OidFqHAj80DN8gJs8TQ5G/Z2ETHQtDIHnAUj60oHlNjy5p\nWVTT0Tv2dQrJqMApi/esxQXOWT7I+9LiWv8/Gm5HnJ5prUKiIAiC/Nw75sBE+RFf\nZMLjcxet66MMJ+feH2Bq3CUcgli97yLHO85x4JD9ZlDqq5Tq/HpLccpJRcmJCnr8\nsqFao7K9AgMBAAECggEAGxU49ApIUKVqaCUyTvq+YEc3+dBAiHnDL1s/LR9Hw97K\nqpQKHKBlmFN6mt6edKpH29s7HEIkXv7cs7kWmrQCgauBgT0QLDKHMk3TN+M25L2w\nInk5tpcBryGFbyW6HqwJwq8mjgOyF91vXpxu4lwmipLKegt2HXXHE5VhUM32HeXO\nhxjtNgdB63CXoYsVppw3HA2uVUUg3TVA8sW2TWOW+V2t2lmqJ5CqjyQnR+dsJkb+\nkN3qfUCTA0QLu/FZxLHig9aYZTTP6F6PjQkdeHIYK93jshf61kqNJ+crb88nCATR\nlJTUk1gj4RRuXZ4qP6ZdjVJxRctOwo1vhh0zWDi92wKBgQDiekzVOhxcczAkPqo+\nYmOC8WfN3Ar9EmwRfyxRawGi4JZHT115wUOx0GZiBBwy0BbB06P+jO5Ewgk8b0v6\n2sLFP3NlgDadipaTL4y6n5q95VAhr5pf21VLSXs17SG7Swxjxaq+4BHOGW6t+kXs\nRx2n1qmfA+efB7106Znf6p7ZewKBgQDa9fe7TbJdQRTuZsSeZ8HDcb2VVL22sENm\nv1OzuFQF7XKRimjgT95heqzZB926E9x2DlfEemn0rNB4pDpVDZud2+Tysv5Dhfje\nBPxMAFaPymv5iWnLbekT39kZfprqA+4rnfBWbCr44+5DtS8tRrM6HlH/og2WrLZp\neH/hJCJjJwKBgQCDROP3y0DZDSLgPzoqApkvMoE6PspXuS/OTGoBnwZJw+cW2heS\nFMUJ8YMGWN+HTDmEiwlI56LLU7RKxS/C7L1r2sUmFdSSJ9vy3+Kv4Qat/pYdkEzo\nNpcPlj3GGfYtOuipg87d574qOW9/g8q3ktjLiY6zTm4YLUJQ232G3dTItQKBgQCa\nOnq+keG60ea+beC8evT+h5U0JDZlAg7XxphclM+KRVBXt5hbt6Y6H0C0tle1g9vb\nxAqKOHd9gmRtNbBozGb6cDL5yJ5UTX+YUwarOem+6qPXZrUAN3DfMOMolAbmItKW\nIm9xUEuMeHARfQO37n67xzOWzjyoDwuFivz4Ro16LQKBgBXTUFbiZuq+94eQ6YvK\n8z8YSObE/hik5n40pDCME60xV8jQzwKmYJe9DHsDWTdpOFzdoOC87sru6Dg9nFlc\nlqEqvk3bmyiSczFqkw8GfSPRq472x3mGYlQSHm0wEzjWHwpoRm1fXFor9EJItpM6\n5J2koXUWZztU/JKaWjpYStlP\n-----END PRIVATE KEY-----\n",
      "client_email":
      "firebase-adminsdk-nieiu@employee-307bb.iam.gserviceaccount.com",
      "client_id": "117398666212722226195",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
      "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
      "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nieiu%40employee-307bb.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });

    final authClient = await auth.clientViaServiceAccount(
      accountCredentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    return authClient.credentials.accessToken;
  }

  Future<void> sendNotification(String token, String title, String body) async {
    try {
      final accessToken = await _getAccessToken();
      print("accessToken: ${accessToken.data}");

      final url =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${accessToken.data}',
        },
        body: jsonEncode(
          {
            'message': {
              'token': token, // Use the correct token here
              'notification': {
                'title': title,
                'body': body,
              },
              'android': {
                'priority': 'high',
              },
            },
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  Future<void> sendNotificationToAllUsers( String title,
      String body) async {
    try {
      final accessToken = await _getAccessToken();
      print("accessToken: ${accessToken.data}");

      final url =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${accessToken.data}',
        },
        body: jsonEncode(
          {
            'message': {
              'topic': "allDevices",
              // Use the topic to send to all users subscribed to this topic
              'notification': {
                'title': title,
                'body': body,
              },
              'android': {
                'priority': 'high',
              },
            },
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  Future<List<String>> getAllUserTokens() async {
    List<String> tokens = [
      // Replace with actual tokens
    ];
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      value.docs.forEach((e) {
        tokens.add(e.data()["token"]);
      });
    });

    return tokens;
  }
}
