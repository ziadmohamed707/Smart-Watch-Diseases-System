import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/model/profile.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AuthRepository _authRepository = AuthRepository();
  late Profile profile = Profile();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
      String? token = TokenStorage.getToken();
      final jsonData = await _authRepository.fetchProfile(token!);
      setState(() {
        profile = Profile.fromJson(jsonData);
        _countryController.text = profile.country ?? 'country';
        _cityController.text = profile.city ?? 'city';
        _addressController.text = profile.address ?? 'address';
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      String? token = TokenStorage.getToken();
      final updatedProfile = {
        "country": _countryController.text,
        "city": _cityController.text,
        "address": _addressController.text,
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
        title: CustomTextWidget(
          'Address',
          AppConstants.white,
          24,
          FontWeight.bold,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField("Country", _countryController),
                const SizedBox(height: 16),
                buildTextField("City", _cityController),
                const SizedBox(height: 16),
                buildTextField("Address", _addressController),
                Spacer(),
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
