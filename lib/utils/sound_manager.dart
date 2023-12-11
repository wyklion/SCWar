import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

class SoundManager {
  bool soundOn = true;
  late AudioPool hurtPool;
  Future<void> load() async {
    await FlameAudio.audioCache.loadAll([
      'click.mp3',
      'move.mp3',
      'energy.mp3',
      'hurt.mp3',
      'shoot.mp3',
      'dead.mp3',
      'merge.mp3',
    ]);
    // hurtPool = await FlameAudio.createPool(
    //   'glass_001.ogg',
    //   minPlayers: 3,
    //   maxPlayers: 5,
    // );
    if (kIsWeb) {
      soundOn = false;
    }
  }

  void playCick() {
    if (!soundOn) return;
    FlameAudio.play('click.mp3');
    // FlameAudio.play('drop_003.ogg');
  }

  void playSnap() {
    if (!soundOn) return;
    // FlameAudio.play('drop_003.ogg');
  }

  void playMerge() {
    if (!soundOn) return;
    FlameAudio.play('merge.mp3');
    // pool.start();
  }

  void playSwap() {
    if (!soundOn) return;
    FlameAudio.play('move.mp3');
  }

  void playMove() {
    if (!soundOn) return;
    FlameAudio.play('move.mp3');
  }

  void playShoot() {
    if (!soundOn) return;
    FlameAudio.play('shoot.mp3');
  }

  void playHurt() {
    if (!soundOn) return;
    // hurtPool.start();
    FlameAudio.play('hurt.mp3');
  }

  void playEnergy() {
    if (!soundOn) return;
    FlameAudio.play('energy.mp3');
  }

  void playDead() {
    if (!soundOn) return;
    FlameAudio.play('dead.mp3');
  }

  void playWin() {
    if (!soundOn) return;
    FlameAudio.play('energy.mp3');
  }

  void playPrepare() {}
}
