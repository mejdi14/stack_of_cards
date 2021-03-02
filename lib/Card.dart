import 'package:flutter/material.dart';

class MyCard {
  double positionY;
  MaterialColor color;

  MyCard(double positionY, MaterialColor color) {
    this.positionY = positionY;
    this.color = color;
  }

  @override
  String toString() {
    return 'MyCard{positionY: $positionY, color: $color}';
  }
}
