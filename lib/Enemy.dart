import 'package:flutter/material.dart';

class Enemy {
  int strength;
  int vitality;
  int intellect;
  int row;
  int col;
  int health = 10;

  var enemyActionPoint = 8; // add health property

  Enemy({
    required this.strength,
    required this.vitality,
    required this.intellect,
    required this.row,
    required this.col,
  }) {
    // calculate health as vitality * 10
    this.health = this.vitality * 10;
  }
}
