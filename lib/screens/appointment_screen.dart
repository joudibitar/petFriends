import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';

class AppointmentScreen extends StatefulWidget {
  final String petId;
  final String ownerId;
  final String adopterId;

  AppointmentScreen({
    required this.petId,
    required this.ownerId,
    required this.adopterId,
  });

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _veterinarianController = TextEditingController();
  final _meetingPointController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _createAppointment() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      Appointment newAppointment = Appointment(
        id: '',
        petId: widget.petId,
        ownerId: widget.ownerId,
        adopterId: widget.adopterId,
        date: _selectedDate!,
        veterinarian: _veterinarianController.text,
        meetingPoint: _meetingPointController.text,
        status: AppointmentStatus.pending, // Initialize as pending
      );

      DocumentReference docRef = await FirebaseFirestore.instance.collection('appointments').add(newAppointment.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu oluşturuldu. ID: ${docRef.id}')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _veterinarianController.dispose();
    _meetingPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veteriner Randevusu Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Tarih'),
                readOnly: true,
                onTap: _pickDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tarih seçin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _veterinarianController,
                decoration: InputDecoration(labelText: 'Veteriner'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veteriner ismi gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _meetingPointController,
                decoration: InputDecoration(labelText: 'Buluşma Noktası'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Buluşma noktası gerekli';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAppointment,
                child: Text('Randevu Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}