import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:clipboard/clipboard.dart';

const OPENAI_KEY = String.fromEnvironment("OPENAI_KEY");

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: LogIn(),
      routes: {
        //'/': (context) => LogIn(),
        '/Nurse': (context) => NurseScreen(),
        '/Physician': (context) => PhysicianScreen(),
        '/Record': (context) => RecordPage(),
      },
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Nurse');
                },
                child: Text("I'm a nurse")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Physician');
                },
                child: Text("I'm a physician"))
          ],
        )));
  }
}

class PhysicianScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ExpressEHR'),
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(children: [
              Icon(
                Icons.person_search,
                color: Colors.blueAccent,
                size: 40,
              ),
              Text(
                "Search Patient",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              )
            ])),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(children: [
              Icon(
                Icons.history,
                color: Colors.blueAccent,
                size: 40,
              ),
              Text(
                "Patient History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              )
            ]))
      ]),
    );
  }
}

class NurseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ExpressEHR'),
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Record');
        },
        child: Row(children: [
          Icon(
            Icons.add,
            color: Colors.blueAccent,
            size: 40,
          ),
          Text(
            "Add patient",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          )
        ]),
      ),
    );
  }
}

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording({
    @required Function(String text) onResult,
    @required ValueChanged<bool> onListening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      onError: (e) => print('Error: $e'),
    );

    if (isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    return isAvailable;
  }
}

class RecordPage extends StatefulWidget {
  RecordPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  //stt.SpeechToText _speech;
  bool isListening = false;
  String text = 'Press the button and start speaking';
  //double _confidence = 1.0;

  //@override
  //void initState() {
  //  super.initState();
  //  _speech = stt.SpeechToText();

  void scanText(String rawText) {
    final text = rawText.toLowerCase();

    if (text.contains("convert")) {
      final body = _getTextAfterCommand(text: text, command: "convert");

      extractInfo(body);
    }
  }

  void extractInfo(body) async {
    //http.post(
    // Uri.parse()

    //);
  }

  static String _getTextAfterCommand({
    @required String text,
    @required String command,
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return null;
    } else {
      return text.substring(indexAfter).trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Record information"),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () async {
                  await FlutterClipboard.copy(text);

                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('✓   Copied to Clipboard')),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: AvatarGlow(
          animate: isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: toggleRecording,
            child: Icon(isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.all(30).copyWith(bottom: 150),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ),
        ));
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              scanText(text);
            });
          }
        },
      );
}
