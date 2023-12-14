import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/text.dart';

class BoundedTextComponent<T extends TextRenderer> extends TextComponent<T> {
  Vector2 maxSize;
  BoundedTextComponent({
    String? text,
    T? textRenderer,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
    required this.maxSize,
  });

  @override
  void updateBounds() {
    // ignore: invalid_use_of_internal_member
    super.updateBounds();
    var x = maxSize.x / size.x;
    var y = maxSize.y / size.y;
    scale.setAll(min(x, y));
  }
}
