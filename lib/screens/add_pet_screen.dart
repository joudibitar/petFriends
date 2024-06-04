import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../models/pet.dart';

class AddPetScreen extends StatefulWidget {
  final Pet? editPet;

  const AddPetScreen({Key? key, this.editPet}) : super(key: key);

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
  String? _sex;
  String? _place;
  String? _purpose;
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

  @override
  void initState() {
    super.initState();
    if (widget.editPet != null) {
      _petType = widget.editPet!.type;
      _breed = widget.editPet!.breed;
      _sex = widget.editPet!.sex;
      _place = widget.editPet!.place;
      _ageController.text = widget.editPet!.age.toString();
      _medicationsController.text = widget.editPet!.medications.join(', ');
      _diseasesController.text = widget.editPet!.diseases.join(', ');
      _vaccinationsController.text = widget.editPet!.vaccinations.join(', ');
      _adoptionController.text = widget.editPet!.adoptionInfo ?? '';
      _breedingController.text = widget.editPet!.breedingInfo ?? '';
      _purpose = widget.editPet!.adoptionInfo != null ? 'Adoption' : 'Breeding';
    }
  }

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
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while picking the image: $e')),
      );
      print('Error picking image: $e');
    }
  }

  Future<String> _uploadImage(File image) async {
    String fileName = const Uuid().v4();
    Reference storageReference = FirebaseStorage.instance.ref().child('pets/$fileName');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _addOrUpdatePet() async {
    if (_formKey.currentState!.validate()) {
      if (_petType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir pet türü seçin.')),
        );
        return;
      }
      if (_image == null && widget.editPet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir fotoğraf seçin.')),
        );
        return;
      }

      try {
        int age = int.parse(_ageController.text);
        String imageUrl = _image != null ? await _uploadImage(_image!) : widget.editPet!.photoUrl;

        Pet newPet = Pet(
          id: widget.editPet?.id ?? const Uuid().v4(),
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
          sex: _sex!,
          place: _place!,
          photoUrl: imageUrl,
          adoptionInfo: _purpose == 'Adoption' ? _adoptionController.text : null,
          breedingInfo: _purpose == 'Breeding' ? _breedingController.text : null,
        );

        if (widget.editPet != null) {
          await FirebaseFirestore.instance.collection('pets').doc(widget.editPet!.id).update(newPet.toMap());
        } else {
          await FirebaseFirestore.instance.collection('pets').doc(newPet.id).set(newPet.toMap());
        }

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
        title: Text(widget.editPet != null ? 'Pet Düzenle' : 'Yeni Pet Ekle'),
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cinsiyet'),
                value: _sex,
                onChanged: (String? newValue) {
                  setState(() {
                    _sex = newValue;
                  });
                },
                items: <String>['Erkek', 'Dişi']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cinsiyet gerekli';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Yer'),
                value: _place,
                onChanged: (String? newValue) {
                  setState(() {
                    _place = newValue;
                  });
                },
                items: <String>['New York', 'Los Angeles', 'Chicago', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yer gerekli';
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Amaç'),
                value: _purpose,
                onChanged: (String? newValue) {
                  setState(() {
                    _purpose = newValue;
                  });
                },
                items: <String>['Adoption', 'Breeding']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Amaç seçin';
                  }
                  return null;
                },
              ),
              _purpose == 'Adoption'
                  ? TextFormField(
                      controller: _adoptionController,
                      decoration: const InputDecoration(labelText: 'Evlat Edinme Bilgisi'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Evlat edinme bilgisi gerekli';
                        }
                        return null;
                      },
                    )
                  : TextFormField(
                      controller: _breedingController,
                      decoration: const InputDecoration(labelText: 'Çiftleştirme Bilgisi'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Çiftleştirme bilgisi gerekli';
                        }
                        return null;
                      },
                    ),
              const SizedBox(height: 20),
              _image == null && widget.editPet == null
                  ? const Text('No image selected.')
                  : widget.editPet != null && _image == null
                      ? Image.network(widget.editPet!.photoUrl, height: 200)
                      : Image.file(_image!, height: 200),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Fotoğraf Seç'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdatePet,
                child: Text(widget.editPet != null ? 'Güncelle' : 'Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
