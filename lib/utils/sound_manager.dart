import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  late AudioPool pool;
  Future<void> load() async {
    await FlameAudio.audioCache.loadAll(['pepSound3.ogg', 'drop_002.mp3']);
    // pool = await FlameAudio.createPool('drop_002.mp3', maxPlayers: 5);
  }

  void playSnap() {}

  void playMerge() {
    FlameAudio.play('drop_002.mp3');
    // pool.start();
  }

  void playSwap() {
    FlameAudio.play('drop_002.mp3');
  }

  void playMove() {
    FlameAudio.play('drop_002.mp3');
  }

  void playShoot() {}
  void playHurt() {}

  void playPrepare() {}
}
