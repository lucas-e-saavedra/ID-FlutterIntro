import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:js/js.dart' as js;

class TokboxSessionPage extends StatefulWidget {
  const TokboxSessionPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TokboxSessionPage> createState() => _TokboxSessionPageState();
}

class _TokboxSessionPageState extends State<TokboxSessionPage> {
  String? _sessionId;
  String? _sessionToken;
  static const platform = MethodChannel('samples.flutter.dev/tokbox');

  Future<void> getSessionId() async {
    final url = Uri.parse(
        'https://test-simpsons-assistcard.herokuapp.com/videocall-session');
    http.Response response = await http.post(url);
    setState(() {
      _sessionId = response.statusCode == 200 ? response.body : null;
    });
  }

  Future<void> getSessionToken() async {
    final url = Uri.parse(
        'https://test-simpsons-assistcard.herokuapp.com/videocall-token');
    http.Response response = await http.get(url);
    setState(() {
      _sessionToken = response.statusCode == 200 ? response.body : null;
    });
  }

  void beginVideoCall() {
    try {
      var values = Map.from({
        "apiKey": "46256142",
        "sessionId": _sessionId,
        "sessionToken": _sessionToken
      });
      Platform.isFuchsia;
      platform.invokeMethod('beginVideoCall', values);
    } catch (e) {
      //js.context.callMethod('loadVideoCall', ['46256142', _sessionId, _sessionToken]);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? thirdWidget;
    if (_sessionId == null) {
      thirdWidget = OutlinedButton(
          onPressed: getSessionId, child: const Text("Obtener Session Id"));
    } else if (_sessionToken == null) {
      thirdWidget = OutlinedButton(
          onPressed: getSessionToken, child: const Text("Obtener Token"));
    } else {
      thirdWidget = OutlinedButton(
          onPressed: beginVideoCall,
          child: const Text("Comenzar Videollamada"));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('SessionId: ${_sessionId ?? ""}'),
        Text('SessionToken: ${_sessionToken ?? ""}'),
        thirdWidget
      ],
    );
  }
}
