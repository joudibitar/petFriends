import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../models/pet.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  AddPetScreenState createState() => AddPetScreenState();
}

class AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _diseasesController = TextEditingController();
  final _vaccinationsController = TextEditingController();
  final _adoptionController = TextEditingController();
  final _breedingController = TextEditingController();
  String? _petType;
  String? _breed;
  File? _image;

  final List<String> catBreeds = [
    "British Shorthair",
    "Siamese (Siyam)",
    "Persian (İran Kedisi)",
    "Maine Coon",
    "Bengal",
    "Ragdoll",
    "Sphynx",
    "Russian Blue",
    "Scottish Fold",
    "Abyssinian"
  ];

  final List<String> dogBreeds = [
    "Labrador Retriever",
    "German Shepherd (Alman Çoban Köpeği)",
    "Golden Retriever",
    "Bulldog",
    "Poodle (Kaniş)",
    "Beagle",
    "Boxer",
    "Rottweiler",
    "Yorkshire Terrier (Yorkie)",
    "Dachshund (Sosis Köpek)",
    "Siberian Husky",
    "Pomeranian",
    "Shih Tzu",
    "Great Dane (Danua)",
    "Doberman Pinscher"
  ];

  final List<String> birdBreeds = [
    "Muhabbet Kuşu (Budgerigar)",
    "Kanarya",
    "Papağan (Parrot)",
    "Saka (Goldfinch)",
    "Cennet Papağanı (Lovebird)",
    "Zebra İspinozu (Zebra Finch)",
    "Hint Bülbülü (Myna)",
    "Kakariki",
    "Sultan Papağanı (Cockatiel)",
    "Ağaçkakan (Woodpecker)",
    "Jako (African Grey Parrot)",
    "Beyaz Muhabbet Kuşu (Albino Budgerigar)"
  ];

  final List<String> hamsterBreeds = [
    "Suriye Hamsterı (Syrian Hamster)",
    "Cüce Campbell Rus Hamsterı (Dwarf Campbell's Russian Hamster)",
    "Cüce Winter White Rus Hamsterı (Dwarf Winter White Russian Hamster)",
    "Çin Hamsterı (Chinese Hamster)",
    "Roborovski Hamsterı (Roborovski Hamster)",
    "Sibirya Hamsterı (Siberian Hamster)"
  ];

  List<String> getBreeds() {
    switch (_petType) {
      case 'Kedi':
        return catBreeds;
      case 'Köpek':
        return dogBreeds;
      case 'Kuş':
        return birdBreeds;
      case 'Hamster':
        return hamsterBreeds;
      default:
        return [];
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // Handle the case when no image is selected
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    String fileName = const Uuid().v4();
    Reference storageReference = FirebaseStorage.instance.ref().child('pets/$fileName');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _addPet() async {
    if (_formKey.currentState!.validate()) {
      if (_petType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir pet türü seçin.')),
        );
        return;
      }
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir fotoğraf seçin.')),
        );
        return;
      }

      try {
        int age = int.parse(_ageController.text);
        String imageUrl = await _uploadImage(_image!);

        Pet newPet = Pet(
          id: const Uuid().v4(),
          breed: _breed!,
          age: age,
          medications: _medicationsController.text.isNotEmpty 
                        ? _medicationsController.text.split(',').map((e) => e.trim()).toList()
                        : [],
          diseases: _diseasesController.text.isNotEmpty 
                      ? _diseasesController.text.split(',').map((e) => e.trim()).toList()
                      : [],
          vaccinations: _vaccinationsController.text.isNotEmpty 
                          ? _vaccinationsController.text.split(',').map((e) => e.trim()).toList()
                          : [],
          type: _petType!,
          photoUrl: imageUrl,
          adoptionInfo: _adoptionController.text.isNotEmpty ? _adoptionController.text : null,
          breedingInfo: _breedingController.text.isNotEmpty ? _breedingController.text : null,
        );

        await FirebaseFirestore.instance.collection('pets').doc(newPet.id).set(newPet.toMap());

        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Pet Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Pet Türü'),
                value: _petType,
                onChanged: (String? newValue) {
                  setState(() {
                    _petType = newValue;
                    _breed = null; // Reset the breed selection when pet type changes
                  });
                },
                items: <String>['Kedi', 'Kuş', 'Köpek', 'Hamster']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Pet türü seçin';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cins'),
                value: _breed,
                onChanged: (String? newValue) {
                  setState(() {
                    _breed = newValue;
                  });
                },
                items: getBreeds().map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cins gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Yaş'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yaş gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(labelText: 'İlaçlar (virgülle ayırın)'),
              ),
              TextFormField(
                controller: _diseasesController,
                decoration: const InputDecoration(labelText: 'Hastalıklar (virgülle ayırın)'),
              ),
              TextFormField(
                controller: _vaccinationsController,
                decoration: const InputDecoration(labelText: 'Aşılar (virgülle ayırın)'),
              ),
                            TextFormField(
                controller: _adoptionController,
                decoration: const InputDecoration(labelText: 'Evlat Edinme Bilgisi'),
              ),
              TextFormField(
                controller: _breedingController,
                decoration: const InputDecoration(labelText: 'Çiftleştirme Bilgisi'),
              ),
              const SizedBox(height: 20),
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(_image!, height: 200),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Fotoğraf Seç'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPet,
                child: const Text('Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
