import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _incomeController = TextEditingController();
  final _contactController = TextEditingController();
  bool _hasPet = false;
  String? _petType;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'address': _addressController.text,
          'income': _incomeController.text,
          'contact': _contactController.text,
          'hasPet': _hasPet,
          'petType': _petType,
        });

        // Kayıt başarılı, ana ekrana yönlendir
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Hata mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt başarısız: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'İsim gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Soy İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soy İsim gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Adres'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Adres gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _incomeController,
                decoration: InputDecoration(labelText: 'Gelir Düzeyi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gelir düzeyi gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'İletişim Bilgileri'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'İletişim bilgileri gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-posta'),
                validator: (value) {
                  if (value == null || !EmailValidator.validate(value)) {
                    return 'Geçerli bir e-posta girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Şifre en az 6 karakter olmalı';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Pet var mı?'),
                value: _hasPet,
                onChanged: (bool value) {
                  setState(() {
                    _hasPet = value;
                  });
                },
              ),
              if (_hasPet)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Pet Türü'),
                  value: _petType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _petType = newValue;
                    });
                  },
                  items: <String>['Kedi', 'Kuş', 'Köpek', 'Balık', 'Hamster']
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
