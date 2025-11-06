import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:helloworld_hellolove/helloworld_hellolove.dart';
import 'package:helloworld_hellolove/game_assets/characters.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';

part 'skip_or_advance_part.dart';
part 'set_scene_part.dart';
part 'dialogue_options_part.dart';
part 'ui_builder_part.dart';
part 'dialogue_box_part.dart';

class Scene extends World
    with HasGameReference<HelloworldHellolove>, TapCallbacks, KeyboardHandler {
  final String dialoguePath;
  final Map<String, CharacterData> _characterSprites = {};
  SpriteComponent? _backgroundComponent;

  late final ObjectGroup? sceneElements;
  final List<ButtonComponent> _decisionButtons = [];
  late final RectangleComponent _dialogueBox;
  late final TextBoxComponent _textBox;

  static const double _textSpeed = 0.03;
  // --- Scripting Properties ---
  late final List<String> _scriptLines = [];
  final Map<String, int> _scenePointLineIndex = {};
  int _currentLineIndex = 0;
  bool _isTyping = false;
  bool _isWaitingForDecision = false;
  String _fullText = '';
  double _timer = 0.0;
  int _charIndex = 0;
  String? _currentSpeaker;

  Scene(this.dialoguePath);

  @override
  FutureOr<void> onLoad() async {
    final fullScriptText = await rootBundle.loadString(dialoguePath);

    final tiledMap = await TiledComponent.load('sceneUI.tmx', Vector2.all(1.0));
    tiledMap.priority = 11;
    await add(tiledMap);

    sceneElements = tiledMap.tileMap.getLayer<ObjectGroup>('sceneElements');

    final rawLines = fullScriptText.split('\n');
    String multiLineBuffer = '';
    final RegExp scenePointRegex = RegExp(r'^SCENE{POINT:\s*([^\s,]+)\s*,');
    final RegExp pointRemover = RegExp(r'POINT:\s*[^\s,]+\s*,\s*');
    int currentScriptIndex = 0;

    for (final line in rawLines) {
      String trimmedLine = line.trim();

      if (multiLineBuffer.isNotEmpty) {
        multiLineBuffer += ' $trimmedLine';
        if (trimmedLine.endsWith('"')) {
          currentScriptIndex++;
          _scriptLines.add(multiLineBuffer);
          multiLineBuffer = '';
        }
      } else if (trimmedLine.startsWith('{') && trimmedLine.contains(':"')) {
        if (trimmedLine.endsWith('"')) {
          currentScriptIndex++;
          _scriptLines.add(trimmedLine);
        } else {
          multiLineBuffer = trimmedLine;
        }
      } else if (trimmedLine.startsWith('SCENE{')) {
        final sceneMatch = scenePointRegex.firstMatch(trimmedLine);
        if (sceneMatch != null) {
          final scenePoint = sceneMatch.group(1)!;
          _scenePointLineIndex[scenePoint] = currentScriptIndex;
          trimmedLine = line.replaceFirst(pointRemover, '');
          print(trimmedLine);
          print(_scenePointLineIndex);
        }
        currentScriptIndex++;
        _scriptLines.add(trimmedLine);
      } else if (trimmedLine.startsWith('DECISION{')) {
        currentScriptIndex++;
        _scriptLines.add(trimmedLine);
      } else if (trimmedLine.startsWith('JUMP{')) {
        currentScriptIndex++;
        _scriptLines.add(trimmedLine);
      }
    }
    print(_scenePointLineIndex);
    print('script lines' + _scriptLines.length.toString());
    for (var line in _scriptLines) {
      print(line);
    }

    await addUiElements();
    await addDialogueBox();

    // Start the script. The script will load the first background/characters
    await _advanceScript();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isTyping) {
      if (_charIndex < _fullText.length) {
        _timer += dt;
        if (_timer >= _textSpeed) {
          _timer = 0.0;
          _charIndex++;
          _textBox.text = _fullText.substring(0, _charIndex);
        }
      } else if (_charIndex >= _fullText.length) {
        _isTyping = false;
      }
    }
  }

  Future<void> _parseLine(String line) async {
    // --- Check for SCENE command ---
    if (await scene(line)) return;

    // --- Check for DECISION command ---
    if (await decision(line)) return;

    // --- Check for DIALOGUE command ---
    if (await dialogue(line)) return;

    // --- CHECK for JUMP COMMAND ---
    if (await jump(line)) return;

    // --- Handle other commands or errors ---
    if (kDebugMode) {
      print('WARNING: Unknown script line: $line');
    }

    await _advanceScript();
  }

  Future<bool> scene(String line) async {
    final RegExp sceneRegex = RegExp(
      r'^SCENE{LOCATION:\s*([^,]+),\s*CHARACTERS:\s*\[(.*)\]}$',
    );
    final sceneMatch = sceneRegex.firstMatch(line.trim());
    // print(sceneMatch);

    if (sceneMatch != null) {
      final String locationName = sceneMatch.group(1)!.trim();
      final String charactersString = sceneMatch.group(2)!.trim();
      // print(locationName + ' -- ' + charactersString);

      final List<CharacterData> characters = parseCharacters(charactersString);

      await _setScene(locationName, characters);

      await _advanceScript();
      return true;
    }
    return false;
  }

  Future<bool> decision(String line) async {
    final RegExp decisionRegex = RegExp(r'^DECISION\{(.*)\}$');
    final decisionMatch = decisionRegex.firstMatch(line.trim());

    if (decisionMatch != null) {
      final String optionsStr = decisionMatch.group(1)!; // "a:Yes, b:No, ..."
      final List<String> options = [];
      final List<String> scenes = [];

      // Parse the options
      final pairs = optionsStr.split(',');
      for (final pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          options.add(parts[1].trim()); // Add "Yes", "No", etc. to the list
          scenes.add(parts[0].trim());
        }
      }

      _showDecisions(options, scenes);
      return true;
    }
    return false;
  }

  Future<bool> dialogue(String line) async {
    final RegExp dialogueRegex = RegExp(r'^\{(.*)\}:\"([\s\S]*)\"$');
    final dialogueMatch = dialogueRegex.firstMatch(line.trim());

    if (dialogueMatch != null) {
      final String allCommandsStr = dialogueMatch.group(1)!;
      final String text = dialogueMatch.group(2)!;
      final commandList = allCommandsStr.split(',');
      print(allCommandsStr + ' --- ' + text);

      String speaker = '';
      String state = '';

      for (final cmdStr in commandList) {
        final parts = cmdStr.split(':');
        if (parts.length == 2) {
          final command = parts[0].trim().toUpperCase();
          final value = parts[1].trim();

          if (command == 'SAY') {
            speaker = value;
          } else if (command == 'STATE') {
            state = value;
          }
        }
      }

      if (speaker.isNotEmpty) {
        if (state.isNotEmpty) {
          _handleState(speaker, state);
        }
        if (_characterSprites.containsKey(_currentSpeaker)) {
          _characterSprites[_currentSpeaker]!.greydOut(true);
        }
        _startTyping(speaker, text);
      } else {
        if (kDebugMode) {
          print('WARNING: Dialogue line has no SAY command: $line');
        }
        await _advanceScript();
      }
      return true;
    }
    return false;
  }

  Future<bool> jump(String line) async {
    final RegExp jumpRegex = RegExp(r'JUMP\{\s*([^\s\}]+)\s*\}');
    final jumpMatch = jumpRegex.firstMatch(line.trim());
    if (jumpMatch != null) {
      final String scene = jumpMatch.group(1)!.trim();
      _currentLineIndex = _scenePointLineIndex[scene]!;
      return true;
    }
    return false;
  }

  void _handleState(String charName, String stateName) {
    // if (kDebugMode) {
    //   print('SCRIPT: Character $charName changes to $stateName');
    // }

    final charComponent = _characterSprites[charName];
    if (charComponent != null) {
      charComponent.setState(stateName);
    } else {
      if (kDebugMode) {
        print('ERROR: Sprite for $charName not found on screen');
      }
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      _skipOrAdvance();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _skipOrAdvance();
    super.onTapDown(event);
  }
}
