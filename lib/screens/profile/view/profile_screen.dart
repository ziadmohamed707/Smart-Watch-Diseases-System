import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
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
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/Ellipse 4.png'), // Replace with your image path
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () {
                      // Add camera functionality here
                    },
                    color: Colors.purple,
                    iconSize: 24,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Amera Ahmed',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
                        title: 'Chronic Diseases',
                        onTap: () {
                          context.push("/chronic_diseases_screen");
                        }),
                    ProfileOption(title: 'Drugs', onTap: () {}),
                    ProfileOption(title: 'Allergy', onTap: () {}),
                    ProfileOption(title: 'Note', onTap: () {}),
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

  const ProfileOption({
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
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white, fontSize: 16),
//       ),
//       trailing:
//           const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//       onTap: onTap,
//     );
//   }
// }
