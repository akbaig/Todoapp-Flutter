import 'package:flutter/material.dart';

class TimeSelector extends StatefulWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final TimeOfDay initialTime; 
  TimeSelector({this.enabled = true, this.initialTime, this.onPressed});
  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  TimeOfDay time;
  
  @override
  void initState() {
    time = widget.initialTime != null ? widget.initialTime : TimeOfDay.now();
    super.initState();
  }

  @override
    void didUpdateWidget(covariant TimeSelector oldWidget) {
      time = widget.initialTime != null ? widget.initialTime : TimeOfDay.now();
      super.didUpdateWidget(oldWidget);
    }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.enabled ? widget.onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.alarm),
          Text(
            '${time.hourOfPeriod.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.hour < 12 ? "AM" : "PM"}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ) 
    );
  }

  /*_showTimePicker(BuildContext context) async {
    TimeOfDay selectedtime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if(selectedtime != null)
    {
      setState(() {
        time = selectedtime;        
      });
    }
  }*/
}