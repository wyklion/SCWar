import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  late AudioPool hurtPool;
  Future<void> load() async {
    await FlameAudio.audioCache.loadAll([
      'bong_001.ogg',
      'drop_002.mp3',
      'drop_004.ogg',
      'glass_001.ogg',
      'laser5.ogg',
      // 'back_002.ogg',
      'powerUp9.ogg',
      'pepSound2.ogg',
      // 'pepSound3.ogg',
    ]);
    // hurtPool = await FlameAudio.createPool(
    //   'glass_001.ogg',
    //   minPlayers: 3,
    //   maxPlayers: 5,
    // );
  }

  void playCick() {
    FlameAudio.play('bong_001.ogg');
    // FlameAudio.play('drop_003.ogg');
  }

  void playSnap() {
    // FlameAudio.play('drop_003.ogg');
  }

  void playMerge() {
    FlameAudio.play('powerUp9.ogg');
    // pool.start();
  }

  void playSwap() {
    FlameAudio.play('pepSound2.ogg');
  }

  void playMove() {
    FlameAudio.play('drop_002.mp3');
  }

  void playShoot() {
    FlameAudio.play('laser5.ogg');
  }

  void playHurt() {
    // hurtPool.start();
    FlameAudio.play('glass_001.ogg');
  }

  void playEnergy() {
    FlameAudio.play('drop_004.ogg');
  }

  void playPrepare() {}
}
