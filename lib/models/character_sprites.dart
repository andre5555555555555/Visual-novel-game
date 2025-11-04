import 'dart:async';

import 'package:flame/components.dart';

class CharacterSprites {
  late final List<String> states;
  late final String character;
  late final Vector2 size;
  final Map<String, Sprite> stateImages = {};

  CharacterSprites({
    required this.states,
    required this.character,
    required this.size,
  });

  Future<void> initialize() async {
    for (final state in states) {
      final spriteState = await Sprite.load('characters/$character/$state.png');
      stateImages[state] = spriteState;
    }
  }
}
