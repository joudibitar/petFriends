import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import 'appointment_detail_screen.dart'; // Assuming you have a screen to show details of a single appointment

class AppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No appointments found'));
          }
          final appointments = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Appointment.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                title: Text('Veterinarian: ${appointment.veterinarian}'),
                subtitle: Text('Date: ${DateFormat('yyyy-MM-dd').format(appointment.date)}'),
                trailing: _buildStatusIcon(appointment.status),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetailScreen(appointment: appointment),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.approved:
        return Icon(Icons.check_circle, color: Colors.green);
      case AppointmentStatus.rejected:
        return Icon(Icons.cancel, color: Colors.red);
      case AppointmentStatus.pending:
      default:
        return Icon(Icons.hourglass_empty, color: Colors.grey);
    }
  }
}
