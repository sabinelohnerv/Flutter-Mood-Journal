import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileServices {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateProfile(File? newProfileImage, String? newUsername) async {
    if (newProfileImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user!.uid}.jpg');
      await storageRef.putFile(newProfileImage);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'image_url': imageUrl});
    }

    if (newUsername != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'username': newUsername});
    }
  }

  Future<void> deleteProfileImage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${user!.uid}.jpg');
    try {
      await storageRef.delete();
    } catch (error) {
      return;
    }
  }

  Future<void> deleteUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .delete();
  }

  Future<void> deleteUserAccount() async {
    await user!.delete();
  }

  Future<void> deleteAccount() async {
    try {
      await deleteProfileImage();
      await deleteUserData();
      await user!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'El usuario debe volver a autenticarse antes de eliminar la cuenta.');
      } else {
        print('Ocurrió un error al eliminar la cuenta: ${e.message}');
      }
    } catch (error) {
      print('Ocurrió un error inesperado: $error');
    }
  }

  Future<bool> reauthenticateUser(String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user!.reauthenticateWithCredential(credential);
      return true;
    } catch (error) {
      print('Error durante la reautenticación: $error');
      return false;
    }
  }
}
