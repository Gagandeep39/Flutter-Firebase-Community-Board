import 'package:firebase_app/model/board.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<Board> boardMessages = List();
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    board = Board("", "");
    databaseReference = database.reference().child("community_board");
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Board"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.subject),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter Subject",
                        labelText: "Subject"

                      ),
                      initialValue: "",
                      onSaved: (val)=>board.subject = val,
                      validator: (val) => val == ""? val : null,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter Message",
                        labelText: "Message"
                      ),
                      initialValue: "",
                      onSaved: (val)=>board.body = val,
                      validator: (val) => val == ""? val : null,
                    ),
                  ),

                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("Post"),
                    onPressed: (){
                      handleSubmit();
                    },
                  ),

                  Flexible(
                    child: FirebaseAnimatedList(
                      query: null,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation animation, int index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                            ),
                            title: Text(boardMessages[index].subject),
                            subtitle: Text(boardMessages[index].body),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }



  void  _onEntryAdded(Event event) {
    setState(() {
      boardMessages.add(Board.fromSnapshot(event.snapshot));
    });
  }

  handleSubmit() {
    final FormState form = formKey.currentState;
    if(form.validate()){  //save form data to database
      form.save();
      form.reset();
//      databaseReference.child(board.subject).set(board.toJson());   //will overwrite current data if same key (subject) is already present in firebase
      databaseReference.push().set(board.toJson());   //will generate a random parent key
    }
  }
}


//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//
//    database.reference().child("message").set({
//      "artist":"Troye Sivan",
//      "song":"Bite"
//    });
//    setState(() {
//      database.reference().child("message").once().then((DataSnapshot snapshot){
//        Map<dynamic, dynamic> map = snapshot.value;
//        print(map.values);
//      });
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
