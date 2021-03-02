import 'package:flutter/material.dart';

class MyCard {
  String name;
  double positionY;
  MaterialColor color;

  MyCard(double positionY, MaterialColor color, String name) {
    this.positionY = positionY;
    this.color = color;
    this.name = name;
  }

  @override
  String toString() {
    return 'MyCard{name: $name, position: $positionY}';
  }
}
