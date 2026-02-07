import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {


  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isIntialized = false;

  bool get isInitialized => _isIntialized;

  Future<void> initNotification()async{
    if(_isIntialized) return;
    
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );


    const initSetting = InitializationSettings(
      android: androidInit,
      iOS: iOSInit
    );

    await notificationPlugin.initialize(settings: initSetting);



  }
  NotificationDetails notificationDetails (){return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification',
        channelDescription: 'Daily Notification channel',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      )
  );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
})async {
    return notificationPlugin.show(
      id: id,
      title:  title,
      body: body,
      notificationDetails: const NotificationDetails()
    );
  }







}