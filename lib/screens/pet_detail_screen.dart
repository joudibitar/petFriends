import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'appointment_screen.dart';
import 'messaging_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;
  final String userName;

  const PetDetailScreen({super.key, required this.pet, required this.userName});

  void _sendMessage(BuildContext context, String message, String userId) {
    FirebaseFirestore.instance.collection('messages').add({
      'petId': pet.id,
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingScreen(
          petId: pet.id,
          userId: userId,
        ),
      ),
    );
  }

  Future<String> _fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : 'unknownUserId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${pet.breed} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder<String>(
            future: _fetchUserId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              String userId = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      pet.photoUrl,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/placeholder.png',
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Breed: ${pet.breed}', style: const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text('Age: ${pet.age}', style: const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text('Type: ${pet.type}', style: const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text('Medications: ${pet.medications.join(', ')}', style: const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text('Diseases: ${pet.diseases.join(', ')}', style: const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text('Vaccinations: ${pet.vaccinations.join(', ')}', style: const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String message = 'Hi, my name is $userName. I loved your pet and I want to adopt it.';
                      _sendMessage(context, message, userId);
                    },
                    child: const Text('Adopt'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      String message = 'Hi, my name is $userName. You have a very cute pet!';
                      _sendMessage(context, message, userId);
                    },
                    child: const Text('Breed'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagingScreen(
                            petId: pet.id,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Contact'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentScreen(
                            petId: pet.id,
                            ownerId: 'ownerId', // Replace with actual ownerId
                            adopterId: userId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Create Appointment'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
