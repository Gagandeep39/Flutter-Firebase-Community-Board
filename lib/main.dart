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
            child: Center(
              child: Form(
                child: Flex(

              key: formKey,
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

                ],
                )
              ),
            ),
          ),

          Flexible(
            child: FirebaseAnimatedList(
              physics: BouncingScrollPhysics(),
              query: databaseReference,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation animation, int index) {
                return Card(
                  margin: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 4.0),
                  borderOnForeground: true,
                  child: ListTile(

                    onTap: (){},
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
