import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:helloworld_hellolove/helloworld_hellolove.dart';
import 'package:helloworld_hellolove/models/character_sprites.dart';

class Scene extends World
    with HasGameReference<HelloworldHellolove>, TapCallbacks, KeyboardHandler {
  final CharacterSprites? characterAtCenter;
  final List<CharacterSprites>? charactersAtLeft;
  final List<CharacterSprites>? charactersAtRight;
  final String location;
  bool inDialogue = true;

  late final TextBoxComponent _textBox;
  final String _fullText =
      "This is the dialogue. It will wrap automatically if the text is too long to fit on one line fdassssssssssssssssdfgsdgsdfghsdhdfghdfghdfghdfghfdhg.";

  double _timer = 0.0;
  int _charIndex = 0;
  static const double _textSpeed = 0.03;

  Scene({
    this.charactersAtLeft,
    this.charactersAtRight,
    this.characterAtCenter,
    required this.location,
  });

  @override
  FutureOr<void> onLoad() async {
    final backgroundSprite = await Sprite.load('locations/$location.png');
    final backgroundComponent = SpriteComponent()
      ..sprite = backgroundSprite
      ..size = HelloworldHellolove.virtualResolution;
    await add(backgroundComponent);

    final tiledMap = await TiledComponent.load('sceneUI.tmx', Vector2.all(1.0));

    add(tiledMap);
    final objectLayer = tiledMap.tileMap.getLayer<ObjectGroup>('SceneUI');

    if (objectLayer != null) {
      for (final TiledObject obj in objectLayer.objects) {
        final buttonSprite = await Sprite.load('HUD/exitButton.png');

        final button = ButtonComponent(
          button: SpriteComponent(
            sprite: buttonSprite,
            size: Vector2(obj.width, obj.height),
          ),
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height),
          anchor: Anchor.bottomLeft,

          onPressed: () {
            _handleButtonPress(obj.name);
          },
        );

        await add(button);
      }
    } else {
      if (kDebugMode) {
        print('ERROR: Could not find object layer');
      }
    }

    _addCharacters(characters: charactersAtLeft);
    _addCharacters(characters: charactersAtRight, isFacingLeft: false);
    _addCharacters(character: characterAtCenter);

    _addDialogueBox();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_charIndex < _fullText.length) {
      _timer += dt;

      if (_timer >= _textSpeed) {
        _timer = 0.0;

        _charIndex++;
        _textBox.text = _fullText.substring(0, _charIndex);
      }
      if (_charIndex >= _fullText.length) {
        inDialogue = false;

        game.goToNextScene();
      }
    }
  }

  void _skipDialogue() {
    if (_charIndex < _fullText.length && inDialogue) {
      _charIndex = _fullText.length;
      _textBox.text = _fullText;
      inDialogue = false;
    } else {
      game.goToNextScene();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _skipDialogue();
    super.onTapDown(event);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      _skipDialogue();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  // Helper functions
  Future<void> _addDialogueBox() async {
    final boxHeight = 300.0;
    final boxSize = Vector2(HelloworldHellolove.virtualResolution.x, boxHeight);
    final boxPaint = Paint()..color = const Color(0xAA000000);

    final dialogueBox = RectangleComponent(
      size: boxSize,
      position: Vector2(0, HelloworldHellolove.virtualResolution.y),
      anchor: Anchor.bottomLeft,
      paint: boxPaint,
      priority: 10,
    );

    final textStyle = TextPaint(
      style: const TextStyle(fontSize: 32.0, color: Color(0xFFFFFFFF)),
    );

    const padding = 20.0;

    _textBox = TextBoxComponent(
      text: "",
      textRenderer: textStyle,
      size: Vector2(boxSize.x - (padding * 2), boxSize.y - (padding * 2)),
      position: Vector2(padding, padding),
    );

    await dialogueBox.add(_textBox);
    await add(dialogueBox);
  }

  Future<void> _addCharacters({
    List<CharacterSprites>? characters,
    CharacterSprites? character,
    bool isFacingLeft = true,
  }) async {
    if (characters != null) {
      double offset = 0.0;

      for (final character in characters) {
        double yPosition =
            HelloworldHellolove.virtualResolution.y - character.size.y;
        final sprite = SpriteComponent(
          sprite: character.stateImages['default'],
          size: character.size,
          position: Vector2(
            isFacingLeft ? (800 + offset) : (1120 - offset),
            yPosition,
          ),
          priority: 1,
        );
        offset += 500;
        sprite.scale.x = isFacingLeft ? -1 : 1;
        await add(sprite);
      }
    }

    if (character != null) {
      double yPosition =
          HelloworldHellolove.virtualResolution.y - character.size.y;
      final sprite = SpriteComponent(
        sprite: character.stateImages['default'],
        size: character.size,
        priority: 1,
      );
      sprite.scale.x = -1;
      sprite.position = Vector2(
        HelloworldHellolove.virtualResolution.x / 2 +
            (sprite.scale.x < 0
                ? (character.size.x / 2)
                : -(character.size.x / 2)),
        yPosition,
      );
      await add(sprite);
    }
  }

  void _handleButtonPress(String buttonName) {
    switch (buttonName) {
      case 'exitButton':
        print("exit");
        game.goToHomeScreen();
      default:
        print('Button "$buttonName" pressed.');
    }
  }
}
