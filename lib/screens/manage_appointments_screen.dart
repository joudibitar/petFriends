import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';

class ManageAppointmentsScreen extends StatefulWidget {
  @override
  _ManageAppointmentsScreenState createState() => _ManageAppointmentsScreenState();
}

class _ManageAppointmentsScreenState extends State<ManageAppointmentsScreen> {
  late Future<QuerySnapshot> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _fetchAppointments();
  }

  Future<QuerySnapshot> _fetchAppointments() async {
    return FirebaseFirestore.instance.collection('appointments').get();
  }

  Future<void> _deleteAppointment(String id) async {
    try {
      await FirebaseFirestore.instance.collection('appointments').doc(id).delete();
      setState(() {
        _appointmentsFuture = _fetchAppointments();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting appointment: $e')));
    }
  }

  Future<void> _updateAppointmentStatus(String id, AppointmentStatus status) async {
    try {
      await FirebaseFirestore.instance.collection('appointments').doc(id).update({'status': status.toString().split('.').last});
      setState(() {
        _appointmentsFuture = _fetchAppointments();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Randevuları Yönet'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Randevu bulunamadı'));
          } else {
            List<DocumentSnapshot> appointments = snapshot.data!.docs;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                var appointment = Appointment.fromMap(appointments[index].data() as Map<String, dynamic>, appointments[index].id);
                return ListTile(
                  title: Text('Veteriner: ${appointment.veterinarian}, Tarih: ${DateFormat('yyyy-MM-dd').format(appointment.date)}'),
                  subtitle: Text('Pet ID: ${appointment.petId}, Sahip ID: ${appointment.ownerId}, Durum: ${appointment.status.toString().split('.').last}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (appointment.status == AppointmentStatus.pending) ...[
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            _updateAppointmentStatus(appointment.id, AppointmentStatus.approved);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _updateAppointmentStatus(appointment.id, AppointmentStatus.rejected);
                          },
                        ),
                      ],
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteAppointment(appointment.id);
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
    );
  }
}
