import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/model/profile.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_elevated_button.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();
  late Profile profile = Profile();
  File? _image;
  String? _imageUrl = ""; // Initialize with an empty string

  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _image != null
        ? _image = File(profile.image!)
        : _image = File('assets/Ellipse 4.png');
  }

  // Pick Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        updateProfileWithImage(_image!);
      });
    }
  }

  Future<void> updateProfileWithImage(File imageFile) async {
    String url =
        "https://systemproject.pythonanywhere.com/api/Profile/"; // Your API URL
    String token = TokenStorage.getToken().toString(); // Your auth token

    Dio dio = Dio();

    try {
      print("Updating profile data...");

      // Extract the filename
      String fileName = basename(imageFile.path);

      // Create FormData
      FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      print("Sending PUT request to $url");

      // Make the PUT request
      Response response = await dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Token $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        _fetchProfileData();
        print("Profile updated successfully: ${response.data}");
      } else {
        print("Failed to update profile. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> _fetchProfileData() async {
    try {
      String? token = TokenStorage.getToken();
      final jsonData = await _authRepository.fetchProfile(token!);

      setState(() {
        profile = Profile.fromJson(jsonData);
        _nameController.text = profile.name ?? 'username';

        if (profile.image != null && profile.image!.isNotEmpty) {
          _imageUrl = profile.image;
          debugPrint("Image URL: $_imageUrl");
          // Store the image URL instead of using File
        } else {
          _image = File('assets/Ellipse 4.png'); // Default placeholder image
        }
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Profile Picture and Name
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_imageUrl!.trim()),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                          onPressed: _pickImage, // Call the function directly
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  profile.name ?? "Fetching Data...",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Options List
              Container(
                child: Column(
                  children: [
                    ProfileOption(
                        title: 'General Information',
                        onTap: () {
                          context.push("/general_information_screen");
                        }),
                    ProfileOption(
                        title: 'Address',
                        onTap: () {
                          context.push("/address_screen");
                        }),
                    ProfileOption(
                        title: 'Medical services',
                        onTap: () {
                          context.push("/medical_services");
                        }),
                    CustomElevatedButton(context, 'Log out', AppConstants.white,
                        AppConstants.purple, () async {
                      await _authRepository
                          .logout(TokenStorage.getToken().toString());
                      TokenStorage.clearToken();

                      context.go('/login');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileOption({super.key, 
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: Color.fromARGB(30, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}
