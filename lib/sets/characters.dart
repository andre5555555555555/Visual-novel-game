import 'package:flame/image_composition.dart';
import 'package:helloworld_hellolove/models/character_sprites.dart';

Future<void> setCharacters() async {
  await akagiKohaku.initialize();
  await habaneAkari.initialize();
  await hotaruYuna.initialize();
}

CharacterSprites akagiKohaku = CharacterSprites(
  states: [
    'blushing',
    'concerned',
    'crying',
    'default',
    'disappointed',
    'mad',
    'smile',
    'smug',
  ],
  character: 'Akagi Kohaku',
  size: Vector2.all(950),
);

CharacterSprites habaneAkari = CharacterSprites(
  states: [
    'concerned',
    'crying1',
    'crying2',
    'crying3',
    'default',
    'disappointed',
    'mad1',
    'mad2',
    'sad',
    'shocked',
    'smug',
    'tsundere',
  ],
  character: 'Habane Akari',
  size: Vector2.all(850),
);

CharacterSprites hotaruYuna = CharacterSprites(
  states: [
    'blushing',
    'shock',
    'crying',
    'default',
    'mad',
    'sad',
    'smug',
    'flustered',
    'koi',
  ],
  character: 'Hotaru Yuna',
  size: Vector2.all(800),
);
