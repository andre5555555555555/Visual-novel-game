import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:helloworld_hellolove/helloworld_hellolove.dart';
import 'package:helloworld_hellolove/models/character_sprites.dart';

/// Represents a visual novel scene — background, characters, and dialogue box
class Scene extends World
    with HasGameReference<HelloworldHellolove>, TapCallbacks, KeyboardHandler {
  final CharacterSprites? characterAtCenter;
  final List<CharacterSprites>? charactersAtLeft;
  final List<CharacterSprites>? charactersAtRight;
  final String location;
  final String dialogueText;

  Scene({
    this.characterAtCenter,
    this.charactersAtLeft,
    this.charactersAtRight,
    required this.location,
    required this.dialogueText,
  });

  // --- Internal state ---
  late final TextBoxComponent _textBox;
  bool inDialogue = true;
  double _timer = 0.0;
  int _charIndex = 0;
  static const double _textSpeed = 0.03;

  // --- UI Buttons ---
  late final List<ButtonComponent> _uiButtons = [];

  @override
  FutureOr<void> onLoad() async {
    await _loadBackground();
    await _addCharacters();
    await _addDialogueBox();
    await _addUIButtons();
  }

  // --- LOADERS ---
  Future<void> _loadBackground() async {
    try {
      final bgSprite = await Sprite.load('locations/$location.png');
      final bg = SpriteComponent()
        ..sprite = bgSprite
        ..size = HelloworldHellolove.virtualResolution;
      await add(bg);
    } catch (e) {
      if (kDebugMode) print("Error loading background for $location: $e");
    }
  }

  Future<void> _addCharacters() async {
    if (charactersAtLeft != null) {
      double offset = 200;
      for (final c in charactersAtLeft!) {
        final sprite = SpriteComponent(
          sprite: c.stateImages['default'],
          size: c.size,
          position: Vector2(
            offset,
            HelloworldHellolove.virtualResolution.y - c.size.y,
          ),
          priority: 1,
        );
        await add(sprite);
        offset += c.size.x * 0.8;
      }
    }

    if (charactersAtRight != null) {
      double offset = 200;
      for (final c in charactersAtRight!) {
        final sprite = SpriteComponent(
          sprite: c.stateImages['default'],
          size: c.size,
          position: Vector2(
            HelloworldHellolove.virtualResolution.x - c.size.x - offset,
            HelloworldHellolove.virtualResolution.y - c.size.y,
          ),
          priority: 1,
        );
        await add(sprite);
        offset += c.size.x * 0.8;
      }
    }

    if (characterAtCenter != null) {
      final c = characterAtCenter!;
      final sprite = SpriteComponent(
        sprite: c.stateImages['default'],
        size: c.size,
        position: Vector2(
          (HelloworldHellolove.virtualResolution.x / 2) - (c.size.x / 2),
          HelloworldHellolove.virtualResolution.y - c.size.y,
        ),
        priority: 2,
      );
      await add(sprite);
    }
  }

  // --- Dialogue ---
  Future<void> _addDialogueBox() async {
    final boxHeight = 280.0;
    final padding = 25.0;
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
      style: const TextStyle(fontSize: 30.0, color: Color(0xFFFFFFFF)),
    );

    _textBox = TextBoxComponent(
      text: "",
      textRenderer: textStyle,
      size: Vector2(boxSize.x - (padding * 2), boxSize.y - (padding * 2)),
      position: Vector2(padding, padding),
    );

    await dialogueBox.add(_textBox);
    await add(dialogueBox);
  }

  // --- UI Buttons (Auto, Skip, Save, Load, Logs, Settings) ---
  Future<void> _addUIButtons() async {
    final buttonNames = ['Logs', 'Setting'];

    final buttonWidth = 190.0;
    final buttonHeight = 50.0;
    final spacing = 15.0;
    final startX =
        HelloworldHellolove.virtualResolution.x -
        (buttonNames.length * (buttonWidth + spacing));
    const y = 40.0;

    for (int i = 0; i < buttonNames.length; i++) {
      final name = buttonNames[i];
      final sprite = await Sprite.load('HUD/${name.toLowerCase()}.png');

      final button = ButtonComponent(
        button: SpriteComponent(
          sprite: sprite,
          size: Vector2(buttonWidth, buttonHeight),
        ),
        position: Vector2(startX + (i * (buttonWidth + spacing)), y),
        anchor: Anchor.topLeft,
        onPressed: () => _handleUIButtonPress(name),
      );

      _uiButtons.add(button);
      await add(button);
    }
  }

  void _handleUIButtonPress(String name) {
    switch (name) {
      case 'Logs':
        print('Showing logs...');
        break;
      case 'Setting':
        print('Opening settings...');
        break;
    }
  }

  // --- Dialogue Control ---
  @override
  void update(double dt) {
    super.update(dt);
    if (_charIndex < dialogueText.length && inDialogue) {
      _timer += dt;
      if (_timer >= _textSpeed) {
        _timer = 0.0;
        _charIndex++;
        _textBox.text = dialogueText.substring(0, _charIndex);
      }
    }
  }

  void _skipDialogue() {
    if (inDialogue && _charIndex < dialogueText.length) {
      _charIndex = dialogueText.length;
      _textBox.text = dialogueText;
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
}
