import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  bool soundOn = true;
  late AudioPool hurtPool;
  Future<void> load() async {
    await FlameAudio.audioCache.loadAll([
      'click.ogg',
      'move.mp3',
      'energy.ogg',
      'hurt.ogg',
      'shoot.ogg',
      'dead.ogg',
      'merge.ogg',
      // 'pepSound2.ogg',
      // 'pepSound3.ogg',
    ]);
    // hurtPool = await FlameAudio.createPool(
    //   'glass_001.ogg',
    //   minPlayers: 3,
    //   maxPlayers: 5,
    // );
  }

  void playCick() {
    if (!soundOn) return;
    FlameAudio.play('click.ogg');
    // FlameAudio.play('drop_003.ogg');
  }

  void playSnap() {
    if (!soundOn) return;
    // FlameAudio.play('drop_003.ogg');
  }

  void playMerge() {
    if (!soundOn) return;
    FlameAudio.play('merge.ogg');
    // pool.start();
  }

  void playSwap() {
    if (!soundOn) return;
    FlameAudio.play('move.ogg');
  }

  void playMove() {
    if (!soundOn) return;
    FlameAudio.play('move.mp3');
  }

  void playShoot() {
    if (!soundOn) return;
    FlameAudio.play('shoot.ogg');
  }

  void playHurt() {
    if (!soundOn) return;
    // hurtPool.start();
    FlameAudio.play('hurt.ogg');
  }

  void playEnergy() {
    if (!soundOn) return;
    FlameAudio.play('energy.ogg');
  }

  void playDead() {
    if (!soundOn) return;
    FlameAudio.play('dead.ogg');
  }

  void playWin() {
    if (!soundOn) return;
    FlameAudio.play('energy.ogg');
  }

  void playPrepare() {}
}
