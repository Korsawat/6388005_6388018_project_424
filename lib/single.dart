import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
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
  Player player = Player(
      strength: 400, vitality: 200, intellect: 5, row: 0, col: 0, turn: true);

  List<Enemy> enemies = [
    Enemy(strength: 10, vitality: 10, intellect: 5, row: 1, col: 1),
    Enemy(strength: 10, vitality: 10, intellect: 5, row: 2, col: 2),
    // Enemy(strength: 10, vitality: 10, intellect: 5, row: 3, col: 2),
    // Enemy(strength: 10, vitality: 10, intellect: 5, row: 8, col: 2),
    // Enemy(strength: 10, vitality: 10, intellect: 5, row: 5, col: 1),
    // Enemy(strength: 10, vitality: 10, intellect: 5, row: 4, col: 2),
  ];

  List<List<Cell>> cells = [];

  @override
  void initState() {
    super.initState();
    getHighScore().then((value) {
      setState(() {
        _highScore = value;
      });
    });

    for (var i = 0; i < 10; i++) {
      List<Cell> rowCells = [];
      for (var j = 0; j < 4; j++) {
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

          if (validMoves.isNotEmpty) {
            // move1 the enemy to a random valid cell
            final random = Random();
            final targetCell = validMoves[random.nextInt(validMoves.length)];
            enemy.row = targetCell.row;
            enemy.col = targetCell.col;
          }

          actionpointE--; // deduct one action point
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

  void checkTurn(bool isPlayer, bool isEnemy, Cell cell) {
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
                                player.attack(
                                    cell, cells, enemies, isHighlightModeOn);
                                isHighlightModeOn = !isHighlightModeOn;
                                actionCount();
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
            player.toggleHighlightMode(cells, enemies, isHighlightModeOn);
            isHighlightModeOn = !isHighlightModeOn;
          } else if (cell.isValidMove) {
            if (!isEnemy) {
              setState(() {
                player.move(cell, cells);
                isHighlightModeOn = !isHighlightModeOn;
                actionCount();
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
                    'Strength: ${player.strength}',
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
      },
    );
  }

  Future<void> _writeHighScore(int highScore) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/highscore.txt');
      await file.writeAsString('$highScore');
    } catch (e) {
      print('Error writing high score file: $e');
    }
  }

  void actionCount() {
    setState(() {
      print('test');
      action++;
      if (action > _highScore) {
        print('test2');
        _highScore = action;
        _writeHighScore(_highScore);
      }
    });
  }

  Future<int> getHighScore() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/highscore.txt');
      if (await file.exists()) {
        final contents = await file.readAsString();
        return int.parse(contents);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single player'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              setState(() {
                show(isStatusVisible, player, enemies, isHighlightModeOn);
                isStatusVisible = !isStatusVisible;
              });
            },
          ),
          FutureBuilder<int>(
            future: getHighScore(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                return Text('High Score: ${snapshot.data}');
              } else {
                return Text('High Score: -');
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: GridView.count(
              crossAxisCount: 4,
              children: cells.expand((row) => row).map((cell) {
                bool isPlayer =
                    cell.row == player.row && cell.col == player.col;
                bool isEnemy = enemies.any(
                    (enemy) => cell.row == enemy.row && cell.col == enemy.col);
                return GestureDetector(
                  onTap: () => checkTurn(isPlayer, isEnemy, cell),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 5, 105, 35),
                      ),
                      color: isPlayer
                          ? Colors.red
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
                              child: Icon(
                                Icons.person,
                                size: 40,
                              ),
                            ),
                        if (isEnemy)
                          Center(
                            child: Icon(
                              Icons.dangerous,
                              size: 40,
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
        ],
      ),
    );
  }
}
