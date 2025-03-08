import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/model/profile.dart';

class AllergyPage extends StatefulWidget {
  const AllergyPage({super.key});

  @override
  _AllergyPageState createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {
  final AuthRepository _authRepository = AuthRepository();
  late Profile profile = Profile();
  late List<String> allergy = [];

  void deleteAllergy(int index) {
    setState(() {
      allergy.removeAt(index);
    });
  }
  Future<void> _fetchAllergyData() async {
    try {
      String? token = TokenStorage.getToken();
      final jsonData = await _authRepository.fetchProfile(token!);
      setState(() {
        profile = Profile.fromJson(jsonData);
        allergy = splitString(profile.allergies!);
        
      });
    } catch (e) {
      print('Error fetching allergies data: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      String? token = TokenStorage.getToken();
      final updatedProfile = {
        "allergies": mergeStrings(allergy),
      };
      await _authRepository.updateProfile(token!, updatedProfile);
      print('allergies updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating allergies: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update allergies')),
      );
    }
  }

  List<String> splitString(String mergedString) {
    return mergedString.split("-"); // Splitting by space
  }

  String mergeStrings(List<String> strings) {
    return strings.join("-"); // Merge with space separator
  }

  void editAllergy(int index) {
    TextEditingController controller =
        TextEditingController(text: allergy[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Allergy"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Allergy Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  allergy[index] = controller.text; // Update Allergy name
                });
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void addAllergy() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Allergy"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Allergy Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    allergy.add(controller.text);
                  });
                }
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAllergyData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Allergy"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Handle back button press
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allergy.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(30, 255, 255, 255),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      allergy[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => editAllergy(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.pink),
                          onPressed: () => deleteAllergy(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Handle save changes
                    _saveChanges();
                  },
                  child: const Text("Save Changes"),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: addAllergy,
                  child: const Text("Add New Allergy"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
