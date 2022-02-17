import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TaskTile extends StatefulWidget {
  final String title;
  final Color color;
  final int portions;
  final String duration;
  final int progress;
  final int reminderHour;
  final int reminderMinute;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  TaskTile({this.title, this.color, this.portions, this.duration, this.progress, this.reminderHour, this.reminderMinute, this.onUpdate, this.onDelete, this.onEdit});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  
  TimeOfDay time;
  
  @override
  void initState() {
    time = TimeOfDay(hour: widget.reminderHour, minute: widget.reminderMinute);
    super.initState(); 
}
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/2.15,
      child: Card(
        elevation: 10.0,
        shadowColor: widget.color,
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    animation: true,
                    animationDuration: 900,
                    animateFromLastPercent: true,
                    percent: widget.progress/widget.portions,
                    center: Text('${((widget.progress/widget.portions)*100).round()} %'),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: widget.color,
                  ),
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: widget.onEdit,
                      child: Text(widget.title, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold))
                    ),
                    Text(
                      '${widget.progress}/${widget.portions} ${widget.duration}',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey[600]//widget.color.withOpacity(1.0),
                      ),
                    ),
                    if(widget.reminderHour != null) Row(
                      //mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.alarm, size: 10.0, color: widget.color),
                        Text('${time.hourOfPeriod.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.hour < 12 ? "AM" : "PM"}',
                          style: TextStyle(
                            fontSize: 8.0
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              right: -10,
              bottom: -10,
              child: CircleAvatar(
                backgroundColor: widget.color,
                radius: 20.0,
              )
            ),
            Positioned(
              right: -12,
              bottom: -12,
              child: IconButton(
                splashRadius: 35.0,
                onPressed: widget.onUpdate,
                icon: Icon(Icons.add),
                color: Colors.white,
                iconSize: 25,
                ),
            ), 
            Positioned(
            right: -12.0,
            top: -12.0,
            child: Opacity(
              opacity: 0.5,
              child: IconButton(
                splashRadius: 15.0,
                onPressed: widget.onDelete,
                icon: Icon(Icons.delete), 
                color: widget.color,
                iconSize: 20.0,
                ),
            ), 
            )
          ],
        ),
      ),
    );
  }
}