import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'dart:async';
import 'todo.dart';

class NewTask extends StatefulWidget {
  NewTask(this._onAdd);
  final ValueChanged<Todo> _onAdd;
  @override
  _NewTaskState createState() => _NewTaskState(_onAdd);
}

class _NewTaskState extends State<NewTask> with TickerProviderStateMixin {
  _NewTaskState(this._onAdd); //closure to add a new item via this widget
  final ValueChanged<Todo> _onAdd;
  
  AnimationController controller;
  SequenceAnimation sequenceAnimation;
  TextEditingController _textController = new TextEditingController();
  bool opened = false;
  bool forward;
  bool allowToSave;
  @override
  void initState() {
    super.initState();
    //prompt animation
    allowToSave = false;
    controller = new AnimationController(
        vsync: this, duration: const Duration(seconds: 5));

    sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
            anim: new Tween(begin: 0, end: 225),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 2600),
            curve: Curves.elasticInOut,
            tag: "spin")
        .addAnimatable(
            anim: new Tween(begin: 0.0, end: 1.0),
            from: const Duration(milliseconds: 500),
            to: const Duration(milliseconds: 1000),
            curve: Curves.ease,
            tag: "opacity")
        .addAnimatable(
            anim: new Tween(begin: 0.0, end: 10.0),
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 500),
            tag: "elevation")
        .addAnimatable(
            anim: new ColorTween(begin: Colors.blue, end: Colors.white),
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 500),
            tag: "color")
        .addAnimatable(
            anim: new Tween<double>(begin: 0.0, end: 300.0),
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 200),
            tag: "width",
            curve: Curves.easeIn)
        .addAnimatable(
            anim: new Tween<double>(begin: 300.0, end: 400.0),
            from: const Duration(milliseconds: 200),
            to: const Duration(milliseconds: 800),
            tag: "width",
            curve: Curves.decelerate)
        .addAnimatable(
            anim: new Tween<double>(begin: 0.0, end: 100.0),
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 800),
            tag: "height",
            curve: Curves.ease)
        .addAnimatable(
            anim: new Tween<double>(begin: 100.0, end: 170.0),
            from: const Duration(milliseconds: 800),
            to: const Duration(milliseconds: 2000),
            tag: "height",
            curve: Curves.elasticInOut)
        .animate(controller);
  }

  Future<Null> _playAnimation() async {
    try {
      opened
          ? await controller.forward().orCancel
          : await controller.reverse(from: 0.1).orCancel;
    } on TickerCanceled {}
  }

  @override
  void dispose() {
    controller.dispose();
    _textController.dispose();
    super.dispose();
  }
  //closure to add item
  void _addToList(Todo item) {
    _onAdd(item); //send to list.dart
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    
    return Center( //design from prompt
      child: SafeArea(
        child: new Card(
          elevation: sequenceAnimation["elevation"].value,
          child: new Container(
            color: sequenceAnimation["color"].value,
            height: sequenceAnimation["height"].value,
            width: sequenceAnimation["width"].value,
            child: Opacity(
              opacity: sequenceAnimation["opacity"].value,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  title: Text("New Task"),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.blueAccent[700],
                      splashColor: Colors.greenAccent[700],
                      onPressed: () {
                        _textValidation();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Save",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            FontAwesomeIcons.stickyNote,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                     autofocus: opened,
                    controller: _textController,
                    onChanged: _onTyping,
                    maxLength: 50,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Please enter a task'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { //button open prompt and close prompt
    // TODO: implement build
        // final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0?true:false; //if keyboard shows up

    return new Stack(
      overflow: Overflow.visible,
      alignment: new FractionalOffset(.5, 1.0),
      children: [
        new AnimatedBuilder(animation: controller, builder: _buildAnimation),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  colors: [
                Colors.white,
                Colors.white10,
              ])),
          child: new Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: new FloatingActionButton(
              isExtended: true,
              backgroundColor: Color.fromRGBO(54, 161, 226, 1.0),
              notchMargin: 24.0,
              onPressed: () {
                _playAnimation();
                setState(() {
                  opened = !opened;
                });
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return RotationTransition(
                    turns: new AlwaysStoppedAnimation(
                        sequenceAnimation["spin"].value / 360),
                    child: new Icon(
                      Icons.add,
                      size: 40.0,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _textValidation() {
    var _backgroundColor = allowToSave ? Colors.greenAccent[700] : Colors.red;
    var _icon = allowToSave ? Icons.check_circle : Icons.not_interested;
    var _text = allowToSave
        ? Text("New task Added")
        : Text("Task not saved !");
    Scaffold.of(context).showSnackBar(
          SnackBar(
            key: Key("wait"),
            backgroundColor: _backgroundColor,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(_icon),
                SizedBox(
                  width: 10.0,
                ),
                _text,
              ],
            ),
          ),
        );

    if (allowToSave) {
      Todo item = new Todo(
      id: 0, title: _textController.value.text.toString(), selected: false);
      _addToList(item);
      _textController.text = "";
    }
  }

  void _onTyping(String value) {
    setState(() {
      allowToSave = value.trim().length != 0 && value.trim().length > 3;
    });
  }
}
