import 'package:flutter/material.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';

void main() async {
  runApp(MyApp());
}

createDatabase() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'patient.db');

  var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
  return database;
}

void populateDb(Database database, int version) async {
  await database.execute("CREATE TABLE patients ("
      "patientid INTEGER PRIMARY KEY,"
      "patientname TEXT,"
      "insuranceid TEXT"
      ")");
}

class Patient {
  final int patientid;
  final String patientname;
  final String insuranceid;

  Patient({this.patientid, this.patientname, this.insuranceid});

  Map<String, dynamic> toMap() {
    return {
      'patientid': patientid,
      'patientname': patientname,
      'insuranceid': insuranceid,
    };
  }
}

Future<void> insertPatient(Patient patient) async {
  // Get a reference to the database.
  final Database db = await createDatabase();

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'patients',
    patient.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final emailField = TextField(
      obscureText: false,
      style: style,
      controller: myController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text the that user has entered by using the
                  // TextEditingController.
                  content: Text(myController.text),
                );
              });
          //await insertPatient(fido);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class SecondRoute extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    final lButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdRoute()),
          );
        },
        child: Text("Add Patient",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final mButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdRoute()),
          );
        },
        child: Text("Patient History",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                lButon,
                SizedBox(
                  height: 15.0,
                ),
                mButon,
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class ThirdRoute extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final lButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          /*_insert(c1.text, c2.text, c3.text);

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text the that user has entered by using the
                  // TextEditingController.
                  content: Text(patientsdisp(0)),
                );
              });*/
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VitalRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Confirm",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final patientId = TextField(
      controller: c1,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Patient Id",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final patientName = TextField(
      obscureText: false,
      style: style,
      controller: c2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Patient Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final insuranceId = TextField(
      obscureText: false,
      controller: c3,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Insurance Id",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 35.0,
                ),
                SizedBox(
                  height: 35.0,
                ),
                patientId,
                SizedBox(
                  height: 15.0,
                ),
                patientName,
                SizedBox(
                  height: 15.0,
                ),
                insuranceId,
                SizedBox(
                  height: 15.0,
                ),
                lButon,
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

/*insert(c1, c2, c3) {
  final fido = Patient(
    patientid: c1,
    patientname: c2,
    insuranceid: c3,
  );

  insertPatient(fido);
}

patientsdisp(eno) async {
  // Get a reference to the database.
  final Database db = await createDatabase();

  // Query the table for all The patientss.
  final List<Map<String, dynamic>> maps = await db.query('patients');
  return Text(maps[eno]['patientname']);
  // Convert the List<Map<String, dynamic> into a List<Patient>.
  /*return List.generate(maps.length, (i) {
    return Patient(
      patientid: maps[i]['patientid'],
      patientname: maps[i]['patientname'],
      insuranceid: maps[i]['insuranace'],
    );
  });*/
}
*/
class VitalRoute extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final lButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VitalRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Confirm",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final vButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecordRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Vital signs",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final oButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VitalRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Objective Info",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 35.0,
                ),
                SizedBox(
                  height: 35.0,
                ),
                vButon,
                SizedBox(
                  height: 15.0,
                ),
                oButon,
                SizedBox(
                  height: 205.0,
                ),
                lButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class RecordRoute extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final lButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VitalRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Confirm",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final rButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecordRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Record",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final pButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VitalRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Play",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final dButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffeb4934),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecordRoute()),
          );
          //Navigator.push(
          //context,
          //MaterialPageRoute(builder: (context) => ThirdRoute()),
          //);
        },
        child: Text("Delete",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 35.0,
                ),
                SizedBox(
                  height: 205.0,
                ),
                rButon,
                SizedBox(
                  height: 15.0,
                ),
                pButon,
                SizedBox(
                  height: 15.0,
                ),
                dButon,
                SizedBox(
                  height: 15.0,
                ),
                lButon
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
