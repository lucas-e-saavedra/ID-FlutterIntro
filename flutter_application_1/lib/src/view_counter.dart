import 'package:flutter/material.dart';
import 'widget_codelab.dart';
import 'view_activityforresult.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void _showAlert() {
    var okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(primary: Colors.green),
        child: const Text("Aceptar"));
    var cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(primary: Colors.redAccent),
        child: const Text("Cancelar"));
    var alert = AlertDialog(
      title: const Text("Titulo"),
      actions: [okButton, cancelButton],
      content: const Text("Aqui va el contenido del alert"),
      contentPadding: const EdgeInsets.all(32.0),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(AppLocalizations.of(context)!.helloWorld),
        const Text('You have pushed the button this many times:'),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline4,
        ),
        OutlinedButton(
            onPressed: _incrementCounter, child: const Text("Increment")),
        OutlinedButton(
            onPressed: _startActivityForResult, child: Text(_textExample)),
        OutlinedButton(onPressed: _showAlert, child: const Text("Alert")),
        const MyFirstWidget()
      ],
    );
  }
}
