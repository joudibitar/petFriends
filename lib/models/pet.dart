// File: lib/models/pet.dart
class Pet {
  final String id;
  final String type;
  final String breed;
  final int age;
  final String sex;
  final String place;
  final String photoUrl;
  final List<String> medications;
  final List<String> diseases;
  final List<String> vaccinations;
  final String? adoptionInfo;
  final String? breedingInfo;

  Pet({
    required this.id,
    required this.type,
    required this.breed,
    required this.age,
    required this.sex,
    required this.place,
    required this.photoUrl,
    this.medications = const [],
    this.diseases = const [],
    this.vaccinations = const [],
    this.adoptionInfo,
    this.breedingInfo,
  });

  factory Pet.fromMap(Map<String, dynamic> data, String documentId) {
    return Pet(
      id: documentId,
      type: data['type'] ?? '',
      breed: data['breed'] ?? '',
      age: data['age'] ?? 0,
      sex: data['sex'] ?? '',
      place: data['place'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      medications: List<String>.from(data['medications'] ?? []),
      diseases: List<String>.from(data['diseases'] ?? []),
      vaccinations: List<String>.from(data['vaccinations'] ?? []),
      adoptionInfo: data['adoptionInfo'],
      breedingInfo: data['breedingInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'breed': breed,
      'age': age,
      'sex': sex,
      'place': place,
      'photoUrl': photoUrl,
      'medications': medications,
      'diseases': diseases,
      'vaccinations': vaccinations,
      'adoptionInfo': adoptionInfo,
      'breedingInfo': breedingInfo,
    };
  }
}
