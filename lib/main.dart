import 'package:flutter/material.dart';
import 'package:hello_sud_flutter/game_page.dart';
import 'dart:math';

import 'package:hello_sud_flutter/game_utils.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userId = (Random().nextInt(10000) + 1000).toString();
  final roomIdCtrl = TextEditingController(text: (Random().nextInt(10000) + 1000).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Text('User ID: $userId'),
            TextFormField(
              controller: roomIdCtrl,
              decoration: InputDecoration(labelText: I18n.t('room_id_title')),
            ),
            const SizedBox(height: 100),
            Text(I18n.t('click_game_info')),
            Expanded(
              child: ListView(
                children: [
                  ListTile(title: Text(I18n.t('game_bumper')), onTap: () => clickGame('1461227817776713818')),
                  ListTile(title: Text(I18n.t('game_dart_master')), onTap: () => clickGame('1461228379255603251')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clickGame(String gameId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePage(userId: userId, roomId: roomIdCtrl.text, gameId: gameId),
      ),
    );
  }
}
