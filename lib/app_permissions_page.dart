import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class PermissionManager {
  factory PermissionManager() => _instance;

  PermissionManager._internal();

  static final PermissionManager _instance = PermissionManager._internal();

  bool cameraPermission = false;
  bool microphonePermission = false;
  bool filesPermission = false;
  bool locationPermission = false;
  bool contactsPermission = false;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cameraPermission = prefs.getBool('cameraPermission') ?? false;
    microphonePermission = prefs.getBool('microphonePermission') ?? false;
    filesPermission = prefs.getBool('filesPermission') ?? false;
    locationPermission = prefs.getBool('locationPermission') ?? false;
    contactsPermission = prefs.getBool('contactsPermission') ?? false;
  }

  Future<void> setPermission(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}

class AppPermissionsPage extends StatefulWidget {
  @override
  _AppPermissionsPageState createState() => _AppPermissionsPageState();
}

class _AppPermissionsPageState extends State<AppPermissionsPage> {
  PermissionManager permissionManager = PermissionManager();

  @override
  void initState() {
    super.initState();
    permissionManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 218, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),  
        title: Text("App Permissions" , style: TextStyle(color: Color.fromARGB(179, 251, 236, 236), fontSize: 22)),
        iconTheme : IconThemeData(
          color: Color.fromARGB(179, 251, 236, 236), // Set the back button color
        ),
        actions: [
          _buildCircularIconButton(Icons.home, () {
            // Navigate to the home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPermissionItem("Camera", permissionManager.cameraPermission,
                (value) {
              _requestPermission(Permission.camera, value, () {
                setState(() {
                  permissionManager.cameraPermission = value;
                });
                permissionManager.setPermission('cameraPermission', value);
              });
            }),
            _buildPermissionItem(
                "Microphone", permissionManager.microphonePermission, (value) {
              _requestPermission(Permission.microphone, value, () {
                setState(() {
                  permissionManager.microphonePermission = value;
                });
                permissionManager.setPermission('microphonePermission', value);
              });
            }),
            _buildPermissionItem("Files", permissionManager.filesPermission,
                (value) {
              _requestPermission(Permission.storage, value, () {
                setState(() {
                  permissionManager.filesPermission = value;
                });
                permissionManager.setPermission('filesPermission', value);
              });
            }),
            _buildPermissionItem(
                "Location", permissionManager.locationPermission, (value) {
              _requestPermission(Permission.location, value, () {
                setState(() {
                  permissionManager.locationPermission = value;
                });
                permissionManager.setPermission('locationPermission', value);
              });
            }),
            _buildPermissionItem(
                "Contacts", permissionManager.contactsPermission, (value) {
              _requestPermission(Permission.contacts, value, () {
                setState(() {
                  permissionManager.contactsPermission = value;
                });
                permissionManager.setPermission('contactsPermission', value);
              });
            }),
            // Add more permission items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      value: value,
      onChanged: (newValue) {
        if (newValue) {
          _showPermissionDialog(title, onChanged);
        } else {
          onChanged(newValue);
        }
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Future<void> _showPermissionDialog(
    String permissionTitle, ValueChanged<bool> onChanged) async {
  bool? isPermissionGranted = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Permission Required"),
        content: Text("Do you want to allow $permissionTitle access?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Deny"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Allow"),
          ),
        ],
      );
    },
  );

  onChanged(isPermissionGranted ?? false);
}


  Widget _buildCircularIconButton(IconData icon, VoidCallback onPressed) {
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
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermission(Permission permission, bool value,
      VoidCallback onPermissionGranted) async {
    final status = await permission.request();

    if (status == PermissionStatus.granted) {
      onPermissionGranted();
    } else {
      // If the status is denied, show a permission request dialog
      if (await permission.isDenied) {
        await permission.request();
      }

      // Check the permission status again after the dialog is shown
      final updatedStatus = await permission.status;

      if (updatedStatus == PermissionStatus.granted) {
        onPermissionGranted();
      } else {
        // Permission not granted, revert the switch value
        setState(() {
          value = !(updatedStatus == PermissionStatus.denied);
        });
      }
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AppPermissionsPage(),
  ));
}


