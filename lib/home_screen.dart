import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/user_setup_page.dart';
import 'SettingsPage.dart';
import 'RecognizePage.dart';
import 'ConvLogPage.dart';
import 'GeoFencingPage.dart';
import 'signup_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();

  void showDetailsUploadedNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Details uploaded successfully'),
      ),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  int _userAge = 0;
  String _userGender = '';

  // @override
  HomeScreenState createState() => HomeScreenState();

  // void showDetailsUploadedNotification(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Details uploaded successfully'),
  //     ),
  //   );
  // }

        void _loadUserDetails() {
        // Initialize Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Get user ID (e.g., from FirebaseAuth)
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Set up a listener for real-time updates
        firestore.collection('users').doc(userId).snapshots().listen((documentSnapshot) {
          if (documentSnapshot.exists) {
            // Extract user details
            var userData = documentSnapshot.data() as Map<String, dynamic>;

            setState(() {
              _userName = userData['name'] ?? '';
              _userAge = userData['age'] ?? 0;
              _userGender = userData['gender'] ?? '';
              // Assuming profile picture URL is stored under 'profilePicture'
            });
          }
        });
      }




  double iconSize = 83.0; // Initial icon size, you can adjust as needed
  List<Map<String, String>> reminders = [
    {"time": "8:00 AM", "description": "Meeting"},
    {"time": "1:00 PM", "description": "Lunch"},
    {"time": "6:30 PM", "description": "Gym"},
    {"time": "10:00 PM", "description": "Read"},
    {"time": "11:00 PM", "description": "Sleep"}
    // Add more reminders as needed
  ];

  void _handleDetailsUpdated(UserDetails updatedDetails) {
    // Handle UI update or any other action after details are updated
    // For example, you can reload the user details and update the UI.
    print("Updated Details: $updatedDetails");
  }

  @override
  void initState() {
    super.initState();
    _retrieveRemindersFromSharedPreferences();
    _loadUserDetails();
    _checkUserSetup();
  }

    void _checkUserSetup() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      bool isSetupComplete = userData['setupComplete'] ?? false;

      if (!isSetupComplete) {
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Your Details'),
                content: Text('Please update your details in Settings -> User Details.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ),
                      );
                    },
                    child: Text('Go to Settings'),
                  ),
                ],
              );
            },
          );
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Color.fromARGB(240, 44, 91, 91),
          ),
        ),
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 223, 218, 218),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Remembron",
                        style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(179, 251, 236, 236)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(179, 220, 139, 67),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "Nurturing Memories, Empowering Journeys",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(179, 251, 236, 236),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            toolbarHeight: 110,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                      child: _buildCircularIconButton(
                        Icons.settings,
                        "Settings",
                        () {
                          // Navigate to the Settings page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ),
                          );
                        },
                        iconSize: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    _buildCircularIconButton(Icons.logout, "Sign Out", () {
                      // Navigate to the home page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    }, iconSize: 20),
                  ],
                ),
                SizedBox(height: 10),
                _buildSectionTitle("User Details"),
                SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/user.webp'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserInfo("User Name :", _userName),
                        _buildUserInfo("Age :", _userAge.toString()),
                        _buildUserInfo("Gender :", _userGender),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                _buildRemindersSection(context),
                SizedBox(height: 30),
                _buildSectionTitle("Features"),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeatureWithBorder(
                        "Recognize", "assets/recognize(2).png", () {
                      // Navigate to the Recognize page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecognizePage(),
                        ),
                      );
                    }),
                    SizedBox(width: 3), // Adjust the gap here
                    _buildFeatureWithBorder("Conv Log", "assets/convlog.png",
                        () {
                      // Navigate to the ConvLog page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConvLogPage(),
                        ),
                      );
                    }),
                    SizedBox(width: 3), // Adjust the gap here
                    _buildFeatureWithBorder(
                        "Geo Fencing", "assets/geofence.jpg", () {
                      // Navigate to the GeoFencing page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GeoFencingPage(),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildCircularIconButton(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    double iconSize = 30,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(String title, String value) {
    return Text(
      "$title $value",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionTitleWithAdd(String title, VoidCallback onAddPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle(title),
        GestureDetector(
          onTap: onAddPressed,
          child: Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 4),
              Text("Add"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeature(String name, String imagePath, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Image.asset(
            imagePath,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(name),
      ],
    );
  }

  Widget _buildFeatureWithBorder(
      String name, String imagePath, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(name),
      ],
    );
  }

  Widget _buildReminderBox(
      BuildContext context, String time, String description,
      {Color textColor = Colors.orangeAccent}) {
    return GestureDetector(
      onTap: () {
        _showReminderOptionsDialog(context, time, description);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(210, 233, 175, 74),
          // color: Color.fromARGB(255, 184, 189, 183),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderOptionsDialog(
      BuildContext context, String time, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reminder Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Time: $time'),
              Text('Description: $description'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _editReminder(context, time, description);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  _removeReminder(context, time, description);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20), // Adjust the padding as needed
                ),
                child: Text('Remove'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editReminder(BuildContext context, String time, String description) {
    TextEditingController timeController = TextEditingController(text: time);
    TextEditingController descriptionController =
        TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _applyEditReminder(
                    context,
                    time,
                    description,
                    timeController.text,
                    descriptionController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeReminder(BuildContext context, String time, String description) {
    setState(() {
      reminders.removeWhere((reminder) =>
          reminder["time"] == time && reminder["description"] == description);
    });

    _saveRemindersToSharedPreferences();
    Navigator.pop(context); // Save reminders to shared preferences
  }

  Widget _buildRemindersSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleWithAdd("Reminders", () {
          // Function to handle adding reminders
          _showAddReminderDialog(context);
        }),
        SizedBox(height: 7),
        Container(
          height: 155,
          child: ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, String> reminder = reminders[index];
              return _buildReminderBox(
                  context, reminder["time"]!, reminder["description"]!,
                  textColor: Color.fromARGB(235, 9, 9, 9));
            },
          ),
        ),
      ],
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    TextEditingController timeController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addReminder(
                    context,
                    timeController.text,
                    descriptionController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyEditReminder(BuildContext context, String oldTime,
      String oldDescription, String newTime, String newDescription) {
    setState(() {
      reminders.removeWhere((reminder) =>
          reminder["time"] == oldTime &&
          reminder["description"] == oldDescription);
      reminders.add({"time": newTime, "description": newDescription});

      // Sort reminders based on time
      reminders.sort((a, b) {
        final aTime = a["time"];
        final bTime = b["time"];
        if (aTime != null && bTime != null) {
          return DateFormat('hh:mm a').parse(aTime).compareTo(
                DateFormat('hh:mm a').parse(bTime),
              );
        } else {
          return 0;
        }
      });
    });

    _saveRemindersToSharedPreferences(); // Save reminders to shared preferences
    // Show snackbar, etc.
    Navigator.pop(context);
    Navigator.pop(context);

    // Navigate back to the home page after a short delay

    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

// Method to save reminders to shared preferences
  void _saveRemindersToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminders', jsonEncode(reminders));
  }

// Method to retrieve reminders from shared preferences
  Future<void> _retrieveRemindersFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? remindersJson = prefs.getString('reminders');
    if (remindersJson != null) {
      setState(() {
        reminders = List<Map<String, String>>.from(
            jsonDecode(remindersJson).map((x) => Map<String, String>.from(x)));
      });
    }
  }

  void _addReminder(BuildContext context, String time, String description) {
    if (time.isNotEmpty && description.isNotEmpty) {
      setState(() {
        reminders.add({"time": time, "description": description});

        // Sort reminders based on time
        reminders.sort((a, b) {
          final aTime = a["time"];
          final bTime = b["time"];
          if (aTime != null && bTime != null) {
            return DateFormat('hh:mm a').parse(aTime).compareTo(
                  DateFormat('hh:mm a').parse(bTime),
                );
          } else {
            return 0;
          }
        });
      });

      _saveRemindersToSharedPreferences(); // Save reminders to shared preferences
      // Show snackbar, etc.
    } else {
      showSnackBar(context, 'Please fill out all fields');
    }
    Navigator.pop(context);
  }
}
