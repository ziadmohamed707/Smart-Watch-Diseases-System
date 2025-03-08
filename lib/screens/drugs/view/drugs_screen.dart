import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/model/profile.dart';

class DrugsPage extends StatefulWidget {
  const DrugsPage({super.key});

  @override
  _DrugsPageState createState() => _DrugsPageState();
}

class _DrugsPageState extends State<DrugsPage> {
  final AuthRepository _authRepository = AuthRepository();
  late Profile profile = Profile();

  List<String> drugs = [];

  void deleteDrug(int index) {
    setState(() {
      drugs.removeAt(index);
    });
  }

  Future<void> _fetchDrugsData() async {
    try {
      String? token = TokenStorage.getToken();
      final jsonData = await _authRepository.fetchProfile(token!);
      setState(() {
        profile = Profile.fromJson(jsonData);
        drugs = splitString(profile.medications!);
        
      });
    } catch (e) {
      print('Error fetching drugs data: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      String? token = TokenStorage.getToken();
      final updatedProfile = {
        "medications": mergeStrings(drugs),
      };
      await _authRepository.updateProfile(token!, updatedProfile);
      print('drugs updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating drugs: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update drugs')),
      );
    }
  }

  List<String> splitString(String mergedString) {
    return mergedString.split("-"); // Splitting by space
  }

  String mergeStrings(List<String> strings) {
    return strings.join("-"); // Merge with space separator
  }

  
  void editDrug(int index) {
    TextEditingController controller =
        TextEditingController(text: drugs[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Drug"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Drug Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  drugs[index] = controller.text; // Update drug name
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

  void addDrug() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Drug"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Drug Name"),
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
                    drugs.add(controller.text);
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
    _fetchDrugsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drugs"),
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
              itemCount: drugs.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(30, 255, 255, 255),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      drugs[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => editDrug(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.pink),
                          onPressed: () => deleteDrug(index),
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
                  onPressed: addDrug,
                  child: const Text("Add New Drug"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
