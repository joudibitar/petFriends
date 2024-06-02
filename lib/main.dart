import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this file exists
import 'screens/login_screen.dart';
import 'screens/vet_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_pet_screen.dart';
import 'screens/pet_detail_screen.dart' as pet_detail;
import 'screens/register_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/vet_home_screen.dart' as vet_home;
import 'screens/manage_users_screen.dart';
import 'screens/manage_pets_screen.dart';
import 'screens/manage_appointments_screen.dart';
import 'models/pet.dart'; // Ensure you have this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/vet-login': (context) => VetLoginScreen(),
        '/add-pet': (context) => AddPetScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin-home': (context) => AdminHomeScreen(),
        '/vet-home': (context) => vet_home.VetHomeScreen(),
        '/manage-users': (context) => ManageUsersScreen(),
        '/manage-pets': (context) => ManagePetsScreen(),
        '/manage-appointments': (context) => ManageAppointmentsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/pet-detail') {
          final pet = settings.arguments as Pet;
          return MaterialPageRoute(
            builder: (context) {
              return pet_detail.PetDetailScreen(pet: pet);
            },
          );
        }
        return null;
      },
    );
  }
}