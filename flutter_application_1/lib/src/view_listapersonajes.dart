import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/view_detallepersonaje.dart';
import 'apisimpsons.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  late Future<List<Character>> futureCharacters;

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<Character>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var cantidad = snapshot.data!.length * 5;
            return ListView.builder(
              itemCount: cantidad,
              itemBuilder: (context, index) {
                //return ItemCharacter(snapshot.data![index]);
                return ListTile(
                  title: Text(snapshot.data![index % 5].name!),
                  subtitle: Text(snapshot.data![index % 5].lastname!),
                  leading: Icon(Icons.account_circle_rounded),
                  onTap: () {
                    print("Selected Item ID:${snapshot.data?[index % 5].id}");
                    final charId = snapshot.data?[index % 5].id ?? 0;
                    final route = MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CharacterDetailsPage(charId: charId));
                    Navigator.of(context).push(route);
                  },
                  onLongPress: () {
                    print("Delete Item ID:${snapshot.data?[index % 5].id}");
                  },
                );
              },
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
