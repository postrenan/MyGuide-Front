import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'custom_text_field.dart';
import 'dart:html' as html;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _openTimeController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();

  String? _imageBase64;

  void _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsDataUrl(files[0]);
      
      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageBase64 = reader.result as String?;
        });
      });
    });

    uploadInput.click();
  }

  void _saveShop() {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _openTimeController.text.isNotEmpty &&
        _closeTimeController.text.isNotEmpty &&
        _imageBase64 != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop added'),
        ),
      );
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and upload an image'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: const BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Add shop",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: _imageBase64 != null
                        ? DecorationImage(
                            image: NetworkImage(_imageBase64!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imageBase64 == null
                      ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              buildTextField("Name", 350, _nameController),
              const SizedBox(height: 20),
              buildTextField("Description", 350, _descriptionController),
              const SizedBox(height: 20),
              buildTextField("Location", 350, _locationController),
              const SizedBox(height: 20),
              buildTextField("Category", 350, _categoryController),
              const SizedBox(height: 20),
              buildTextField("Open Time (ex: 8:00)", 350, _openTimeController),
              const SizedBox(height: 20),
              buildTextField("Close Time (ex: 17:00)", 350, _closeTimeController),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveShop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secundaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
