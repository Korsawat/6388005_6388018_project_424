import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project1/Multi.dart';
import 'package:uuid/uuid.dart';
import 'Cell.dart';
import 'Type.dart';
import 'single.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://dlcfnfvycmopodisclfk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRsY2ZuZnZ5Y21vcG9kaXNjbGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODIwMDAzMTQsImV4cCI6MTk5NzU3NjMxNH0.69CQgxVjJzMgnyzeiTv8f9iYNyp8LwHQUvg3I2PuYko',
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 40),
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Protector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Protector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 114, 193, 204),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Protector',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectPlayerTypePage()),
                    );
                  },
                  child: Container(
                    height: 60.0,
                    width: 200.0,
                    child: Center(
                      child: Text(
                        'Start',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 50),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => GamePage()),
                //     );
                //   },
                //   child: Container(
                //     height: 60.0,
                //     width: 200.0,
                //     child: Center(
                //       child: Text(
                //         'Multiplayer',
                //         style: TextStyle(
                //             fontSize: 24.0,
                //             fontWeight: FontWeight.bold,
                //             letterSpacing: 1.5),
                //       ),
                //     ),
                //   ),
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all<Color>(Colors.blue),
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //       RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.0),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 50),
                OutlinedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Container(
                    height: 60.0,
                    width: 200.0,
                    child: Center(
                      child: Text(
                        'Quit',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// class GamePage extends StatefulWidget {
//   const GamePage({Key? key}) : super(key: key);

//   @override
//   State<GamePage> createState() => _GamePageState();
// }

// class _GamePageState extends State<GamePage> {
//   late final MapPage _game;

//   /// Holds the RealtimeChannel to sync game states
//   RealtimeChannel? _gameChannel;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [_game],
//       ),
//     );
//   }

//   List<List<Cell>> cells = [];
//   @override
//   void initState() {
//     super.initState();

//     for (var i = 0; i < 10; i++) {
//       List<Cell> rowCells = [];
//       for (var j = 0; j < 4; j++) {
//         rowCells.add(Cell(row: i, col: j));
//       }
//       cells.add(rowCells);
//     }
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     _game = MapPage(onGameStateUpdate: (temp) async {
//       ChannelResponse response;
//       do {
//         response = await _gameChannel!.send(
//           type: RealtimeListenTypes.broadcast,
//           event: 'game_state',
//           payload: {'game': _game},
//         );

//         // wait for a frame to avoid infinite rate limiting loops
//         await Future.delayed(Duration.zero);
//         setState(() {});
//       } while (response == ChannelResponse.rateLimited);
//     });

//     // await for a frame so that the widget mounts
//     await Future.delayed(Duration.zero);

//     if (mounted) {
//       _openLobbyDialog();
//     }
//   }

//   void _openLobbyDialog() {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return _LobbyDialog(
//             onGameStarted: (gameId) async {
//               // await a frame to allow subscribing to a new channel in a realtime callback
//               await Future.delayed(Duration.zero);

//               setState(() {});

//               _gameChannel = supabase.channel(gameId,
//                   opts: const RealtimeChannelConfig(ack: true));

//               _gameChannel!.on(RealtimeListenTypes.broadcast,
//                   ChannelFilter(event: 'game_state'), (payload, [_]) {
//                 final temp = payload['temp'];
//                 _game.updatePlayer(
//                   position: temp,
//                 );
//                 // _game.update();
//               }).subscribe();
//             },
//           );
//         });
//   }
// }

// class _LobbyDialog extends StatefulWidget {
//   const _LobbyDialog({
//     required this.onGameStarted,
//   });

//   final void Function(String gameId) onGameStarted;

//   @override
//   State<_LobbyDialog> createState() => _LobbyDialogState();
// }

// class _LobbyDialogState extends State<_LobbyDialog> {
//   List<String> _userids = [];
//   bool _loading = false;

//   /// Unique identifier for each players to identify eachother in lobby
//   final myUserId = const Uuid().v4();

//   late final RealtimeChannel _lobbyChannel;

//   @override
//   void initState() {
//     super.initState();

//     _lobbyChannel = supabase.channel(
//       'lobby',
//       opts: const RealtimeChannelConfig(self: true),
//     );
//     _lobbyChannel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
//         (payload, [ref]) {
//       // Update the lobby count
//       final presenceState = _lobbyChannel.presenceState();

//       setState(() {
//         _userids = presenceState.values
//             .map((presences) =>
//                 (presences.first as Presence).payload['user_id'] as String)
//             .toList();
//       });
//     }).on(RealtimeListenTypes.broadcast, ChannelFilter(event: 'game_start'),
//         (payload, [_]) {
//       // Start the game if someone has started a game with you
//       final participantIds = List<String>.from(payload['participants']);
//       if (participantIds.contains(myUserId)) {
//         final gameId = payload['game_id'] as String;
//         widget.onGameStarted(gameId);
//         Navigator.of(context).pop();
//       }
//     }).subscribe(
//       (status, [ref]) async {
//         if (status == 'SUBSCRIBED') {
//           await _lobbyChannel.track({'user_id': myUserId});
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     supabase.removeChannel(_lobbyChannel);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Lobby'),
//       content: _loading
//           ? const SizedBox(
//               height: 100,
//               child: Center(child: CircularProgressIndicator()),
//             )
//           : Text('${_userids.length} users waiting'),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           child: const Text('Back'),
//         ),
//         TextButton(
//           onPressed: _userids.length < 2
//               ? null
//               : () async {
//                   setState(() {
//                     _loading = true;
//                   });

//                   final opponentId =
//                       _userids.firstWhere((userId) => userId != myUserId);
//                   final gameId = const Uuid().v4();
//                   await _lobbyChannel.send(
//                     type: RealtimeListenTypes.broadcast,
//                     event: 'game_start',
//                     payload: {
//                       'participants': [
//                         opponentId,
//                         myUserId,
//                       ],
//                       'game_id': gameId,
//                     },
//                   );
//                 },
//           child: const Text('start'),
//         ),
//       ],
//     );
//   }
// }
