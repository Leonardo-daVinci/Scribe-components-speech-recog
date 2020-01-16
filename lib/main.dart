import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false; //used to know if we're ready to interact with the platform
  bool _isListening = false;  //used to know if app is listening to microphone
  
  String resultText ="";

  @override
  void initState() {
    super.initState();
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(()=> _isAvailable = result)
    );

    _speechRecognition.setRecognitionStartedHandler(
      ()=> setState(()=> _isListening = true)
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(()=> resultText = speech)
    );

    _speechRecognition.setRecognitionCompleteHandler(
      ()=> setState(()=> _isListening = false)
    );

    _speechRecognition.activate().then(
      (result) => setState(()=>_isAvailable = result)
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Recognition'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              //width can be controlled using the following line. This takes 60% of user's screen width
              width: MediaQuery.of(context).size.width*0.6 ,

              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0)
              ),

              padding: EdgeInsets.symmetric(vertical: 8, horizontal:12),

              child: Text(resultText),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //3 buttons are required to cancel, start and stop user speech.
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition.cancel().then(
                        (result) => setState((){
                          _isListening = result;
                          resultText = "";
                        }),
                      );
                    }
                  },
                  ),
                
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.pink,
                  onPressed: (){
                    if(_isAvailable && !_isListening){
                      _speechRecognition.listen(locale: "en_US").then((result)=> print('$result'));
                    }
                  },
                  ),
                
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition.stop().then((result)=> setState(()=> _isListening = result));
                    }
                  },
                ),
            ],
            ),
        ],
        ),
      )
    );
  }
}