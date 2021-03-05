import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:todoapp/models/color_button.dart';

void main()
{
  runApp(MyApp());
}

GlobalKey myKey = new GlobalKey(); 

class CustomTile extends StatefulWidget {
  final String title;
  final Color color;

  CustomTile({this.title, this.color});

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  double progress = 0.1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LinearPercentIndicator(
                width: (MediaQuery.of(context).size.width)-((MediaQuery.of(context).size.width)*0.3),
                animation: true,
                lineHeight: 20.0,
                animationDuration: 1500,
                percent: progress,
                //center: Text("90%", style: TextStyle(fontWeight: FontWeight.bold),),
                linearStrokeCap: LinearStrokeCap.roundAll,
                //progressColor: widget.color,
                linearGradient: LinearGradient(
                  /*begin: Alignment.centerRight,
                  end: Alignment.centerLeft,*/
                  colors: [widget.color, widget.color.withOpacity(0.5)], 
                ),
                animateFromLastPercent: true,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if(progress < 0.99)
                      progress += 0.1;                    
                  });
                },
                icon: Icon(Icons.add_circle_outline), 
                color: widget.color,
                iconSize: 30.0,
              ),
            ],
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 2.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
              TextButton(
                onPressed: () {   
                  tiles.remove(widget);               
                  myKey.currentState.setState(() {});
                },
                child: Text('Delete', style: TextStyle(color: Colors.red[300]),)
              ),
            ],
          ),
        )
      ], 
    );
  }
}

final List<Widget> tiles = <Widget>[
  CustomTile(title: 'Do homework', color: Colors.indigo),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainList(
        key: myKey,
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

  /*_showSnackBar(String text) 
  {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(text),
        duration: new Duration(seconds: 4),
      ),
    );
  }*/
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
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
      body: ReorderableListView(
        children: [
          for(final item in tiles)
            Card(
              key: ValueKey(item),
              elevation: 10.0,
              shadowColor: Colors.indigo,
              child: item,
            )
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {        
          });
        },
      ),
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
          tiles.add(CustomTile(title: mytext, color: colors[_selected],));
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