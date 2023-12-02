import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

mixin Glowable on HasPaint {
  Color get color;
  BlurStyle get blurStyle;
  double get blurSigma => 10;
  int get blurFactor => 3;

  @override
  Future<void> onLoad() async {
    paint
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    for (var idx = 0; idx < blurFactor; idx++) {
      super.render(canvas);
    }
  }
}
