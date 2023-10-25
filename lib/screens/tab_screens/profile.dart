import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ether_ease/widgets/app_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ether_ease/services/profile_services.dart';
import 'package:ether_ease/widgets/user_image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileServices _profileServices = ProfileServices();
  File? _newProfileImage;
  String? _newUsername;

  void _pickNewImage(File image) {
    _newProfileImage = image;
  }

  Future<void> _updateProfile() async {
    await _profileServices.updateProfile(_newProfileImage, _newUsername);
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres eliminar tu cuenta?'),
                Text('Esta acción es irreversible.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                await _profileServices.deleteAccount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Correo de restablecimiento enviado. Por favor, revisa tu bandeja de entrada.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al enviar el correo de restablecimiento.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error al enviar el correo de restablecimiento. $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _profileServices.user;

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        return Stack(
          children: [
            const AppBackground(imagePath: 'assets/images/app_background.png'),
            Center(
              child: SingleChildScrollView(
                child: Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserImagePicker(
                          onPickImage: _pickNewImage,
                          initialImage: userData['image_url'],
                        ),
                        Text(
                          userData['email'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: userData['username'],
                          decoration: const InputDecoration(
                              labelText: 'Nombre de usuario'),
                          onChanged: (value) {
                            _newUsername = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Actualizar Perfil'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Cerrar Sesión'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            TextButton(
                              onPressed: _resetPassword,
                              child: const Text('Restablecer Contraseña'),
                            ),
                            TextButton(
                              onPressed: _showDeleteConfirmationDialog,
                              child: const Text('Eliminar Cuenta'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
