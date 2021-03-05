import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:reorderables/reorderables.dart';
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
  double progress = 0.6;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth/2.15,
      child: Card(
        elevation: 20.0,
        shadowColor: widget.color,
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.5),
                  child: CircularPercentIndicator(
                    radius: screenWidth/8,
                    lineWidth: 5.0,
                    animation: true,
                    animationDuration: 900,
                    animateFromLastPercent: true,
                    percent: progress,
                    center: Text('${(progress*100).round()} %',
                      style: TextStyle(
                        fontSize: 12.0,
                        //fontWeight: FontWeight.bold  
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: widget.color,
                  ),
                ),
                Text(widget.title, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
              ],
            ),
            Positioned(
            right: -12.0,
            top: -12.0,
            child: IconButton(
              icon: Opacity(
                opacity: 0.5,
                child: Icon(Icons.delete)
              ), 
              color: widget.color,
              iconSize: 20.0,
              splashRadius: 15.0,
              onPressed: () {
                tiles.remove(widget);               
                myKey.currentState.setState(() {});
              },
              ), 
            ),
            Positioned(
            right: -12,
            bottom: -12,
            child: IconButton(
              icon: Icon(Icons.add_circle_outlined), 
              color: widget.color,
              iconSize: 20.0,
              splashRadius: 35.0,
              onPressed: () {
                setState(() {
                  if(progress < 0.99)
                    progress += 0.1;                    
                });
              },
              ), 
            ),
          ],
        ),
      ),
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
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = tiles.removeAt(oldIndex);
        tiles.insert(newIndex, row);
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
          for(final item in tiles)
            item
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