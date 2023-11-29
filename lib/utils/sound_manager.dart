import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  late AudioPool hurtPool;
  Future<void> load() async {
    await FlameAudio.audioCache.loadAll([
      'drop_001.ogg',
      'drop_002.ogg',
      'drop_003.ogg',
      'drop_004.ogg',
      'laser5.ogg',
      'back_002.ogg',
      'powerUp9.ogg',
      'pepSound2.mp3',
      'pepSound3.ogg',
      'drop_002.mp3',
      // 'glass_001.ogg',
    ]);
    hurtPool = await FlameAudio.createPool(
      'glass_001.ogg',
      minPlayers: 3,
      maxPlayers: 5,
    );
  }

  void playSnap() {
    // FlameAudio.play('drop_003.ogg');
  }

  void playMerge() {
    FlameAudio.play('powerUp9.ogg');
    // pool.start();
  }

  void playSwap() {
    FlameAudio.play('pepSound2.mp3');
  }

  void playMove() {
    FlameAudio.play('drop_002.mp3');
  }

  void playShoot() {
    FlameAudio.play('laser5.ogg');
  }

  void playHurt() {
    // FlameAudio.play('bong_001.ogg');
    hurtPool.start();
    // FlameAudio.play('glass_001.ogg');
  }

  void playEnergy() {
    FlameAudio.play('drop_004.ogg');
  }

  void playPrepare() {}
}
