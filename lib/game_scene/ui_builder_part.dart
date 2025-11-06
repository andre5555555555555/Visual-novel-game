part of 'scene.dart';

extension UiBuilderPart on Scene {
  Future<void> addUiElements() async {
    if (sceneElements == null) return;

    for (final TiledObject obj in sceneElements!.objects) {
      String spritePath = '';
      if (obj.name == 'exitButton') {
        spritePath = 'HUD/exitButton.png';
      } else if (obj.name == 'NewGameButton') {
        spritePath = 'HUD/newGameButton.png';
      }

      if (spritePath.isEmpty) {
        continue;
      }

      final buttonSprite = await Sprite.load(spritePath);

      final button = ButtonComponent(
        button: SpriteComponent(
          sprite: buttonSprite,
          size: Vector2(obj.width, obj.height),
        ),
        position: Vector2(obj.x, obj.y),
        size: Vector2(obj.width, obj.height),
        anchor: Anchor.topLeft,
        priority: 12,
        onPressed: () {
          handleButtonPress(obj.name);
        },
      );

      await add(button);
    }
  }

  void handleButtonPress(String buttonName) {
    switch (buttonName) {
      case 'exitButton':
        print("exit");
        game.goToHomeScreen();
        break;

      case 'NewGameButton':
        print('Starting a new game!');
        game.startNewGame();
        break;

      default:
        print('Button "$buttonName" pressed.');
    }
  }
}
