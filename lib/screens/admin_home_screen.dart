import 'package:flutter/material.dart';
import 'manage_users_screen.dart';
import 'manage_pets_screen.dart';
import 'manage_appointments_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
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
