import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Character>> fetchAllCharacters() async {
  final response = await http.get(
      Uri.parse('https://test-simpsons-assistcard.herokuapp.com/characters'));

  if (response.statusCode == 200) {
    var rawBody = jsonDecode(response.body);
    var responseBody = rawBody['data'];
    var listOfCharacters = List<Character>.empty(growable: true);
    for (var oneChar in responseBody) {
      var objChar = Character.fromJson(oneChar);
      listOfCharacters.add(objChar);
    }
/*    var l = json.decode(source) as Iterable;
    var failures = List<UnitTest>.from(l.map<UnitTest>(
        (dynamic i) => UnitTest.fromJson(i as Map<String, dynamic>)));
*/
    return listOfCharacters;
  } else {
    throw Exception('Failed to load characters');
  }
}

Future<Character> fetchOneCharacter(int idCharacter) async {
  final response = await http.get(Uri.parse(
      'https://test-simpsons-assistcard.herokuapp.com/characters?id=$idCharacter'));

  if (response.statusCode == 200) {
    return Character.fromJson(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Failed to load character with id $idCharacter');
  }
}

class Character {
  int id = 0;
  String? name;
  String? lastname;
  int? age;
  String? occupation;
  String? likes;
  String? photo;
  String? other;

  Character(
      {required this.id,
      required this.name,
      required this.lastname,
      this.age,
      this.occupation,
      this.likes,
      this.photo,
      this.other});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        id: json['id'],
        name: json['name'],
        lastname: json['lastname'],
        age: json['age'],
        occupation: json['occupation'],
        likes: json['likes'],
        photo: json['photo'],
        other: json['other']);
  }
}
