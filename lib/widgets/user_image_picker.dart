import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) onPickImage;
  final String? initialImage;

  const UserImagePicker({
    required this.onPickImage,
    this.initialImage,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? getImageProvider() {
      if (_pickedImageFile != null) {
        return FileImage(_pickedImageFile!);
      }
      if (widget.initialImage != null) {
        return NetworkImage(widget.initialImage!);
      }
      return null;
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: getImageProvider(),
          child: _pickedImageFile == null && widget.initialImage == null
              ? const Icon(Icons.person, size: 60, color: Colors.white)
              : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Elegir imagen',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
