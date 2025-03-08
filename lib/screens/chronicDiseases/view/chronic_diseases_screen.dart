import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/model/profile.dart';

class ChronicDiseasesPage extends StatefulWidget {
  const ChronicDiseasesPage({super.key});

  @override
  _ChronicDiseasesPageState createState() => _ChronicDiseasesPageState();
}

class _ChronicDiseasesPageState extends State<ChronicDiseasesPage> {
 final AuthRepository _authRepository = AuthRepository();
  late Profile profile = Profile();
  late List<String> diseases = [];

  
  Future<void> _fetchDiseasesData() async {
    try {
      String? token = TokenStorage.getToken();
      final jsonData = await _authRepository.fetchProfile(token!);
      setState(() {
        profile = Profile.fromJson(jsonData);
        diseases = splitString(profile.chronicDiseases!);
        
      });
    } catch (e) {
      print('Error fetching diseases data: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      String? token = TokenStorage.getToken();
      final updatedProfile = {
        "chronic_diseases": mergeStrings(diseases),
      };
      await _authRepository.updateProfile(token!, updatedProfile);
      print('diseases updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating diseases: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update diseases')),
      );
    }
  }

  List<String> splitString(String mergedString) {
    return mergedString.split("-"); // Splitting by space
  }

  String mergeStrings(List<String> strings) {
    return strings.join("-"); // Merge with space separator
  }

  void deleteDisease(int index) {
    setState(() {
      diseases.removeAt(index);
    });
  }

  void editDisease(int index) {
    TextEditingController controller =
        TextEditingController(text: diseases[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Disease"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Disease Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  diseases[index] = controller.text; // Update disease name
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

  void addDisease() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Disease"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Disease Name"),
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
                    diseases.add(controller.text);
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
    _fetchDiseasesData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chronic Diseases"),
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
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(30, 255, 255, 255),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      diseases[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => editDisease(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.pink),
                          onPressed: () => deleteDisease(index),
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
                  onPressed: addDisease,
                  child: const Text("Add New Disease"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
