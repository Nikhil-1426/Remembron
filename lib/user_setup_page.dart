import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSetupPage extends StatefulWidget {
  final Function(UserDetails) onDetailsUpdated;

  UserSetupPage({required this.onDetailsUpdated});

  @override
  _UserSetupPageState createState() => _UserSetupPageState();
}

class UserDetails {
  final String name;
  final int age;
  final String gender;
  final String address;
  final String imagePath;

  UserDetails({
    required this.name,
    required this.age,
    required this.gender,
    required this.address,
    required this.imagePath,
  });
}

class _UserSetupPageState extends State<UserSetupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  late SharedPreferences prefs;
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      ageController.text = prefs.getInt('age').toString();
      genderController.text = prefs.getString('gender') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      _selectedImagePath = prefs.getString('imagePath');

      // Ensure _selectedImagePath is set to null if it's an empty string
      if (_selectedImagePath == '') {
        _selectedImagePath = null;
      }
    });
  }

  _saveUserData() {
    prefs.setString('name', nameController.text);
    prefs.setInt('age', int.tryParse(ageController.text) ?? 0);
    prefs.setString('gender', genderController.text);
    prefs.setString('address', addressController.text);
    prefs.setString('imagePath', _selectedImagePath ?? '');

    UserDetails updatedDetails = UserDetails(
      name: nameController.text,
      age: int.tryParse(ageController.text) ?? 0,
      gender: genderController.text,
      address: addressController.text,
      imagePath: _selectedImagePath ?? '',
    );

    widget.onDetailsUpdated(updatedDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 218, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        title: Text("Details",
            style: TextStyle(
                color: Color.fromARGB(179, 251, 236, 236), fontSize: 22)),
                iconTheme : IconThemeData(
          color: Color.fromARGB(179, 251, 236, 236), // Set the back button color
        ),
        actions: [
          _buildCircularIconButton(Icons.home, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "User Data",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildProfileImage(),
              SizedBox(height: 10),
              _buildAddFaceOption(context),
              SizedBox(height: 20),
              _buildUserDetailsForm(),
              SizedBox(height: 20),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        _showAddFaceOptions(context);
      },
      child: Container(
        width: 150,
        height: 150,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: _buildProfileImageWidget(),
      ),
    );
  }

  Widget _buildProfileImageWidget() {
    if (_selectedImagePath != null) {
      return Image.file(
        File(_selectedImagePath!),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/newuser.png',
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }
  }

  void _showAddFaceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Add a Photo from Device'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              if (_selectedImagePath != null)
                ListTile(
                  leading: Icon(Icons.remove_circle),
                  title: Text('Remove Profile Picture'),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfilePicture();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddFaceOption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAddFaceOptions(context);
      },
      child: Text(
        "Add a face",
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.underline,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildUserDetailsForm() {
    return Column(
      children: [
        _buildInputField("Name", nameController, TextInputType.text),
        SizedBox(height: 10),
        _buildInputField("Age", ageController, TextInputType.number),
        SizedBox(height: 10),
        _buildInputField("Gender", genderController, TextInputType.text),
        SizedBox(height: 10),
        _buildInputField("Address", addressController, TextInputType.multiline),
      ],
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, TextInputType inputType) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(12),
      ),
      keyboardType: inputType,
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
        _saveUserData();
        print("Name: ${nameController.text}");
        print("Age: ${ageController.text}");
        print("Gender: ${genderController.text}");
        print("Address: ${addressController.text}");
      },
      child: Text("Update", style : TextStyle(color: Colors.black)), style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(210, 233, 175, 74)),
                ),
    );
  }

  void _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _pickImageFromCamera() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _removeProfilePicture() {
    setState(() {
      _selectedImagePath = null;
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: UserSetupPage(onDetailsUpdated: (UserDetails details) {
      // Implement your logic to handle the updated details
      print(
          'Details updated: ${details.name}, ${details.age}, ${details.gender}, ${details.address}, ${details.imagePath}');
    }),
  ));
}
