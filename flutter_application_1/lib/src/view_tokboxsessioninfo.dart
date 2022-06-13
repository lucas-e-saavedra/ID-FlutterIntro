import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const platform = MethodChannel('samples.flutter.dev/tokbox');

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
    //var apiKey = "46256142";
    //var apiSecret = "e34ceb15c0eca4af5bfc5e1b75f374dc913ab744";
    try {
      var values = Map.from({
        "apiKey": "46256142",
        "sessionId": _sessionId,
        "sessionToken": _sessionToken
      });
      platform.invokeMethod('beginVideoCall', values);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  //I/flutter (16945): BeginVideoCall 46256142
  //I/flutter (16945): 1_MX40NjI1NjE0Mn5-MTY1NTE0NTY4MzcyMX5YNnQxSFdLVFFPUmhMTjRBWnJQbzFQQXV-QX4
  //I/flutter (16945): T1==cGFydG5lcl9pZD00NjI1NjE0MiZzaWc9MTU5MWZhOWYxZDU4NWE3MWU1OWMyY2UzNDJkZTBiZWQyY2U0YjNkNTpzZXNzaW9uX2lkPTFfTVg0ME5qSTFOakUwTW41LU1UWTFOVEUwTlRZNE16Y3lNWDVZTm5ReFNGZExWRkZQVW1oTVRqUkJXbkpRYnpGUVFYVi1RWDQmY3JlYXRlX3RpbWU9MTY1NTE0NjQwNSZub25jZT0wLjc1NTUwMjc1MzE1MzMwMjUmcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTY1NTIzMjgwNSZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ==

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
