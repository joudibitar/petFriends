import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'manage_users_screen.dart';
import 'manage_pets_screen.dart';
import 'manage_appointments_screen.dart';
import 'login_screen.dart'; 

class AdminHomeScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Kullanıcıları Yönet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageUsersScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Petleri Yönet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagePetsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Randevuları Yönet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageAppointmentsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
