import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/model/profile.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

class GeneralInformationScreen extends StatefulWidget {
  @override
  _GeneralInformationScreenState createState() =>
      _GeneralInformationScreenState();
}

class _GeneralInformationScreenState extends State<GeneralInformationScreen> {
  final AuthRepository _authRepository = AuthRepository();
  late Profile profile = Profile();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      String? token = await TokenStorage.getToken();
      final jsonData = await _authRepository.fetchProfile(token!);
      setState(() {
        profile = Profile.fromJson(jsonData);
        _nameController.text = profile.name ?? 'username';
        _phoneNumberController.text =
            profile.phoneNumber.toString() ?? '+966 54 786 3241';
        _emergencyContactController.text =
            profile.emergencyContact.toString() ?? '+966 54 786 3241';
        _heightController.text = profile.height.toString() ?? '170 cm';
        _weightController.text = profile.weight.toString() ?? '70 kg';
        _bloodTypeController.text = profile.bloodType ?? '';
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      String? token = await TokenStorage.getToken();
      final updatedProfile = {
        "name": _nameController.text,
        "phone_number": _phoneNumberController.text,
        "emergency_contact": _emergencyContactController.text,
        "height": _heightController.text,
        "weight": _weightController.text,
        "blood_type": _bloodTypeController.text,
      };
      await _authRepository.updateProfile(token!, updatedProfile);
      print('Profile updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: CustomTextWidget(
            'General Information',
            AppConstants.white,
            24,
            FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Name", _nameController),
              const SizedBox(height: 16),
              buildTextField("Phone Number", _phoneNumberController),
              const SizedBox(height: 16),
              buildTextField(
                  "Emergency Phone Number", _emergencyContactController),
              const SizedBox(height: 16),
              buildTextField("Height", _heightController),
              const SizedBox(height: 16),
              buildTextField("Weight", _weightController),
              const SizedBox(height: 16),
              buildTextField("Blood Type", _bloodTypeController),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Card(
      elevation: 8.0,
      color: const Color.fromARGB(30, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
