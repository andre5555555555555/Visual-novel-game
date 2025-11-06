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
    // --- Background ---
    final backgroundSprite = await Sprite.load('HUD/bg.png');
    final backgroundComponent = SpriteComponent()
      ..sprite = backgroundSprite
      ..size = HelloworldHellolove.virtualResolution;
    await add(backgroundComponent);

    // --- Optional: load tiled map (not required for menu layout) ---
    try {
      final tiledMap = await TiledComponent.load(
        'homeScreen.tmx',
        Vector2.all(1.0),
      );
      add(tiledMap);
    } catch (e) {
      if (kDebugMode) {
        print('Tiled map not found or not used: $e');
      }
    }

    // --- Logo and Button Layout ---
    final logoSprite = await Sprite.load('HUD/logo.png');
    final logoSize = Vector2(500, 500);

    // Define buttons
    final buttonNames = [
      'NewGameButton',
      'LoadGameButton',
      'GalleryButton',
      'SettingsButton',
      'ExitButton',
    ];

    // Button layout values
    final buttonWidth = 400.0;
    final buttonHeight = 100.0;
    final buttonSpacing = 10.0;

    // Compute total height for group (logo + buttons)
    final totalHeight =
        logoSize.y +
        10 +
        buttonNames.length * (buttonHeight + buttonSpacing) -
        buttonSpacing;

    final screenSize = HelloworldHellolove.virtualResolution;

    // Move UI group toward right side
    final rightMargin = 150.0; // adjust this to move further left/right
    final startX = screenSize.x - rightMargin - buttonWidth;
    final startY = (screenSize.y / 2) - (totalHeight / 2);

    // --- Add logo ---
    final logo = SpriteComponent(
      sprite: logoSprite,
      size: logoSize,
      position: Vector2(startX + (buttonWidth / 2) - (logoSize.x / 2), startY),
      anchor: Anchor.topLeft,
    );
    await add(logo);

    // --- Add buttons ---
    var currentY = startY + logoSize.y - 50;

    for (final name in buttonNames) {
      final imagePath = _getButtonImage(name);
      if (imagePath == null) continue;

      final buttonSprite = await Sprite.load(imagePath);

      final button = ButtonComponent(
        button: SpriteComponent(
          sprite: buttonSprite,
          size: Vector2(buttonWidth, buttonHeight),
        ),
        position: Vector2(startX, currentY),
        anchor: Anchor.topLeft,
        onPressed: () => _handleButtonPress(name),
      );

      await add(button);
      currentY += buttonHeight + buttonSpacing;
    }

    // --- Characters on screen (for background scene flavor) ---
    final akagi = SpriteComponent(
      sprite: akagiKohaku.stateImages['default'],
      size: akagiKohaku.size,
      position: Vector2(
        1300,
        HelloworldHellolove.virtualResolution.y - akagiKohaku.size.y,
      ),
      priority: 1,
      scale: Vector2(-1, 1),
    );
    await add(akagi);

    final habane = SpriteComponent(
      sprite: habaneAkari.stateImages['default'],
      size: habaneAkari.size,
      position: Vector2(
        1030,
        HelloworldHellolove.virtualResolution.y - habaneAkari.size.y,
      ),
      priority: 2,
      scale: Vector2(-1, 1),
    );
    await add(habane);

    final hotaru = SpriteComponent(
      sprite: hotaruYuna.stateImages['koi'],
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

  // --- Maps button names to images ---
  String? _getButtonImage(String name) {
    switch (name) {
      case 'NewGameButton':
        return 'HUD/NewGame.png';
      case 'LoadGameButton':
        return 'HUD/LoadGame.png';
      case 'GalleryButton':
        return 'HUD/Gallery.png';
      case 'SettingsButton':
        return 'HUD/Settings.png';
      case 'ExitButton':
        return 'HUD/Exit.png';
      default:
        return null;
    }
  }

  // --- Handles button presses ---
  void _handleButtonPress(String buttonName) {
    switch (buttonName) {
      case 'NewGameButton':
        print('Starting a new game!');
        game.startNewGame();
        break;
      case 'LoadGameButton':
        print('Loading a saved game!');
        break;
      case 'GalleryButton':
        print('Opening gallery!');
        break;
      case 'SettingsButton':
        print('Opening settings!');
        break;
      case 'ExitButton':
        print('Exiting game...');
        // Optionally use exit(0) on desktop
        break;
      default:
        print('Button "$buttonName" pressed.');
    }
  }
}
