import 'package:audioplayers/audioplayers.dart';

class SoundPool {
  final List<AudioPlayer> _pool = [];
  AudioPlayer _createPlayer() {
    return AudioPlayer();
  }

  void play(String assetPath) {
    // 查找空闲的音效实例
    AudioPlayer player =
        _pool.firstWhere((p) => p.state == PlayerState.completed, orElse: () {
      // 如果没有空闲的音效实例，则创建一个新的
      AudioPlayer newPlayer = _createPlayer();
      _pool.add(newPlayer);
      return newPlayer;
    });
    // 播放音效
    player.play(AssetSource('audio/$assetPath'));
  }

  void dispose() {
    // 释放所有音效实例
    for (AudioPlayer player in _pool) {
      player.dispose();
    }
  }
}

class SoundManager {
  bool soundOn = true;
  // late AudioPool hurtPool;
  final player = SoundPool();
  // final hurtPlayer = SoundPool();
  Future<void> load() async {
    // await FlameAudio.audioCache.loadAll([
    //   'click.mp3',
    //   'move.mp3',
    //   'energy.mp3',
    //   'hurt.mp3',
    //   'shoot.mp3',
    //   'dead.mp3',
    //   'merge.mp3',
    // ]);
    // hurtPool = await FlameAudio.createPool(
    //   'glass_001.ogg',
    //   minPlayers: 3,
    //   maxPlayers: 5,
    // );
  }

  void _play(String source) {
    // FlameAudio.play(source);
    player.play(source);
  }

  void playCick() {
    if (!soundOn) return;
    _play('click.mp3');
  }

  void playSnap() {
    if (!soundOn) return;
    // _play('drop_003.ogg');
  }

  void playMerge() {
    if (!soundOn) return;
    _play('merge.mp3');
    // pool.start();
  }

  void playSwap() {
    if (!soundOn) return;
    _play('move.mp3');
  }

  void playMove() {
    if (!soundOn) return;
    _play('move.mp3');
  }

  void playShoot() {
    if (!soundOn) return;
    _play('shoot.mp3');
  }

  void playHurt() {
    if (!soundOn) return;
    // hurtPlayer.play('hurt.mp3');
    _play('hurt.mp3');
  }

  void playEnergy() {
    if (!soundOn) return;
    _play('energy.mp3');
  }

  void playDead() {
    if (!soundOn) return;
    _play('dead.mp3');
  }

  void playWin() {
    if (!soundOn) return;
    _play('energy.mp3');
  }

  void playPrepare() {}
}
