import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flip;
  
Future<void> initializeReminderSystem() async
{
  flip = FlutterLocalNotificationsPlugin(); 
  final AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher'); 
  final InitializationSettings settings = InitializationSettings(android: android);
  _configureLocalTimeZone(); 
  await flip.initialize(settings,
    onSelectNotification: selectNotification);
}

void selectNotification(String payload) async {
    print("I was selected");
}

Future<void> _configureLocalTimeZone() async {

  tz.initializeTimeZones();
  String timeZoneName;
  try {
    timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    print(timeZoneName);
  } catch (e) {
      print('Could not get the local timezone');
      timeZoneName = 'America/Detroit';
  }
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  print(tz.local);
}

Future<void> scheduleDailyNotification(int id, String title, int hour, int minute) async {
  await flip.zonedSchedule(
    id,
    'Friendly Reminder: Complete your task -> $title',
    'It\'s almost time!',
    _nextInstanceOfTime(hour, minute),
    const NotificationDetails(
      android: AndroidNotificationDetails('tasktracker', 'task_tracker',
            channelDescription: 'channel for task tracker',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
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