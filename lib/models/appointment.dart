import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentStatus { pending, approved, rejected }

class Appointment {
  final String id;
  final String petId;
  final String ownerId;
  final String adopterId;
  final String veterinarian;
  final DateTime date;
  final String meetingPoint;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.petId,
    required this.ownerId,
    required this.adopterId,
    required this.veterinarian,
    required this.date,
    required this.meetingPoint,
    this.status = AppointmentStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'ownerId': ownerId,
      'adopterId': adopterId,
      'veterinarian': veterinarian,
      'date': date.toIso8601String(),
      'meetingPoint': meetingPoint,
      'status': status.toString().split('.').last,
    };
  }

  static Appointment fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      petId: map['petId'],
      ownerId: map['ownerId'],
      adopterId: map['adopterId'],
      veterinarian: map['veterinarian'],
      date: (map['date'] as Timestamp).toDate(),
      meetingPoint: map['meetingPoint'],
      status: map.containsKey('status')
          ? AppointmentStatus.values.firstWhere(
              (e) => e.toString().split('.').last == map['status'],
              orElse: () => AppointmentStatus.pending,
            )
          : AppointmentStatus.pending,
    );
  }
}
