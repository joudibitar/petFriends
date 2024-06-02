import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String petId;
  final String ownerId;
  final String adopterId;
  final DateTime date;
  final String veterinarian;
  final bool approved;
  final String meetingPoint;

  Appointment({
    required this.id,
    required this.petId,
    required this.ownerId,
    required this.adopterId,
    required this.date,
    required this.veterinarian,
    required this.meetingPoint,
    this.approved = false,
  });

  factory Appointment.fromMap(Map<String, dynamic> data, String id) {
    return Appointment(
      id: id,
      petId: data['petId'],
      ownerId: data['ownerId'],
      adopterId: data['adopterId'],
      date: (data['date'] as Timestamp).toDate(),
      veterinarian: data['veterinarian'],
      meetingPoint: data['meetingPoint'],
      approved: data['approved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'ownerId': ownerId,
      'adopterId': adopterId,
      'date': date,
      'veterinarian': veterinarian,
      'meetingPoint': meetingPoint,
      'approved': approved,
    };
  }
}
