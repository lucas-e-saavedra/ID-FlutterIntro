import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TokboxSessionPage extends StatefulWidget {
  const TokboxSessionPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TokboxSessionPage> createState() => _TokboxSessionPageState();
}

class _TokboxSessionPageState extends State<TokboxSessionPage> {
  String? _sessionId;
  String? _sessionToken;

  Future<void> getSessionId() async {
    final url = Uri.parse(
        'http://test-simpsons-assistcard.herokuapp.com/videocall-session');
    http.Response response = await http.post(url);
    setState(() {
      _sessionId = response.statusCode == 200 ? response.body : null;
    });
  }

  Future<void> getSessionToken() async {
    final url = Uri.parse(
        'http://test-simpsons-assistcard.herokuapp.com/videocall-token');
    http.Response response = await http.get(url);
    setState(() {
      _sessionToken = response.statusCode == 200 ? response.body : null;
    });
  }

  void beginVideoCall() {
    /*final route = MaterialPageRoute(
        builder: (BuildContext context) =>
            CharacterDetailsPage(charId: charId));
    Navigator.of(context).push(route);*/
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
