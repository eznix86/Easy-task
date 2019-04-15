import 'package:flutter/material.dart';
import 'list.dart';

void main() {
  runApp(ContentView()); //the App
}

class ContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        
        accentColor: Color.fromRGBO(253, 253, 254, 1.0),
        fontFamily: 'Dosis',
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            InfoBox(),
          ],
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(253, 253, 254, 1.0),
          centerTitle: true,
          title: Text(
            "All Tasks",
            style: TextStyle(color: Colors.black, fontSize: 24.0),
          ),
        ),
        body: Container(
          color: Color.fromRGBO(253, 253, 254, 1.0),
          child: ToDoList(), //List of TODOS
        ),
      ),
    );
  }
}

class InfoBox extends StatefulWidget {
  @override
  _InfoBoxState createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueAccent,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Made by Bruno Bernard © 2018"),
                    ],
                  ),
                ),
              );
          return false;
        },
        child: Icon(Icons.info_outline),
      ),
    );
  }
}
