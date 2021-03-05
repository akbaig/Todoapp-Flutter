import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');
void main()
{
  runApp(MyApp());
}

Future<void> _configureLocalTimeZone() async {
      
    
  tz.initializeTimeZones();
  String timeZoneName;
  try {
      timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  } on PlatformException {
      timeZoneName = 'America/Detroit';
  }
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FlutterLocalNotificationsPlugin flip;

  @override
    void initState() {
      super.initState();
      flip = new FlutterLocalNotificationsPlugin(); 
      // app_icon needs to be a added as a drawable 
      // resource to the Android head project. 
      var android = new AndroidInitializationSettings('@mipmap/ic_launcher'); 
      var iOS = new IOSInitializationSettings(); 
        
      // initialise settings for both Android and iOS device. 
      var settings = new InitializationSettings(android: android, iOS: iOS); 
      flip.initialize(settings); 
      _configureLocalTimeZone();
       
    }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hi'),),
        body: Row(
          children: [
            IconButton(
              icon: Icon(Icons.notifications),
              color: Colors.black,
              onPressed: () {
                scheduleNotification();
                /*DateTime t = ;
                final tz.TZDateTime now2 = tz.TZDateTime.utc(t.year, t.month, t.day, t.hour);//, t.month, t.timeZoneOffset.inDays, t.timeZoneOffset.inHours, t.timeZoneOffset.inMinutes);
                print(' Here: ${now2.hour}, ${now2.minute}, ${now2.second}');*/
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              color: Colors.red,
              onPressed: () {
                repeatNotification();
              },
            ),
          ],
        ),
      ),
    );
  } 
  


  Future<void> scheduleNotification() async {
    DateTime t = DateTime.now();
    final tz.TZDateTime now2 = tz.TZDateTime.local(t.year, t.month, t.day, t.hour, t.minute, t.second);//, t.month, t.timeZoneOffset.inDays, t.timeZoneOffset.inHours, t.timeZoneOffset.inMinutes);
    print(' Here: ${now2.hour}, ${now2.minute}, ${now2.second}');
    await flip.zonedSchedule(
        0,
        'Title',
        'Body',
        now2.add(const Duration(seconds: 10)),
        //.now(tz.local)).add(const Duration(seconds: 10)),
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
  Future<void> repeatNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('repeating channel id',
            'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flip.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }
  Future<void> _scheduleDailyTenAMNotification() async {
    await flip.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        _nextInstanceOfTenAM(),
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
   tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}