import 'package:scwar/config/game_config.dart';

class EntityInfo {
  double value;
  int size;
  EntityType type;
  EntityInfo(this.value, this.size, this.type);

  EntityInfo clone() {
    return EntityInfo(value, size, type);
  }

  setEnemy(double value, int size) {
    type = EntityType.enemy;
    this.value = value;
    this.size = size;
  }

  setEnergy(double value, EntityType type) {
    this.type = type;
    this.value = value;
    size = 1;
  }

  setEmpty() {
    value = 0;
    size = 0;
    type = EntityType.empty;
  }

  copyFrom(EntityInfo info) {
    value = info.value;
    size = info.size;
    type = info.type;
  }

  @override
  String toString() {
    if (type == EntityType.empty) {
      return 'empty';
    } else if (type == EntityType.enemy) {
      return 'em[$value($size)]';
    } else if (type == EntityType.energy) {
      return 'en[$value]';
    } else {
      return 'en2[$value]';
    }
  }
}
