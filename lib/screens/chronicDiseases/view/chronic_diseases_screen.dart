import 'package:flutter/material.dart';

class ChronicDiseasesPage extends StatefulWidget {
  @override
  _ChronicDiseasesPageState createState() => _ChronicDiseasesPageState();
}

class _ChronicDiseasesPageState extends State<ChronicDiseasesPage> {
  final List<String> diseases = [
    "Diabetes",
    "Diabetes",
    "Diabetes",
    "Diabetes"
  ];

  void deleteDisease(int index) {
    setState(() {
      diseases.removeAt(index);
    });
  }

  void editDisease(int index) {
    // Add your edit logic here
  }

  void addDisease() {
    setState(() {
      diseases.add("New Disease");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chronic Diseases"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
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
                  color: Color.fromARGB(30, 255, 255, 255),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      diseases[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.pink),
                          onPressed: () => deleteDisease(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => editDisease(index),
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
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Handle save changes
                  },
                  child: Text("Save Changes"),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: addDisease,
                  child: Text("Add New Disease"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
