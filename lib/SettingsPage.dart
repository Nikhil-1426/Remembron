import 'package:flutter/material.dart';
import 'user_setup_page.dart';
import 'app_permissions_page.dart';
import 'help_centre_page.dart';
import 'terms_and_conditions_page.dart';
import 'about_us_page.dart';
import 'home_screen.dart';

class SettingsPage extends StatelessWidget {
  final HomeScreen homeScreenInstance = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 218, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        title: Text("Settings",
            style: TextStyle(
                color: Color.fromARGB(179, 251, 236, 236), fontSize: 22)),
                iconTheme : IconThemeData(
          color: Color.fromARGB(179, 251, 236, 236), // Set the back button color
        ),
        actions: [
          _buildCircularIconButton(Icons.home, () {
            // Navigate to the user setup page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }, iconColor: Color.fromARGB(179, 251, 236, 236)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/user.webp'),
                ),
                SizedBox(width: 12),
                // Your user details or settings can go here
              ],
            ),
            SizedBox(height: 16),
            _buildSettingItem("User Setup", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserSetupPage(
                          onDetailsUpdated: (UserDetails updatedDetails) {
                            print(
                                "Updated details received in SettingsPage: $updatedDetails");
                            homeScreenInstance
                                .showDetailsUploadedNotification(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                        )),
              );
            }),
            _buildSettingItem("App Permissions", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppPermissionsPage()),
              );
            }),
            _buildSettingItem("Help Centre", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpCentrePage()),
              );
            }),
            _buildSettingItem("Terms and Conditions", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TermsAndConditionsPage()),
              );
            }),
            _buildSettingItem("About Us", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(210, 233, 175, 74),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIconButton(IconData icon, VoidCallback onPressed,
      {Color iconColor = Colors.black}) {
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color.fromARGB(179, 251, 236, 236),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: iconColor, // Set the icon color
            ),
          ),
        ),
      ),
    );
  }
}
