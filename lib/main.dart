import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:todoapp/models/color_button.dart';
import 'package:todoapp/models/task_tile.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/time_selector.dart';
import 'package:todoapp/reminder.dart';
import 'file.dart';

void main() {
  runApp(MyApp());
}

List<Task> myList = <Task>[
  //Task(progress: 0.6, title: 'Do homework', color: Colors.indigo),
];

int reminderCounter = 0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainList(
      )
    );
  }
}
  

class MainList extends StatefulWidget {
  MainList({Key key}) : super(key: key);
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {


  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); 

  @override
  void initState() {
      loadFromDisk();
      initializeReminderSystem();
      super.initState();
    }

  void loadFromDisk() async
  {
    List<dynamic> data = await readFile('content');
    reminderCounter = await readFile('reminder_counter');
    reminderCounter ??= 0;
    if(data != null)
    {
      setState(() {   
        for(var i in data)
          myList.add(Task.fromJson(i)); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String mytext;
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Task row = myList.removeAt(oldIndex);
        myList.insert(newIndex, row);
      });
      
    }
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('To Do App', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.library_add),
            color: Colors.white,
            onPressed: () {
              showAlertDialog(context);
            }
          ),
        ]
      ),
      body: myList.length == 0 ? Center(child: Text('Click icon on corner to add tasks')) : ReorderableWrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 4.0,
        runSpacing: 4.0,
        maxMainAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: [
          for(var i = 0; i < myList.length; i++)
            TaskTile(
              title: myList[i].title,
              color: myList[i].color,
              portions: myList[i].portions,
              duration: myList[i].duration,
              progress: myList[i].progress,
              reminderHour: myList[i].reminderHour,
              reminderMinute: myList[i].reminderMinute,
              onUpdate: () {
                setState(() {
                  if(myList[i].progress < myList[i].portions)
                  {
                    myList[i].progress += 1;
                    saveFile('content', myList);
                  }                
                }); 
              },
              onDelete: () {
                setState(() {
                  if(myList[i].reminderId != null)
                    removeDailyNotification(myList[i].reminderId);
                  myList.removeAt(i);
                  saveFile('content', myList);                  
                });
              },
              onEdit: () {
                mytext = myList[i].title;
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: Text('Edit task title'),
                    content: TextField(
                      onChanged: (text) => mytext = text,
                      decoration: InputDecoration(hintText: myList[i].title),
                    ),
                    actions: [
                      TextButton( //cancel button
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          setState(() {
                            myList[i].title = mytext;                            
                          });
                          saveFile('content', myList);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            )
        ],
        onReorder: _onReorder,
      )
    );
  }

  showAlertDialog(BuildContext context)
  {
    String mytext = 'Untitled';
    List<Color> colors = <Color>[
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.indigo,

    ];
    int _selected = 0;
    bool _switch = false;
    int _portions;
    String _duration = 'Minutes';
    bool _custom = false;
    TimeOfDay _time = TimeOfDay.now();

    // set up the button
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.red),),
      onPressed: () => Navigator.of(context).pop(),
    );

    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed: () { 
          if(_portions == null || _portions == 0)
            _portions = 10;
          setState(() {
            int reminderId = _switch ? reminderCounter++ : null;
            myList.add(Task(title: mytext, color: colors[_selected], portions: _portions, duration: _duration, progress: 0, reminderId: reminderId, reminderHour: _switch ? _time.hour : null, reminderMinute: _switch ? _time.minute : null));
            if(_switch) scheduleDailyNotification(reminderId, mytext, _time.hour, _time.minute);
            saveFile('content', myList);
            saveFile('reminder_counter', reminderCounter);
            Navigator.of(context).pop();
          });
      }
    );

    // set up the AlertDialog

    AlertDialog alert = AlertDialog(
      title: Text("Add new task"),
      content: StatefulBuilder(  // You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) 
        {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: TextField(
                    onChanged: (text) => mytext = text, 
                    decoration: InputDecoration(
                      hintText: 'My Task',
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      ColorRadioButton(
                        color: colors[0],
                        value: 0,
                        groupValue: _selected,  
                        onPressed: () {
                          setState(() {                                      
                            _selected = 0;
                          });
                        },
                      ),
                      ColorRadioButton(
                        color: colors[1],
                        value: 1,
                        groupValue: _selected,  
                        onPressed: () {
                          setState(() {                                      
                            _selected = 1;
                          });
                        },
                      ),
                      ColorRadioButton(
                        color: colors[2],
                        value: 2,
                        groupValue: _selected,  
                        onPressed: () {
                          setState(() {                                      
                            _selected = 2;
                          });
                        },
                      ),
                      ColorRadioButton(
                        color: colors[3],
                        value: 3,
                        groupValue: _selected,  
                        onPressed: () {
                          setState(() {                                      
                            _selected = 3;
                          });
                        },
                      ),
                      ColorRadioButton(
                        color: colors[4],
                        value: 4,
                        groupValue: _selected,  
                        onPressed: () {
                          setState(() {                                      
                            _selected = 4;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.15,
                      child: TextField(
                        onChanged: (String text) => _portions = int.parse(text), 
                        decoration: InputDecoration(
                          hintText: 'Intervals',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    _custom ? 
                      Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.15,
                          child: TextField(
                          onChanged: (String text) => _duration = text, 
                          decoration: InputDecoration(hintText: 'Custom'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.undo),
                          onPressed: () => setState(() {_duration = 'Minutes'; _custom = false; }),
                        )
                      ],
                    ) 
                    : DropdownButton<String>(
                        value: _duration,
                        icon: Icon(Icons.arrow_drop_down_outlined),
                        iconSize: 24.0,
                        elevation: 16,
                        //style: TextStyle(color: Colors.grey),
                        underline: Container(
                          color: Colors.grey,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            if(newValue == 'Custom')
                              setState(() => _custom = true);
                            else _duration = newValue;
                          });
                        },
                        items: <String>['Minutes','Hours', 'Days', 'Weeks', 'Months', 'Custom']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                      onChanged: (bool value) {
                        setState(() {
                          _switch = value;
                        });
                      },
                      value: _switch,
                    ),
                    Text('Reminder')
                  ],
                ),
                TimeSelector(
                  enabled: _switch,
                  initialTime: _time,
                  onPressed: () async {
                    TimeOfDay selectedtime = await showTimePicker(
                      context: context,
                      initialTime: _time,
                    );

                    if(selectedtime != null)
                    {
                      setState(() {
                        _time = selectedtime;        
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}