import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/global_state.dart';
import '../widgets/header_1_line.dart';
import '../widgets/pink_button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  String _message = '';
  bool _isError = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_captionController.text.isEmpty || _selectedImage == null) {
      setState(() {
        _isError = true;
        _message = 'Please add a caption and select an image.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final userId = GlobalState().currentUserId;

      if (userId == null) {
        throw Exception('User ID is null');
      }

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('post_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(_selectedImage!);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // Add post to Firestore
      await FirebaseFirestore.instance.collection('Posts').add({
        'caption': _captionController.text,
        'image_url': imageUrl,
        'likes_count': 0,
        'user_id': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isError = false;
        _message = 'Post created successfully!';
      });

      // Clear the fields after success
      _captionController.clear();
      _selectedImage = null;
    } catch (e) {
      setState(() {
        _isError = true;
        _message = 'Error creating post: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9), // Match the app's background color
      body: SafeArea(
        child: Column(
          children: [
            SimpleHeader(
              title: 'CREATE A POST',
              underlineWidth: 200,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _captionController,
                      style: const TextStyle(
                        color: Color(0xFF003366),
                        fontFamily: 'Finlandica',
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Caption',
                        labelStyle: const TextStyle(
                          color: Color(0xFF003366),
                          fontFamily: 'Finlandica',
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD19348), // Match input field background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _selectedImage == null
                        ? const Text(
                            'No image selected',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Finlandica',
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.file(
                              _selectedImage!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003366),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.photo_library, color: Color(0xFFF2EBD9)),
                          label: const Text(
                            'Gallery',
                            style: TextStyle(
                              color: Color(0xFFF2EBD9),
                              fontFamily: 'Finlandica',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003366),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt, color: Color(0xFFF2EBD9)),
                          label: const Text(
                            'Camera',
                            style: TextStyle(
                              color: Color(0xFFF2EBD9),
                              fontFamily: 'Finlandica',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Message Display (Error/Success)
                    if (_message.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isError
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                              color: _isError
                                  ? const Color(0xFFB85C5C)
                                  : const Color(0xFF2B9A50),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _message,
                                style: TextStyle(
                                  color: _isError
                                      ? const Color(0xFFB85C5C)
                                      : const Color(0xFF2B9A50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PinkButton(
                      buttonText: 'CREATE POST',
                      onPressed: _uploadPost,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
