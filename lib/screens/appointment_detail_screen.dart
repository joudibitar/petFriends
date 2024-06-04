import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Veterinarian: ${appointment.veterinarian}', style: TextStyle(fontSize: 18)),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(appointment.date)}', style: TextStyle(fontSize: 18)),
            Text('Pet ID: ${appointment.petId}', style: TextStyle(fontSize: 18)),
            Text('Owner ID: ${appointment.ownerId}', style: TextStyle(fontSize: 18)),
            Text('Meeting Point: ${appointment.meetingPoint}', style: TextStyle(fontSize: 18)),
            Text('Status: ${_statusToString(appointment.status)}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  String _statusToString(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.approved:
        return 'Approved';
      case AppointmentStatus.rejected:
        return 'Rejected';
      case AppointmentStatus.pending:
      default:
        return 'Pending';
    }
  }
}
