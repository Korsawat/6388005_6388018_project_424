import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'Tree.dart';
import 'Water.dart';
import 'Player.dart';
import 'Enemy.dart';
import 'Cell.dart';
import 'package:path_provider/path_provider.dart';

class Single extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<Single> {
  // GameState gameState = GameState();
  int action = 0;
  int _highScore = 0;
  int actionpointE = 4;
  bool isEnmyturn = false;
  Player player = Player(row: 0, col: 0, turn: true);

  List<Enemy> enemies = [
    Enemy(strength: 7, vitality: 10, intellect: 5, row: 1, col: 1),
    Enemy(strength: 7, vitality: 10, intellect: 5, row: 2, col: 2),
    Enemy(strength: 7, vitality: 10, intellect: 5, row: 5, col: 3),
    Enemy(strength: 7, vitality: 10, intellect: 5, row: 4, col: 5),
  ];
  List<Tree> trees = [
    Tree(row: 2, col: 4),
    Tree(row: 8, col: 2),
    Tree(row: 2, col: 3),
    Tree(row: 5, col: 2),
  ];

  List<Water> waterr = [
    Water(row: 5, col: 2),
    Water(row: 5, col: 3),
    Water(row: 5, col: 4),
    Water(row: 5, col: 5),
    Water(row: 6, col: 4),
    Water(row: 12, col: 4),
    Water(row: 12, col: 5),
    Water(row: 13, col: 4),
  ];

  List<List<Cell>> cells = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 16; i++) {
      List<Cell> rowCells = [];
      for (var j = 0; j < 10; j++) {
        rowCells.add(Cell(row: i, col: j));
      }
      cells.add(rowCells);
    }
  }

  bool isHighlightModeOn = false;
  bool isStatusVisible = false;
  bool isWin = false;

  void enemyTurn() {
    setState(() {
      bool anyEnemyHasActionPoints = false;
      if (player.health <= 0) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Defeated!'),
              content: Text('You are defeated.'),
              actions: [
                TextButton(
                  child: Text('Return to main page'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
      for (final enemy in enemies) {
        if (actionpointE > 0) {
          anyEnemyHasActionPoints = true;
          // generate a list of valid moves for the enemy
          final validMoves = cells
              .expand((rowCells) => rowCells)
              .where((cell) =>
                  (cell.row - enemy.row).abs() <= 1 &&
                  (cell.col - enemy.col).abs() <= 1 &&
                  !enemies.any((e) => e.row == cell.row && e.col == cell.col) &&
                  (cell.row != player.row || cell.col != player.col))
              .toList();

          final validAttacks = cells
              .expand((rowCells) => rowCells)
              .where((cell) => enemies.any((e) =>
                  (player.row - e.row).abs() <= 1 &&
                  (player.col - e.col).abs() <= 1))
              .toList();

          if (validAttacks.isNotEmpty) {
            // attack the player if in range
            player.health -= enemy.strength; // reduce player's health by 10
            actionpointE--; // deduct one action point
          } else if (validMoves.isNotEmpty) {
            // move the enemy to a random valid cell
            final random = Random();
            final targetCell = validMoves[random.nextInt(validMoves.length)];
            enemy.row = targetCell.row;
            enemy.col = targetCell.col;
            actionpointE--; // deduct one action point
          }
        }
      }

      if (!anyEnemyHasActionPoints) {
        // switch turns to player's turn
        player.turn = true;
        player.point = 4;
        isEnmyturn = false;
      } else {
        // switch turns to enemy's turn
        player.turn = false;
        enemyTurn();
      }
    });
  }

  void checkTurn(
      bool isPlayer, bool isEnemy, Cell cell, bool isTree, bool isWater) {
    setState(() {
      if (enemies.isEmpty) {
        setState(() {
          isWin = true;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Victory!'),
              content: Text('All enemies are defeated.'),
              actions: [
                TextButton(
                  child: Text('Return to main page'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
      if (player.turn) {
        if (player.actionpoint > 0) {
          if (isEnemy) {
            if (cell.isValidMove) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: Icon(Icons.shield),
                            title: Text('Attack'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                player.attack(cell, cells, enemies,
                                    isHighlightModeOn, trees, waterr);
                                isHighlightModeOn = !isHighlightModeOn;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return;
          }
          if (isPlayer) {
            player.toggleHighlightMode(
                cells, enemies, isHighlightModeOn, trees, waterr);
            isHighlightModeOn = !isHighlightModeOn;
          } else if (cell.isValidMove) {
            if (!isEnemy) {
              setState(() {
                player.move(cell, cells);
                isHighlightModeOn = !isHighlightModeOn;
              });
            }
          } else {
            return; // Skip tap action
          }
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.flag),
                        title: Text('Endturn'),
                        onTap: () {
                          Navigator.pop(context);
                          player.Pturn = false;
                          actionpointE = 4;
                          enemyTurn();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    });
  }

  void show(bool isStatusVisible, Player player, List<Enemy> enemies,
      bool isHighlightModeOn) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return PlayerStatusWidget(
          isStatusVisible: isStatusVisible,
          player: player,
          enemies: enemies,
          isHighlightModeOn: isHighlightModeOn,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single player'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: GridView.count(
              crossAxisCount: 10,
              children: cells.expand((row) => row).map((cell) {
                bool isPlayer =
                    cell.row == player.row && cell.col == player.col;
                bool isEnemy = enemies.any(
                    (enemy) => cell.row == enemy.row && cell.col == enemy.col);
                bool isTree = trees.any(
                    (tree) => cell.row == tree.row && cell.col == tree.col);
                bool isWater = waterr.any(
                    (water) => cell.row == water.row && cell.col == water.col);

                return GestureDetector(
                  onTap: () =>
                      checkTurn(isPlayer, isEnemy, cell, isTree, isWater),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 5, 105, 35),
                      ),
                      color: isPlayer
                          ? Colors.red
                          : isTree
                              ? Color.fromARGB(255, 14, 43, 15)
                              : isWater
                                  ? Colors.blue
                                  : isEnemy
                                      ? (cell.isValidMove
                                          ? (isHighlightModeOn
                                              ? Colors.yellow
                                              : Colors.black)
                                          : Colors.black)
                                      : (cell.isValidMove
                                          ? (isHighlightModeOn
                                              ? Colors.grey[300]
                                              : Colors.green)
                                          : Colors.green),
                    ),
                    child: Stack(
                      children: [
                        if (player.turn)
                          if (isPlayer)
                            Center(
                              child: Image.asset(
                                player.Pclass[Player.Ptype]!,
                                width: 100,
                                height: 100,
                              ),
                            ),
                        if (isEnemy)
                          Center(
                            child: Image.asset(
                              'assets/goblin 0.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        if (!isTree &&
                            !isPlayer &&
                            !isEnemy &&
                            !isWater &&
                            !cell.isValidMove)
                          Center(
                            child: Image.asset(
                              'assets/grss2.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        if (isWater)
                          Center(
                            child: Image.asset(
                              'assets/Water.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Opacity(
              opacity: 0.8,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    player.actionpoint,
                    (index) => Icon(Icons.circle, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                show(true, player, enemies, false);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerStatusWidget extends StatelessWidget {
  final bool isStatusVisible;
  final Player player;
  final List<Enemy> enemies;
  final bool isHighlightModeOn;

  const PlayerStatusWidget({
    Key? key,
    required this.isStatusVisible,
    required this.player,
    required this.enemies,
    required this.isHighlightModeOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isStatusVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Positioned(
        top: 20,
        left: 20,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[800],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Player Status:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Strength: ${Player.strength}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                'Health: ${player.health}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                'Int: ${Player.intellect}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enemies:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: enemies
                    .asMap()
                    .map(
                      (index, enemy) => MapEntry(
                        index,
                        Text(
                          'Enemy ${index + 1}: Strength: ${enemy.strength}, Health: ${enemy.health}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
