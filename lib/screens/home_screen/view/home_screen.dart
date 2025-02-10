import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/profile/view/profile_screen.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/watchData/view/watch_data.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? WatchDataScreen() : ProfileScreen(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(50), // Adjust the radius as needed
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(AppConstants.primaryColor).withAlpha(230),
            selectedItemColor: Color(AppConstants.white),
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy pages (replace with your actual pages)
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Screen'));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen'));
  }
}
