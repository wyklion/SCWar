import 'package:scwar/game/game_manager.dart';

class IdleState {
  double value = 0;
  int _state = 0;
  double _delay = 0;
  double idleTime;
  double minDelay;
  double maxDelay;
  GameManager gameManager;
  IdleState(this.gameManager,
      {required this.idleTime, this.minDelay = 0, required this.maxDelay}) {
    nextIdle();
  }

  nextIdle() {
    value = 0;
    _state = 0;
    _delay = minDelay + gameManager.random.nextDouble() * maxDelay;
  }

  update(double dt) {
    if (_state == 1) {
      value += dt;
      if (value >= idleTime) {
        value = idleTime;
        _state = -1;
      }
    } else if (_state == -1) {
      value -= dt;
      if (value <= 0) {
        value = 0;
        _state = 0;
        nextIdle();
      }
    } else if (_state == 0) {
      _delay -= dt;
      if (_delay <= 0) {
        _state = 1;
      }
    }
  }
}
