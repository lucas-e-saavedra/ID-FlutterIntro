import 'package:flutter/material.dart';
import 'apisimpsons.dart';

class CharacterDetailsPage extends StatefulWidget {
  const CharacterDetailsPage({Key? key, required this.charId})
      : super(key: key);
  final int charId;

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  late Future<Character> futureCharacter;

  @override
  void initState() {
    super.initState();
    futureCharacter = fetchOneCharacter(widget.charId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle"),
      ),
      body: Center(
          child: FutureBuilder<Character>(
        future: futureCharacter,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Image.network(snapshot.data?.photo ?? ""),
                        Text(snapshot.data?.name ?? ""),
                        Text(snapshot.data?.lastname ?? "")
                      ]),
                    ),
                  ),
                  Text("Edad: ${snapshot.data?.age}"),
                  Text("Ocupación: ${snapshot.data?.occupation}"),
                  Text("Intereses: ${snapshot.data?.likes}"),
                  Text("Bio: ${snapshot.data?.other}")
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//flutter run -d chrome --no-sound-null-safety --web-renderer=html
