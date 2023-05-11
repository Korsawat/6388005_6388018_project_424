import 'package:flutter/material.dart';

import 'Cell.dart';
import 'Enemy.dart';
import 'Tree.dart';
import 'Water.dart';

class Player {
  static int strength = 5;
  static int vitality = 5;
  static int intellect = 5;
  int row;
  int col;
  int health = 10;
  int actionpoint = 4;
  int range = 1;
  bool turn = true;
  static String Ptype = "";
  var Pclass = {
    "w": "assets/knight 0.png",
    "a": "assets/archer with a b 0.png",
    "m": "assets/mage 1.png"
  };
  Player({required this.row, required this.col, required this.turn}) {
    // set strength, vitality, and intellect based on player type
    if (Ptype == "w") {
      strength = 10;
      vitality = 30;
      intellect = 5;
    } else if (Ptype == "a") {
      strength = 15;
      vitality = 20;
      intellect = 5;
    } else if (Ptype == "m") {
      strength = 5;
      vitality = 10;
      intellect = 20;
    }
    // calculate health as vitality * 10
    this.health = vitality * 10;
  }

  void move(Cell cell, List<List<Cell>> cells) {
    if (actionpoint > 0) {
      actionpoint--;

      // Set isValidMove to false for all cells

      cells.forEach((rowCells) {
        rowCells.forEach((c) => c.isValidMove = false);
      });
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

  void toggleHighlightMode(List<List<Cell>> cells, List<Enemy> enemies,
      bool isHighlightModeOn, List<Tree> trees, List<Water> waterr) {
    isHighlightModeOn = !isHighlightModeOn;
    if (!isHighlightModeOn) {
      // turn off highlighting
      cells.forEach((rowCells) {
        rowCells.forEach((cell) {
          cell.isValidMove = false;
        });
      });
    } else {
      if (Ptype == "w") {
        // Warrior can only move one cell in any direction
        range = 1;
      } else if (Ptype == "a") {
        // Archer can move up to 3 cells away
        range = 3;
      } else if (Ptype == "m") {
        // Mage can move up to 2 cells away
        range = 2;
      }
      if (turn) {
        // turn on highlighting
        cells.forEach((rowCells) {
          rowCells.forEach((cell) {
            int rowDiff = (cell.row - row).abs();
            int colDiff = (cell.col - col).abs();
            bool isValidMove = false;
            if (Ptype == "w") {
              // Warrior can only move one cell in any direction
              isValidMove = rowDiff <= range && colDiff <= range;
            } else if (Ptype == "a") {
              // Archer can move up to 3 cells away
              isValidMove = (rowDiff <= 1 && colDiff <= 1) ||
                  (rowDiff == range && colDiff == range - 1) || // normal move1
                  (rowDiff == range - 1 && colDiff == range) || // normal move1
                  (rowDiff == range &&
                      colDiff == range) || // diagonal move1 to attack enemy
                  (range == 2 &&
                      rowDiff <= range &&
                      colDiff <= range); // mage move2
            } else if (Ptype == "m") {
              // Mage can move up to 2 cells away
              isValidMove =
                  (rowDiff == range && colDiff <= range) || // normal move1
                      (colDiff == range && rowDiff <= range); // normal move1
            }
            cell.isValidMove = isValidMove;
            for (Enemy enemy in enemies) {
              if (cell.isValidMove &&
                  cell.row == enemy.row &&
                  cell.col == enemy.col) {
                cell.isValidMove = true;
              } else if (cell.isValidMove &&
                  rowDiff == range &&
                  colDiff == range && // diagonal move1
                  cell.row != row &&
                  cell.col != col && // not current cell
                  ((cell.row > enemy.row && cell.col > enemy.col) || // top-left
                      (cell.row < enemy.row && cell.col < enemy.col))) {
                // bottom-right
                cell.isValidMove = true; // diagonal enemy
              }
            }
            for (Tree tree in trees) {
              if (cell.row == tree.row && cell.col == tree.col) {
                cell.isValidMove = false;
              }
            }
            for (Water water in waterr) {
              if (cell.row == water.row && cell.col == water.col) {
                cell.isValidMove = false;
              }
            }
          });
        });
      }
    }
  }

  void attack(Cell enemyCell, List<List<Cell>> cells, List<Enemy> enemies,
      bool isHighlightModeOn, List<Tree> trees, List<Water> waterr) {
    if (actionpoint > 0) {
      actionpoint--;

      // find the enemy in the list
      Enemy enemy = enemies.firstWhere(
          (enemy) => enemy.row == enemyCell.row && enemy.col == enemyCell.col);

      // subtract player's strength from enemy's health
      if (Ptype == "w" || Ptype == "a") {
        enemy.health -= strength;
      } else if (Ptype == "m") {
        enemy.health -= intellect;
      }
      toggleHighlightMode(cells, enemies, isHighlightModeOn, trees, waterr);

      // check if the enemy is defeated
      if (enemy.health <= 0) {
        // remove the enemy from the map
        cells[enemy.row][enemy.col] = Cell(row: enemy.row, col: enemy.col);

        // remove the enemy from the list of enemies
        if (Ptype == "w") {
          strength++;
          health += ((10 * vitality) / 1.5) as int;
        } else if (Ptype == "a") {
          strength += 6;
          health += ((3 * vitality) / 1.5) as int;
        } else if (Ptype == "m") {
          intellect += 8;
          health += ((4 * vitality) / 1.5) as int;
        }
        enemies.remove(enemy);
      }
    }
  }
}
