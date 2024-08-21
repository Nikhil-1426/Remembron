// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// class ConvLogPage extends StatefulWidget {
//   const ConvLogPage({super.key});

//   @override
//   State<ConvLogPage> createState() => _ConvLogPageState();
// }

// class _ConvLogPageState extends State<ConvLogPage> {
//   final SpeechToText _speechToText = SpeechToText();

//   bool _speechEnabled = false;
//   bool _isListening = false;
//   String _wordsSpoken = "";
//   String _summary = "";
//   String _reminders = "";
//   double _confidenceLevel = 0;

//   @override
//   void initState() {
//     super.initState();
//     initSpeech();
//   }

//   void initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//     setState(() {});
//   }

//   void _startListening() async {
//     setState(() {
//       _isListening = true;
//     });
//     await _speechToText.listen(onResult: _onSpeechResult);
//   }

//   void _stopListening() async {
//     setState(() {
//       _isListening = false;
//     });
//     await _speechToText.stop();
//   }

//   void _onSpeechResult(result) {
//     setState(() {
//       _wordsSpoken = result.recognizedWords;
//       _confidenceLevel = result.confidence;

//       // Process the text to extract reminders and summarize it
//       _processText(_wordsSpoken);
//     });
//   }

//   void _processText(String text) {
//     final reminderKeywords = [
//       'reminder', 'appointment', 'meeting', 'task', 'event', 'deadline',
//       'due', 'notify', 'alert', 'remind', 'schedule', 'follow-up',
//       'to-do', 'remind me', 'plan', 'remind', 'check', 'update',
//       'set a reminder', 'make a note', 'book', 'reserve', 'assign',
//       'confirm', 'recall', 'message', 'call', 'contact', 'visit',
//       'pick up', 'drop off', 'buy', 'order', 'review', 'finish',
//       'complete', 'report', 'send', 'write', 'reply'
//     ];
//     final reminderList = <String>[];

//     final words = text.split(' ');
//     for (int i = 0; i < words.length; i++) {
//       for (final keyword in reminderKeywords) {
//         if (words[i].toLowerCase().contains(keyword)) {
//           reminderList.add(text.substring(text.indexOf(words[i])));
//           break;
//         }
//       }
//     }

//     final summary = text.length > 100 ? text.substring(0, 100) + '...' : text;

//     setState(() {
//       _summary = summary;
//       _reminders = reminderList.join('\n');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(240, 44, 91, 91),
//         title: Text(
//           'Conversation Logs',
//           style: TextStyle(
//             color: Color.fromARGB(179, 251, 236, 236),
//             fontSize: 22,
//           ),
//         ),
//         leading: IconButton(
//         icon: Icon(
//         Icons.arrow_back,
//         color: Color.fromARGB(179, 251, 236, 236), // Change this to your desired color
//         ),
//       onPressed: () => Navigator.of(context).pop(),
//       ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_isListening)
//               Center(
//                 child: CircularProgressIndicator(),
//               ),
//             SizedBox(height: 16),
//             Text(
//               _speechToText.isListening
//                   ? "Listening..."
//                   : _speechEnabled
//                       ? "Tap the microphone to start recognition..."
//                       : "Speech recognition not available",
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (_wordsSpoken.isNotEmpty)
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.teal[50],
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               spreadRadius: 2,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           _wordsSpoken,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                     SizedBox(height: 16),
//                     if (_summary.isNotEmpty)
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.teal[100],
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               spreadRadius: 2,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           'Summary: $_summary',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                     SizedBox(height: 16),
//                     if (_reminders.isNotEmpty)
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.teal[200],
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               spreadRadius: 2,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           'Reminders:\n$_reminders',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                     SizedBox(height: 100), // To ensure FAB is visible
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _speechToText.isListening ? _stopListening : _startListening,
//         tooltip: _speechToText.isListening ? 'Stop Listening' : 'Start Listening',
//         child: Icon(
//           _speechToText.isListening ? Icons.mic_off : Icons.mic,
//           color: Color.fromARGB(179, 251, 236, 236),
//         ),
//         backgroundColor: Color.fromARGB(240, 44, 91, 91),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ConvLogPage extends StatefulWidget {
  const ConvLogPage({super.key});

  @override
  State<ConvLogPage> createState() => _ConvLogPageState();
}

class _ConvLogPageState extends State<ConvLogPage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = "";
  String _summary = "";
  String _reminders = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
    });
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
    });
    await _speechToText.stop();
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;

      // Process the text to extract reminders and summarize it
      _processText(_wordsSpoken);
    });
  }

  void _processText(String text) {
    final reminderKeywords = [
      'reminder', 'appointment', 'meeting', 'task', 'event', 'deadline',
      'due', 'notify', 'alert', 'remind', 'schedule', 'follow-up',
      'to-do', 'remind me', 'plan', 'remind', 'check', 'update',
      'set a reminder', 'make a note', 'book', 'reserve', 'assign',
      'confirm', 'recall', 'message', 'call', 'contact', 'visit',
      'pick up', 'drop off', 'buy', 'order', 'review', 'finish',
      'complete', 'report', 'send', 'write', 'reply'
    ];
    final reminderList = <String>[];

    final words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      for (final keyword in reminderKeywords) {
        if (words[i].toLowerCase().contains(keyword)) {
          reminderList.add(text.substring(text.indexOf(words[i])));
          break;
        }
      }
    }

    final summary = text.length > 100 ? text.substring(0, 100) + '...' : text;

    setState(() {
      _summary = summary;
      _reminders = reminderList.join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        title: Text(
          'Conversation Logs',
          style: TextStyle(
            color: Color.fromARGB(179, 251, 236, 236),
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(179, 251, 236, 236), // Change this to your desired color
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isListening)
              Center(
                child: CircularProgressIndicator(),
              ),
            SizedBox(height: 16),
            Text(
              _speechToText.isListening
                  ? "Listening..."
                  : _speechEnabled
                      ? "Tap the microphone to start recognition..."
                      : "Speech recognition not available",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_wordsSpoken.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color.fromARGB(240, 44, 91, 91), // Border color
                            width: 2, // Border width
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _wordsSpoken,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (_summary.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color.fromARGB(240, 44, 91, 91), // Border color
                            width: 2, // Border width
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Summary: $_summary',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (_reminders.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color.fromARGB(240, 44, 91, 91), // Border color
                            width: 2, // Border width
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Reminders:\n$_reminders',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                    SizedBox(height: 100), // To ensure FAB is visible
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: _speechToText.isListening ? 'Stop Listening' : 'Start Listening',
        child: Icon(
          _speechToText.isListening ? Icons.mic_off : Icons.mic,
          color: Color.fromARGB(179, 251, 236, 236),
        ),
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
      ),
    );
  }
}
