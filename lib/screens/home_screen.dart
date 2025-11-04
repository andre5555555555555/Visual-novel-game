import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:helloworld_hellolove/helloworld_hellolove.dart';
import 'package:helloworld_hellolove/sets/characters.dart';

class HomeScreen extends World with HasGameReference<HelloworldHellolove> {
  @override
  FutureOr<void> onLoad() async {
    final backgroundSprite = await Sprite.load(
      'locations/Courtyard (Sunset).png',
    );
    final backgroundComponent = SpriteComponent()
      ..sprite = backgroundSprite
      ..size = HelloworldHellolove.virtualResolution;
    await add(backgroundComponent);

    final tiledMap = await TiledComponent.load(
      'homeScreen.tmx',
      Vector2.all(1.0),
    );
    add(tiledMap);

    // --- Button Loading ---
    final objectLayer = tiledMap.tileMap.getLayer<ObjectGroup>(
      'HomeScreenButtons',
    );

    if (objectLayer != null) {
      for (final TiledObject obj in objectLayer.objects) {
        final buttonSprite = await Sprite.load('HUD/newGameButton.png');

        final button = ButtonComponent(
          button: SpriteComponent(
            sprite: buttonSprite,
            size: Vector2(obj.width, obj.height),
          ),
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height),
          anchor: Anchor.bottomLeft,

          // --- UPDATED onPressed ---
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

    // --- Character loading (no change) ---
    final akagi = SpriteComponent(
      sprite: akagiKohaku.stateImages['default'],
      size: akagiKohaku.size,
      position: Vector2(
        1400,
        HelloworldHellolove.virtualResolution.y - akagiKohaku.size.y,
      ),
      priority: 1,
      scale: Vector2(-1, 1),
    );
    await add(akagi);

    // ... (rest of your character loading) ...
    final habane = SpriteComponent(
      sprite: habaneAkari.stateImages['default'],
      size: habaneAkari.size,
      position: Vector2(
        1100,
        HelloworldHellolove.virtualResolution.y - habaneAkari.size.y,
      ),
      priority: 2,
      scale: Vector2(-1, 1),
    );
    await add(habane);

    final hotaru = SpriteComponent(
      sprite: hotaruYuna.stateImages['default'],
      size: hotaruYuna.size,
      position: Vector2(
        -30,
        HelloworldHellolove.virtualResolution.y - hotaruYuna.size.y,
      ),
      priority: 1,
      scale: Vector2(1, 1),
    );
    await add(hotaru);
  }

  void _handleButtonPress(String buttonName) {
    switch (buttonName) {
      case 'NewGameButton':
        print('Starting a new game!');

        // --- UPDATED: Call the method on the game ---
        game.startNewGame();

        break;
      case 'LoadGameButton':
        print('Loading a saved game!');
        break;
      case 'SettingsButton':
        print('Opening settings!');
        break;
      default:
        print('Button "$buttonName" pressed.');
    }
  }
}
