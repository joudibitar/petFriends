import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  final String petId;
  final String userId;

  const MessagingScreen({super.key, required this.petId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging Screen'),
      ),
      body: Center(
        child: Text('Messaging for pet $petId with user $userId'),
      ),
    );
  }
}
