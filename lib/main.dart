import 'package:flutter/material.dart';
import 'package:todo_app/utils/formatted_date.dart';

import 'database/database_helper.dart';
import 'models/note.dart';

void main() {
  runApp(MaterialApp(
    title: "Todo-List",
    home: Notes(),
  ));
}

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  var notesController = new TextEditingController();
  var db = new DatabaseHelper();

  List<Note> _itemList = <Note>[];

  @override
  void initState() {
    super.initState();

    readDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Todos"),
        centerTitle: true,
        elevation: 1,
        leading: Icon(Icons.book),
        backgroundColor: Colors.red.shade500,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.red.shade500,
          onPressed: () {
            _showDialog();
          }),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(_itemList[index].name),
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.cancel),
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(_itemList[index].name),
                          subtitle: Text(_itemList[index].date),
                          onTap: () {
                            _onTapItem(context, _itemList[index], index);
                          },
                        ),
                      ),
                      onDismissed: (direction) {
                        _handleDeleteItem(_itemList[index].id);
                        setState(() {
                          _itemList.removeAt(index);
                        });
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Successfully Deleted")));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDialog() {
    var alert = new AlertDialog(
      title: Text("Write your Note Here"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: notesController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (notesController.text.isEmpty && notesController.text == "")
              return;
            _handleSaveData(notesController.text);
            notesController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancl"),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSaveData(String text) async {
    Note note = new Note(text, DateFormatted());
    var saveResultId = await db.insertNote(note);

    Note savedItem = await db.getSingleItem(saveResultId);

    setState(() {
      _itemList.insert(0, savedItem);
    });
  }

  void readDataFromDb() async {
    List items = await db.getAllNotes();
    items.forEach((item) {
      Note note = Note.map(item);

      setState(() {
        _itemList.add(note);
      });
    });
  }

  void _handleDeleteItem(int id) async {
    var deletedItem = await db.deleteItem(id);
    print(deletedItem);
  }

  void _onTapItem(BuildContext context, Note item, int index) {
    var updateTextController = new TextEditingController(text: item.name);

    String text = item.name;

    var updateAlertBox = new AlertDialog(
      title: Text("Update ${item.name}"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: updateTextController,
              decoration: InputDecoration(
                  hintText: "eg. Dont Buy Stuff", labelText: "Item"),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            if (updateTextController.text.isEmpty &&
                updateTextController.text == "") return;
            Note updatedItem = Note.fromMap({
              "name": updateTextController.text,
              "date": DateFormatted(),
              "id": item.id
            });
            Navigator.pop(context);
            _handleUpdateData(item, index);
            await db.updateItem(updatedItem);
            setState(() {
              readDataFromDb();
            });
          },
          child: Text("update"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return updateAlertBox;
        });
  }

  void _handleUpdateData(Note item, int index) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].name == item.name;
      });
    });
  }
}
