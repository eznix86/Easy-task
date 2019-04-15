import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo.dart';
import 'add.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final String mySaveKey = "mylist"; //when saving, key to fetch saved data
  List<Todo> list = []; //the list of todo to work with
  bool _checkIfListIsEmpty = true; 

  @override
  void initState() {
    super.initState();
    //retreive saved data if any at start
    _retreiveList();
   
  }
  
  //add new Item to the list
  _updateList(Todo newItem) {
    setState(() {
      newItem.setId = _checkIfListIsEmpty ? 0 : (list.last.getId + 1);
      list.add(newItem);
    });
     _saveList();
     _isListEmpty();
  }
  //to save list
  _saveList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString(mySaveKey, json.encode(list));
    });
  }


  _retreiveList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String item = sp.getString(mySaveKey);
    setState(() {
     if ( item != null ){
        json
          .decode(item)
          .forEach((map) {
             return list.add(new Todo.fromJson(map));
          });
     } 
    });
    _isListEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _checkIfListIsEmpty
            ? _emptyState() //displays image when list is empty
            : ListView(
                children: list.map(_dismissibleItems).toList(), //else display the list of todos
              ),
        NewTask(_updateList), //receives data from prompted dialog for new task input (closure)
      ],
    );
  }

  //Widget for adding dismissible action on each todo items
  Widget _dismissibleItems(Todo item) {
    return Draggable(
          feedback: Container(color: Colors.grey,),
          child: Dismissible(
        background: _dismissedBackground(),
        key: ValueKey(item.id),
        onDismissed: (DismissDirection direction) { //everytime the dismissed is done
          list.remove(item); //remove the item
           _saveList(); //save the data available data
          _isListEmpty(); //check if its empty
          Scaffold.of(context).showSnackBar( //display a snackbar
                SnackBar(
                  backgroundColor: Colors.blueAccent,
                  content: Text("\"${item.title}\" task removed"),
                ),
              );
        },
        child: _itemOnTheList(item), //generate the items for the list
      ),
    );
  }

  Widget _itemOnTheList(item) {
    return Material(
      child: InkWell(
        onTap: () {
          _selectItem(item); //if tapped, check the item
        },
        onLongPress: () {
          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text("Swipe to remove")));
        },
        child: Card( //design for each items in todo list
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          margin: EdgeInsets.all(8.0),
          elevation: 2.5,
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item.title,
                  style: TextStyle(
                    color: item.selected ? Colors.grey : Colors.black,
                    fontSize: 16.0,
                    decoration: item.selected
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 8.0,
                                  blurRadius: 8.0,
                                  offset: Offset(10.0, 20.0))
                            ]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white,
                        ),
                        child: Icon(
                          item.selected
                              ? Icons.check_circle
                              : FontAwesomeIcons.circle,
                          color: item.selected
                              ? Colors.greenAccent
                              : Colors.blueAccent,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectItem(Todo item) {
    setState(() {
      item.selected = !item.selected;
      _saveList();
    });
  }

  void _isListEmpty() {
    setState(() {
      _checkIfListIsEmpty = list.length == 0 ? true : false;
    });
  }

  _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Center(
        child: Image.asset('assets/empty.png'),
      ),
    );
  }

  Widget _dismissedBackground() {
    return Container(
      color: Colors.red,
      child: new Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
