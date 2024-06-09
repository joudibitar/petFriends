import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';
import 'add_pet_screen.dart';

class ManagePetsScreen extends StatefulWidget {
  @override
  _ManagePetsScreenState createState() => _ManagePetsScreenState();
}

class _ManagePetsScreenState extends State<ManagePetsScreen> {
  late Future<QuerySnapshot> _petsFuture;

  @override
  void initState() {
    super.initState();
    _petsFuture = _fetchPets();
  }

  Future<QuerySnapshot> _fetchPets() async {
    return FirebaseFirestore.instance.collection('pets').get();
  }

  Future<void> _deletePet(String id) async {
    try {
      await FirebaseFirestore.instance.collection('pets').doc(id).delete();
      setState(() {
        _petsFuture = _fetchPets();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting pet: $e')));
    }
  }

  Future<void> _editPet(Pet pet) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPetScreen(editPet: pet)),
    ).then((value) {
      setState(() {
        _petsFuture = _fetchPets();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Pets'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.black)));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pets found', style: TextStyle(color: Colors.black)));
          } else {
            List<DocumentSnapshot> pets = snapshot.data!.docs;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                var pet = Pet.fromMap(pets[index].data() as Map<String, dynamic>, pets[index].id);
                return ListTile(
                  title: Text(pet.breed, style: const TextStyle(color: Colors.black)),
                  subtitle: Text('Breed: ${pet.breed}, Age: ${pet.age}', style: const TextStyle(color: Colors.black)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editPet(pet);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deletePet(pet.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPetScreen()),
          ).then((value) {
            setState(() {
              _petsFuture = _fetchPets();
            });
          });
        },
      ),
    );
  }
}
