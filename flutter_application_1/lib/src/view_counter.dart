import 'package:flutter/material.dart';
import 'widget_codelab.dart';
import 'view_activityforresult.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  String _textExample = "Ejemplo";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _startActivityForResult() async {
    var route = MaterialPageRoute(
        builder: (BuildContext context) =>
            const ActivityForResult(title: "ActivityForResult"));

    var result = await Navigator.of(context).push(route);
    print(result);
    if (result != null && result.isNotEmpty) {
      setState(() {
        _textExample = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text('You have pushed the button this many times:'),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline4,
        ),
        OutlinedButton(
            onPressed: _incrementCounter, child: const Text("Increment")),
        OutlinedButton(
            onPressed: _startActivityForResult, child: Text(_textExample)),
        const MyFirstWidget()
      ],
    );
  }
}
