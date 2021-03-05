import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:todoapp/models/color_button.dart';
import 'package:todoapp/models/task_tile.dart';
import 'package:todoapp/models/task.dart';
import 'file.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    //print("Native called background task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

void main() {
  runApp(MyApp());
}

List<Task> myList = <Task>[
  //Task(progress: 0.6, title: 'Do homework', color: Colors.indigo),
];

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
    print('init');
    Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
    //Workmanager.registerPeriodicTask("1", "simpleTask", frequency: Duration(minutes: 1));
      super.initState();
    }

  void loadFromDisk() async
  {
    List<dynamic> data = await readFile();
    if(data != null)
    {
      setState(() {   
        for(var i in data)
          myList.add(Task.fromJson(i)); 
      });
    }
    print('LFD');
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
      body: ReorderableWrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 4.0,
        runSpacing: 4.0,
        maxMainAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: [
          for(var i = 0; i < myList.length; i++)
            TaskTile(
              progress: myList[i].progress,
              title: myList[i].title,
              color: myList[i].color,
              onUpdate: () {
                setState(() {
                  if(myList[i].progress < 0.99)
                  {
                    myList[i].progress += 0.1;
                    saveFile(myList);
                  }                
                });
                Workmanager.registerOneOffTask("1", "simpletask");  
              },
              onDelete: () {
                setState(() {
                  myList.removeAt(i);
                  saveFile(myList);                  
                });
              },
              onEdit: () {
                mytext = myList[i].title;
                showDialog(
                  context: context, 
                  child: AlertDialog(
                    title: Text('Edit task title'),
                    content: TextField(
                      onChanged: (text) => mytext = text,
                      decoration: InputDecoration(hintText: myList[i].title),
                    ),
                    actions: [
                      FlatButton( //cancel button
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Save'),
                        onPressed: () {
                          setState(() {
                            myList[i].title = mytext;                            
                          });
                          saveFile(myList);
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
    // set up the button
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: TextStyle(color: Colors.red),),
      onPressed: () => Navigator.of(context).pop(),
    );

    Widget okButton = FlatButton(
      child: Text("Ok", style: TextStyle(color: Colors.grey),),
      onPressed: () { 
          setState(() {
          myList.add(Task(progress: 0.4, title: mytext, color: colors[_selected],));
          saveFile(myList);
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (text) => mytext = text, 
                decoration: InputDecoration(hintText: 'Untitled'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                  ColorRadioButton(
                    color: colors[0],
                    value: 0,
                    groupValue: _selected,  
                    onpressed: () {
                      setState(() {                                      
                        _selected = 0;
                      });
                    },
                  ),
                  ColorRadioButton(
                    color: colors[1],
                    value: 1,
                    groupValue: _selected,  
                    onpressed: () {
                      setState(() {                                      
                        _selected = 1;
                      });
                    },
                  ),
                  ColorRadioButton(
                    color: colors[2],
                    value: 2,
                    groupValue: _selected,  
                    onpressed: () {
                      setState(() {                                      
                        _selected = 2;
                      });
                    },
                  ),
                  ColorRadioButton(
                    color: colors[3],
                    value: 3,
                    groupValue: _selected,  
                    onpressed: () {
                      setState(() {                                      
                        _selected = 3;
                      });
                    },
                  ),
                  ColorRadioButton(
                    color: colors[4],
                    value: 4,
                    groupValue: _selected,  
                    onpressed: () {
                      setState(() {                                      
                        _selected = 4;
                      });
                    },
                  )
                ],
              ),
              ),
            ],
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