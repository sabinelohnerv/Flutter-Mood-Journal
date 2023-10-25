import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebase.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password, String username, File? image) async {
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredentials.user;
      await user!.sendEmailVerification();

      String? imageUrl;
      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${user.uid}.jpg');
        await storageRef.putFile(image);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'username': username,
        'email': email,
        if (imageUrl != null) 'image_url': imageUrl,
      });

      return userCredentials;
    } catch (error) {
      return null;
    }
  }

}
