import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';
import 'add_pet_screen.dart';
import 'pet_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Future<List<Pet>> _fetchPets() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pets').get();
    return snapshot.docs.map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList() as List<Pet>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<Pet>>(
        future: _fetchPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.black)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pets found', style: TextStyle(color: Colors.black)));
          } else {
            List<Pet> pets = snapshot.data!;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                Pet pet = pets[index];
                return Card(
                  color: Colors.pink[50],
                  child: ListTile(
                    leading: pet.photoUrl.isNotEmpty
                        ? Image.network(
                            pet.photoUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.pets, size: 50, color: Colors.grey),
                    title: Text(pet.breed, style: const TextStyle(color: Colors.black)),
                    subtitle: Text('Age: ${pet.age}', style: const TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailScreen(pet: pet),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPetScreen()),
          );
        },
      ),
    );
  }
}
