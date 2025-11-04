import 'package:helloworld_hellolove/models/scene.dart';
import 'package:helloworld_hellolove/sets/characters.dart';

class SceneSets {
  final String name;
  final List<Scene> scenes;

  SceneSets({required this.name, required this.scenes});
}

List<SceneSets> getChapters() {
  return [
    SceneSets(
      name: 'Chapter1',
      scenes: [
        Scene(location: 'Courtyard (Sunset)', characterAtCenter: habaneAkari),
        Scene(location: 'Courtyard (Sunset)', charactersAtLeft: [habaneAkari]),
        Scene(location: 'Courtyard (Sunset)', charactersAtRight: [habaneAkari]),
      ],
    ),
    SceneSets(
      name: 'Chapter2',
      scenes: [
        Scene(location: 'Corridor2 (Night)', characterAtCenter: akagiKohaku),
        Scene(location: 'Corridor2 (Night)', charactersAtLeft: [akagiKohaku]),
        Scene(location: 'Corridor2 (Night)', charactersAtRight: [akagiKohaku]),
      ],
    ),
  ];
}
