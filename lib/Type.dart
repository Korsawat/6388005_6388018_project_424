import 'package:flutter/material.dart';
import 'single.dart';

import 'Player.dart';

class SelectPlayerTypePage extends StatefulWidget {
  @override
  _SelectPlayerTypePageState createState() => _SelectPlayerTypePageState();
}

class _SelectPlayerTypePageState extends State<SelectPlayerTypePage> {
  String _selectedPlayerType = '';

  final List<PlayerType> _playerTypes = [
    PlayerType(
      name: "Warrior",
      type: 'W',
      description: 'A fierce fighter who excels in close combat.',
      image: Image.asset(
        'assets/knight 0.png',
        width: 100,
        height: 100,
      ),
    ),
    PlayerType(
      name: "Archer",
      type: 'A',
      description: 'A skilled marksman who can take out foes from afar.',
      image: Image.asset(
        'assets/archer with a b 0.png',
        width: 100,
        height: 100,
      ),
    ),
    PlayerType(
      name: "Mage",
      type: 'm',
      description: 'Mage',
      image: Image.asset(
        'assets/mage 1.png',
        width: 100,
        height: 100,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Player Class',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Choose Your Player Class',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ..._playerTypes.map(
              (playerType) => Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Radio<String>(
                      value: playerType.type.toLowerCase(),
                      groupValue: _selectedPlayerType,
                      onChanged: (value) {
                        setState(() {
                          _selectedPlayerType = value!;
                        });
                      },
                    ),
                    playerType.image,
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerType.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            playerType.description,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Player.Ptype = _selectedPlayerType;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Single()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                primary: Colors.red[900],
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerType {
  final String name;
  final String type;
  final String description;
  final Image image;

  PlayerType({
    required this.name,
    required this.type,
    required this.description,
    required this.image,
  });
}
