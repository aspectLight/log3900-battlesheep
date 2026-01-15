import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Map<String, String>> messages = [];
  String roomId = '';

  MyAppState() {
    initSocket();
  }

  void initSocket() {
    socket = IO.io(
      'http://10.0.2.2:3000',
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log('Connecté au serveur');
    });

    socket.on('getMessagesResponse', (data) {
      log('Messages de la salle d\'attente reçus: $data');
      for (var msg in data) {
        messages.add({
          'type': 'received',
          'name': msg['name'],
          'content': msg['content'],
          'time': msg['time'],
        });
      }
      notifyListeners();
    });

    socket.on('massMessage', (message) {
      log('Nouveau message dans la salle d\'attente: $message');
      messages.add({
        'type': 'received',
        'name': message['name'],
        'content': message['content'],
        'time': message['time'],
      });
      notifyListeners();
    });

    socket.onDisconnect((_) {
      log('Déconnecté');
    });

    socket.onError((err) {
      log('Erreur socket générale: $err');
    });
  }

  void sendMessage(String content, BuildContext context) {
    if (content.trim().isEmpty) return;

    messages.add({
      'type': 'sent',
      'name': 'Joueur 2',
      'content': content.trim(),
      'time': _now(),
    });

    var data = {
      'message': content.trim(),
      'playerName': 'Joueur 2',
      'roomId': roomId,
    };

    log('Envoi du message: $data');

    socket.emit('sendMessageToWaitingRoom', data);

    notifyListeners();
  }

  void joinRoom(String content, BuildContext context) {
    socket.emit('leaveWaitingRoom', roomId);

    if (content.trim().isEmpty) return;

    roomId = content.trim();
    log('Rejoindre la salle: $roomId');

    socket.emit('getMessagesFromWaitingRoom', roomId);
    socket.emit('joinWaitingRoom', roomId);
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = MessagesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.videogame_asset),
                      label: Text('Jeu'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.chat_bubble_outline_sharp),
                      label: Text('Clavardage'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text('Jeu à implémenter'),
    );
  }
}

class MessagesPage extends StatefulWidget {
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  @override
  void dispose() {
    _roomController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        TextField(controller: _roomController, onSubmitted: _joinRoom),
        for (var message in appState.messages)
          Align(
            alignment: message['type'] == 'received'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Column(
              crossAxisAlignment: message['type'] == 'received'
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: message['type'] == 'received'
                            ? Radius.zero
                            : const Radius.circular(15),
                        bottomRight: message['type'] == 'sent'
                            ? Radius.zero
                            : const Radius.circular(15),
                      ),
                    ),
                    child: Text(message['content']!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    '${message['name']} - ${message['time']!}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

        Spacer(),

        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.send,
            onSubmitted: _sendMessage,
            decoration: const InputDecoration(
              hintText: 'Type your message here...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  void _sendMessage(String value) {
    if (value.trim().isEmpty) return;

    context.read<MyAppState>().sendMessage(value, context);
    _controller.clear();
  }

  void _joinRoom(String value) {
    if (value.trim().isEmpty) return;

    context.read<MyAppState>().joinRoom(value, context);
    _roomController.clear();
  }
}

String _now() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
}
