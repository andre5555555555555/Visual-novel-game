part of 'scene.dart';

extension SetSceneLogic on Scene {
  /// Clears old scene and loads new background and characters
  Future<void> _setScene(
    String locationName,
    List<CharacterData> characters,
  ) async {
    if (_backgroundComponent != null) remove(_backgroundComponent!);
    for (final charSprite in _characterSprites.values) {
      remove(charSprite);
    }
    _characterSprites.clear();

    final backgroundSprite = await Sprite.load('locations/$locationName.png');
    _backgroundComponent = SpriteComponent()
      ..sprite = backgroundSprite
      ..size = HelloworldHellolove.virtualResolution
      ..priority = -1;
    await add(_backgroundComponent!);

    await _addCharacters(characters);
  }

  Future<void> _addCharacters(List<CharacterData>? characters) async {
    if (characters != null) {
      double rightOffset = 0.0;
      double leftOffset = 0.0;

      for (final character in characters) {
        double xPosition = 0.0;
        double yPosition =
            HelloworldHellolove.virtualResolution.y - character.size.y;

        if (character.positionAt == PositionAt.center) {
          character.position = Vector2(
            HelloworldHellolove.virtualResolution.x / 2 +
                (character.facingAt == FacingAt.right
                    ? (character.size.x / 2)
                    : -(character.size.x / 2)),
            yPosition,
          );
        } else {
          if (character.facingAt == FacingAt.right) {
            xPosition = 800 + leftOffset;
            leftOffset += 400;
          } else {
            xPosition = 1120 - rightOffset;
            rightOffset += 400;
          }
          character.position = Vector2(xPosition, yPosition);
        }
        character.priority = 1;

        await add(character);
        _characterSprites[character.name] = character;
      }
    }
  }

  List<CharacterData> parseCharacters(String charStr) {
    final List<CharacterData> characters = [];
    // This RegExp finds "left(...)", "right(...)", or "center(...)"
    final RegExp positionRegex = RegExp(r'(left|right|center)\(([^)]+)\)');

    for (final match in positionRegex.allMatches(charStr)) {
      final String positionStr = match.group(
        1,
      )!; // "left", "right", or "center"
      final String namesStr = match.group(2)!; // "Habane, Akagi"
      // print(positionStr + ' -- ' + namesStr);

      final names = namesStr.split(',').map((e) => e.trim()).toList();
      // print(names);

      PositionAt pos;
      FacingAt face;

      // Set position and facing direction based on the command
      switch (positionStr) {
        case 'left':
          pos = PositionAt.left;
          face = FacingAt.right; // Characters on the left face right
          break;
        case 'right':
          pos = PositionAt.right;
          face = FacingAt.left; // Characters on the right face left
          break;
        case 'center':
        default:
          pos = PositionAt.center;
          face = FacingAt.right; // Default center facing
          break;
      }

      for (final name in names) {
        final String fullName = name;
        final CharacterData char = characterFactory(fullName);
        char.positionAt = pos;
        char.facingAt = face;
        char.greydOut(true);
        characters.add(char);
      }
    }
    return characters;
  }
}
