import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // ******************
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ******************

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.blue),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List news = List();
  String input;

  createNew() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyNews").doc(input);
    //Map
    Map<String, String> news = {"newTitle": input};

    documentReference.set(news).whenComplete(() {
      print("$input created");
    });
  }

  deleteNew(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyNews").doc(item);

    documentReference.delete().whenComplete(() {
      print("deleted");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Text("Add New"),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          createNew();
                          Navigator.of(context).pop();
                        },
                        child: Text("Add")),
                  ],
                );
              });
        },
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("MyNews").snapshots(),
          builder: (context, snapshots) {
            return ListView.builder(
                shrinkWrap: true, // **************
                itemCount: snapshots.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data.docs[index];
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                          margin: EdgeInsets.all(5),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)),
                          child: ListTile(
                            title: Text(documentSnapshot["newTitle"]),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteNew(documentSnapshot["newTitle"]);
                              },
                            ),
                          )));
                });
          }),
    );
  }
}
