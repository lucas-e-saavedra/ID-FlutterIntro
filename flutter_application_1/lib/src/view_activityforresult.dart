import 'package:flutter/material.dart';

class ActivityForResult extends StatefulWidget {
  const ActivityForResult({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ActivityForResult> createState() => _ActivityForResultState();
}

class _ActivityForResultState extends State<ActivityForResult> {
  final TextEditingController _textController = TextEditingController();

  void _okTapped() {
    Navigator.of(context).pop(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
              'Lo que escribas aqui, lo devolveremos a quien llamó a esta pantalla'),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Ejemplo'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _okTapped, child: const Icon(Icons.confirmation_num)),
    );
  }
}
