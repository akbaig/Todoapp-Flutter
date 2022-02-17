import 'package:flutter/material.dart';

class Task
{
  String title;
  Color color;
  int portions;
  String duration;
  int progress = 0;
  int reminderId;
  int reminderHour;
  int reminderMinute;

  Task({@required this.title, @required this.color, @required this.portions, @required this.duration, this.progress, this.reminderId, this.reminderHour, this.reminderMinute});

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        color = Color(json['color'] as int),
        portions = json['portions'] as int,
        duration = json['duration'] as String,
        progress = json['progress'] as int,
        reminderId = json['reminderId'] as int,
        reminderHour = json['reminderHour'] as int,
        reminderMinute = json['reminderMinute'] as int;


  Map<String, dynamic> toJson() => {
    'title': title,
    'color': color.value,
    'portions': portions,
    'duration': duration,
    'progress': progress,
    'reminderId': reminderId,
    'reminderHour': reminderHour,
    'reminderMinute': reminderMinute,
  };
}