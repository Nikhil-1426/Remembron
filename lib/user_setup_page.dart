// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/SettingsPage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geocoding/geocoding.dart'; // Add geocoding package
// import 'home_screen.dart';
//
// class UserSetupPage extends StatefulWidget {
//   final Function(UserDetails) onDetailsUpdated;
//
//   UserSetupPage({required this.onDetailsUpdated});
//
//   @override
//   _UserSetupPageState createState() => _UserSetupPageState();
// }
//
// class UserDetails {
//   final String name;
//   final int age;
//   final String gender;
//   final String address;
//   final String imagePath;
//   final String coordinates; // Add coordinates field
//
//   UserDetails({
//     required this.name,
//     required this.age,
//     required this.gender,
//     required this.address,
//     required this.imagePath,
//     required this.coordinates, // Add coordinates field
//   });
// }
//
// class _UserSetupPageState extends State<UserSetupPage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController genderController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController coordinatesController = TextEditingController(); // Add coordinates controller
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ImagePicker _imagePicker = ImagePicker();
//   String? _selectedImagePath;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   _loadUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//             DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         var data = userDoc.data() as Map<String, dynamic>;
//         setState(() {
//           nameController.text = data['name'] ?? '';
//           ageController.text = data['age'].toString() ?? '';
//           genderController.text = data['gender'] ?? '';
//           addressController.text = data['address'] ?? '';
//           coordinatesController.text = data['coordinates'] ?? ''; // Load coordinates
//           _selectedImagePath = data['imagePath']?.isNotEmpty == true ? data['imagePath'] : null;
//         });
//       }
//     }
//   }
//
//   Future<void> _getCoordinatesFromAddress(String address) async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         final location = locations.first;
//         setState(() {
//           coordinatesController.text = '${location.latitude}, ${location.longitude}';
//         });
//       } else {
//         setState(() {
//           coordinatesController.text = 'Coordinates not found';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         coordinatesController.text = 'Error retrieving coordinates';
//       });
//     }
//   }
//
//   _saveUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       // Get the user's document reference
//       DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
//
//       // Prepare the data to update
//       Map<String, dynamic> updatedData = {
//         'name': nameController.text,
//         'age': int.tryParse(ageController.text) ?? 0,
//         'gender': genderController.text,
//         'address': addressController.text,
//         'imagePath': _selectedImagePath ?? '',
//         'coordinates': coordinatesController.text, // Save coordinates
//       };
//
//       // Update the user's document with the new data
//       await userDocRef.update(updatedData);
//
//       UserDetails updatedDetails = UserDetails(
//         name: nameController.text,
//         age: int.tryParse(ageController.text) ?? 0,
//         gender: genderController.text,
//         address: addressController.text,
//         imagePath: _selectedImagePath ?? '',
//         coordinates: coordinatesController.text, // Include coordinates
//       );
//
//       widget.onDetailsUpdated(updatedDetails);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 223, 218, 218),
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(240, 44, 91, 91),
//         title: Text("Details",
//             style: TextStyle(
//                 color: Color.fromARGB(179, 251, 236, 236), fontSize: 22)),
//         iconTheme: IconThemeData(
//           color: Color.fromARGB(179, 251, 236, 236),
//         ),
//         actions: [
//           _buildCircularIconButton(Icons.home, () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomeScreen(),
//               ),
//             );
//           }),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 "User Data",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),
//               _buildProfileImage(),
//               SizedBox(height: 10),
//               _buildAddFaceOption(context),
//               SizedBox(height: 20),
//               _buildUserDetailsForm(),
//               SizedBox(height: 20),
//               _buildUpdateButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCircularIconButton(IconData icon, VoidCallback onPressed) {
//     return Padding(
//       padding: EdgeInsets.only(right: 12),
//       child: GestureDetector(
//         onTap: onPressed,
//         child: Container(
//           width: 35,
//           height: 35,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Color.fromARGB(179, 251, 236, 236),
//               width: 2,
//             ),
//           ),
//           child: Center(
//             child: Icon(
//               icon,
//               size: 20,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileImage() {
//     return GestureDetector(
//       onTap: () {
//         _showAddFaceOptions(context);
//       },
//       child: Container(
//         width: 150,
//         height: 150,
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           border: Border.all(
//             color: Colors.black,
//             width: 2,
//           ),
//         ),
//         child: _buildProfileImageWidget(),
//       ),
//     );
//   }
//
//   Widget _buildProfileImageWidget() {
//     if (_selectedImagePath != null) {
//       return Image.file(
//         File(_selectedImagePath!),
//         width: 120,
//         height: 120,
//         fit: BoxFit.cover,
//       );
//     } else {
//       return Image.asset(
//         'assets/newuser.png', // Default image path
//         width: 120,
//         height: 120,
//         fit: BoxFit.cover,
//       );
//     }
//   }
//
//   void _showAddFaceOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera),
//                 title: Text('Open Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImageFromCamera();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo),
//                 title: Text('Add a Photo from Device'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage();
//                 },
//               ),
//               if (_selectedImagePath != null)
//                 ListTile(
//                   leading: Icon(Icons.remove_circle),
//                   title: Text('Remove Profile Picture'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _removeProfilePicture();
//                   },
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildAddFaceOption(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _showAddFaceOptions(context);
//       },
//       child: Text(
//         "Add a face",
//         style: TextStyle(
//           color: Colors.black,
//           decoration: TextDecoration.underline,
//           fontSize: 18,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserDetailsForm() {
//     return Column(
//       children: [
//         _buildInputField("Name", nameController, TextInputType.text),
//         SizedBox(height: 10),
//         _buildInputField("Age", ageController, TextInputType.number),
//         SizedBox(height: 10),
//         _buildInputField("Gender", genderController, TextInputType.text),
//         SizedBox(height: 10),
//         _buildInputField("Address", addressController, TextInputType.multiline),
//         SizedBox(height: 10),
//         _buildInputField("Coordinates", coordinatesController, TextInputType.text, readOnly: true), // Add coordinates field
//       ],
//     );
//   }
//
//   Widget _buildInputField(
//       String label, TextEditingController controller, TextInputType inputType, {bool readOnly = false}) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.all(12),
//       ),
//       keyboardType: inputType,
//       readOnly: readOnly,
//     );
//   }
//
//   Widget _buildUpdateButton() {
//     return ElevatedButton(
//       onPressed: () async {
//         // Fetch coordinates based on the address input
//         await _getCoordinatesFromAddress(addressController.text);
//         await _saveUserData(); // Save user data
//
//         // Navigate to HomeScreen after saving user data
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SettingsPage(),
//           ),
//         );
//       },
//       child: Text("Update", style: TextStyle(color: Colors.black)),
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(
//             Color.fromARGB(210, 233, 175, 74)),
//       ),
//     );
//   }
//
//   void _pickImage() async {
//     final XFile? image =
//         await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _selectedImagePath = image.path;
//       });
//     }
//   }
//
//   void _pickImageFromCamera() async {
//     final XFile? image =
//         await _imagePicker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         _selectedImagePath = image.path;
//       });
//     }
//   }
//
//   void _removeProfilePicture() {
//     setState(() {
//       _selectedImagePath = null;
//     }); // Save changes to Firestore
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart'; // Add geocoding package
import 'home_screen.dart';

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
  final String coordinates; // Add coordinates field

  UserDetails({
    required this.name,
    required this.age,
    required this.gender,
    required this.address,
    required this.imagePath,
    required this.coordinates, // Add coordinates field
  });
}

class _UserSetupPageState extends State<UserSetupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController coordinatesController = TextEditingController(); // Add coordinates controller

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? '';
          ageController.text = data['age'].toString() ?? '';
          genderController.text = data['gender'] ?? '';
          addressController.text = data['address'] ?? '';
          coordinatesController.text = data['coordinates'] ?? ''; // Load coordinates
          _selectedImagePath = data['imagePath']?.isNotEmpty == true ? data['imagePath'] : null;
        });
      }
    }
  }

  Future<void> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        setState(() {
          coordinatesController.text = '${location.latitude}, ${location.longitude}';
        });
      } else {
        setState(() {
          coordinatesController.text = 'Coordinates not found';
        });
      }
    } catch (e) {
      setState(() {
        coordinatesController.text = 'Error retrieving coordinates';
      });
      print("Error in fetching coordinates: $e");
    }
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Get the user's document reference
      DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

      // Prepare the data to update
      Map<String, dynamic> updatedData = {
        'name': nameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'gender': genderController.text,
        'address': addressController.text,
        'imagePath': _selectedImagePath ?? '',
        'coordinates': coordinatesController.text, // Save coordinates
      };

      try {
        // Update the user's document with the new data
        await userDocRef.set(updatedData, SetOptions(merge: true));

        UserDetails updatedDetails = UserDetails(
          name: nameController.text,
          age: int.tryParse(ageController.text) ?? 0,
          gender: genderController.text,
          address: addressController.text,
          imagePath: _selectedImagePath ?? '',
          coordinates: coordinatesController.text, // Include coordinates
        );

        widget.onDetailsUpdated(updatedDetails);

        // Log successful save
        print("User data saved successfully");

      } catch (e) {
        // Log any errors
        print("Failed to save user data: $e");
      }
    } else {
      print("No authenticated user found");
    }
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
        iconTheme: IconThemeData(
          color: Color.fromARGB(179, 251, 236, 236),
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
        'assets/newuser.png', // Default image path
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
        SizedBox(height: 10),
        _buildInputField("Coordinates", coordinatesController, TextInputType.text, readOnly: true), // Read-only coordinates
      ],
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, TextInputType keyboardType,
      {bool readOnly = false}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () async {
        // Fetch coordinates based on the address input
        await _getCoordinatesFromAddress(addressController.text);
        _saveUserData(); // Save user data

        // Only navigate if save is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      },
      child: Text("Update", style: TextStyle(color: Colors.black)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            Color.fromARGB(210, 233, 175, 74)),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  void _removeProfilePicture() {
    setState(() {
      _selectedImagePath = null;
    });
  }
}
