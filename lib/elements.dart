import 'package:flutter/material.dart';

class element {
  final int row;
  final int col;
  bool isValidMove;

  element({
    required this.row,
    required this.col,
    this.isValidMove = false,
  });
}
