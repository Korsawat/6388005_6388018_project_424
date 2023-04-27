import 'package:flutter/material.dart';

class Cell {
  final int row;
  final int col;
  bool isValidMove;

  Cell({
    required this.row,
    required this.col,
    this.isValidMove = false,
  });
}
