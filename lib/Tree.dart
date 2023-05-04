import 'package:flutter/material.dart';

import 'elements.dart';

class Tree extends element {
  Tree({
    required int row,
    required int col,
    bool isValidMove = false,
  }) : super(row: row, col: col, isValidMove: isValidMove);
}
