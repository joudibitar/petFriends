import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';
import 'add_pet_screen.dart';
import 'pet_detail_screen.dart';

class PetListScreen extends StatefulWidget {
  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  Future<List<Pet>> _fetchPets() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pets').get();
    return snapshot.docs.map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPetScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Pet>>(
        future: _fetchPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pets found'));
          } else {
            List<Pet> pets = snapshot.data!;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                Pet pet = pets[index];
                return ListTile(
                  title: Text(pet.breed),
                  subtitle: Text('Age: ${pet.age}'),
                  leading: pet.photoUrl.isNotEmpty
                      ? Image.network(pet.photoUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.pets),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailScreen(pet: pet),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}