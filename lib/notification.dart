import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'expenses/expenses.dart';
import 'main.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('flutter_logo');

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
              _onDidReceiveNotification(notificationResponse.id,notificationResponse.payload);
            });
  }

  Future<void> _onDidReceiveNotification(int? id, String? payload) async {
    // Perform your desired action here
    print('Notification received with payload: $id');
    //We have come here after the notification was clicked on.
    // navigatorKey.currentState?.pushReplacement(
    //   Expenses(builder: (context) => Expenses()),
    // );
  }

  notificationDetails() {
    // TODO: Use actions field in below to add actions apart from clicking on notification
    return const NotificationDetails(
        android: AndroidNotificationDetails('ID1', 'MainChannel',
            importance: Importance.max));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}