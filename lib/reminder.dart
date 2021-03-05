import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

FlutterLocalNotificationsPlugin flip;
  
void initializeReminderSystem()
{
  flip = new FlutterLocalNotificationsPlugin(); 
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher'); 
  var iOS = new IOSInitializationSettings(); 
    
  // initialise settings for both Android and iOS device. 
  var settings = new InitializationSettings(android: android, iOS: iOS); 
  flip.initialize(settings);
  _configureLocalTimeZone(); 
}

Future<void> _configureLocalTimeZone() async {

  tz.initializeTimeZones();
  String timeZoneName;
  try {
      
       timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
   } on PlatformException {
      timeZoneName = 'America/Detroit';
   }
  //var locations = tz.timeZoneDatabase.locations;
  //tz.setLocalLocation(tz.getLocation(locations.keys.first));
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> scheduleDailyNotification(int id, String title, int hour, int minute) async {
  await flip.zonedSchedule(
    id,
    'Friendly Reminder: Complete your task -> $title',
    'It\'s almost time!',
    _nextInstanceOfTime(hour, minute),
    const NotificationDetails(
      android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          'daily notification description'),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time);
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
}

void removeDailyNotification(int id) async
{
  await flip.cancel(id);
}