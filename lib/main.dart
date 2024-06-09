import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_pet_screen.dart';
import 'screens/pet_detail_screen.dart' as pet_detail;
import 'screens/register_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/vet_home_screen.dart';
import 'screens/manage_users_screen.dart';
import 'screens/manage_pets_screen.dart';
import 'screens/manage_appointments_screen.dart';
import 'models/pet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Friends',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/add-pet': (context) => AddPetScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin-home': (context) => AdminHomeScreen(),
        '/manage-users': (context) => ManageUsersScreen(),
        '/manage-pets': (context) => ManagePetsScreen(),
        '/manage-appointments': (context) => ManageAppointmentsScreen(),
        '/vet-home': (context) => VetHomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/pet-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          final pet = args['pet'] as Pet;
          final userName = args['userName'] as String;
          return MaterialPageRoute(
            builder: (context) {
              return pet_detail.PetDetailScreen(pet: pet, userName: userName);
            },
          );
        }
        return null;
      },
    );
  }
}
