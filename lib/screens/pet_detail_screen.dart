import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'appointment_screen.dart';
import 'messaging_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${pet.breed} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  pet.photoUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
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
                  // Handle adoption
                },
                child: const Text('Adopt'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle breeding
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
                        userId: 'userId', // Replace with actual userId
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
                        adopterId: 'adopterId', // Replace with actual adopterId
                      ),
                    ),
                  );
                },
                child: const Text('Create Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
