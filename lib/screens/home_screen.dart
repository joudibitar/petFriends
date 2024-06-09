import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appointments_screen.dart';
import 'messaging_screen.dart';
import 'pet_list_screen.dart';
import 'add_pet_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String userId = ''; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _getUserId(); 
  }

  void _getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Friends'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Appointments'),
            Tab(text: 'Chats'),
            Tab(text: 'Pets'),
            Tab(icon: Icon(Icons.add)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AppointmentsScreen(),
          MessagingScreen(petId: 'somePetId', userId: userId), 
          PetListScreen(),
          AddPetScreen(),
        ],
      ),
    );
  }
}
