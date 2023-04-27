import 'package:flutter/material.dart';

import 'Cell.dart';
import 'Enemy.dart';

class Player {
  int strength;
  int vitality;
  int intellect;
  int row;
  int col;
  int health = 10;
  int actionpoint = 4;
  bool turn = true;
  Player(
      {required this.strength,
      required this.vitality,
      required this.intellect,
      required this.row,
      required this.col,
      required this.turn}) {
    // calculate health as vitality * 10
    this.health = this.vitality * 10;
  }

  void move(Cell cell, List<List<Cell>> cells) {
    if (actionpoint > 0) {
      actionpoint--;
      // Set isValidMove to false for all cells
      cells.forEach((rowCells) {
        rowCells.forEach((c) => c.isValidMove = false);
      });

      // Update player position
      row = cell.row;
      col = cell.col;
    }
  }

  set point(int value) {
    if (value >= 0) {
      this.actionpoint = value;
    }
  }

  set Pturn(bool value) {
    this.turn = value;
  }

  void toggleHighlightMode(
      List<List<Cell>> cells, List<Enemy> enemies, bool isHighlightModeOn) {
    isHighlightModeOn = !isHighlightModeOn;
    if (!isHighlightModeOn) {
      // turn off highlighting
      cells.forEach((rowCells) {
        rowCells.forEach((cell) {
          cell.isValidMove = false;
        });
      });
    } else {
      if (turn) {
        // turn on highlighting
        cells.forEach((rowCells) {
          rowCells.forEach((cell) {
            int rowDiff = (cell.row - row).abs();
            int colDiff = (cell.col - col).abs();
            cell.isValidMove = (rowDiff == 1 && colDiff == 0) || // normal move1
                (rowDiff == 0 && colDiff == 1) || // normal move1
                (rowDiff == 1 &&
                    colDiff == 1); // diagonal move1 to attack enemy
            for (Enemy enemy in enemies) {
              if (cell.isValidMove &&
                  cell.row == enemy.row &&
                  cell.col == enemy.col) {
                cell.isValidMove = true;
              } else if (cell.isValidMove &&
                  rowDiff == 1 &&
                  colDiff == 1 && // diagonal move1
                  cell.row != row &&
                  cell.col != col && // not current cell
                  ((cell.row > enemy.row && cell.col > enemy.col) || // top-left
                      (cell.row < enemy.row && cell.col < enemy.col))) {
                // bottom-right
                cell.isValidMove = true; // diagonal enemy
              }
            }
          });
        });
      }
    }
  }

  void attack(Cell enemyCell, List<List<Cell>> cells, List<Enemy> enemies,
      bool isHighlightModeOn) {
    if (actionpoint > 0) {
      actionpoint--;

      // find the enemy in the list
      Enemy enemy = enemies.firstWhere(
          (enemy) => enemy.row == enemyCell.row && enemy.col == enemyCell.col);

      // subtract player's strength from enemy's health
      enemy.health -= strength;
      toggleHighlightMode(cells, enemies, isHighlightModeOn);

      // check if the enemy is defeated
      if (enemy.health <= 0) {
        // remove the enemy from the map
        cells[enemy.row][enemy.col] = Cell(row: enemy.row, col: enemy.col);

        // remove the enemy from the list of enemies
        enemies.remove(enemy);
      }
    }
  }
}
