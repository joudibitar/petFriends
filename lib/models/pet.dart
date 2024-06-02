class Pet {
  final String id;
  final String breed;
  final int age;
  final List<String> medications;
  final List<String> diseases;
  final List<String> vaccinations;
  final String type;
  final String photoUrl;
  final String? adoptionInfo;
  final String? breedingInfo;

  Pet({
    required this.id,
    required this.breed,
    required this.age,
    required this.medications,
    required this.diseases,
    required this.vaccinations,
    required this.type,
    required this.photoUrl,
    this.adoptionInfo,
    this.breedingInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'breed': breed,
      'age': age,
      'medications': medications,
      'diseases': diseases,
      'vaccinations': vaccinations,
      'type': type,
      'photoUrl': photoUrl,
      'adoptionInfo': adoptionInfo,
      'breedingInfo': breedingInfo,
    };
  }

  static Pet fromMap(Map<String, dynamic> data, String id) {
    return Pet(
      id: id,
      breed: data['breed'] as String,
      age: data['age'] as int,
      medications: List<String>.from(data['medications']),
      diseases: List<String>.from(data['diseases']),
      vaccinations: List<String>.from(data['vaccinations']),
      type: data['type'] as String,
      photoUrl: data['photoUrl'] as String,
      adoptionInfo: data['adoptionInfo'] as String?,
      breedingInfo: data['breedingInfo'] as String?,
    );
  }
}
