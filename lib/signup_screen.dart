// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home_screen.dart';
// import 'signin_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController usernameController = TextEditingController();
//   bool _rememberMe = false;
//   bool _showPassword = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkRememberMeStatus();
//   }

//   Future<void> _checkRememberMeStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool rememberMe = prefs.getBool('rememberMe') ?? false;
//     if (rememberMe) {
//       // Automatically sign in the user if rememberMe is true
//       _signInUserFromLocalStorage();
//     }
//     setState(() {
//       _rememberMe = rememberMe;
//     });
//   }

//   Future<void> _signInUserFromLocalStorage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? email = prefs.getString('email');
//     String? password = prefs.getString('password');
//     if (email != null && password != null) {
//       try {
//         UserCredential userCredential =
//             await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );

//         // Navigate to the home screen after successful sign-in
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       } catch (e) {
//         print("Error during automatic sign-in: $e");
//         // Handle sign-in error if needed
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 223, 218, 218),
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(240, 44, 91, 91),
//         automaticallyImplyLeading: false,
//         title: Text(
//           "Sign Up",
//           style: TextStyle(color: Color.fromARGB(255, 223, 218, 218)),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/signup.png',
//                   height: 120,
//                 ),
//                 SizedBox(height: 25),
//                 buildTextField(
//                   label: 'Email',
//                   prefixIcon: Icons.email,
//                   controller: emailController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty || !value.contains('@')) {
//                       return 'Please enter a valid email address';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 buildTextField(
//                   label: 'Password',
//                   prefixIcon: Icons.lock,
//                   controller: passwordController,
//                   obscureText: !_showPassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _showPassword ? Icons.visibility : Icons.visibility_off,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _showPassword = !_showPassword;
//                       });
//                     },
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value.length < 6) {
//                       return 'Password must be at least 6 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 buildTextField(
//                   label: 'Username',
//                   prefixIcon: Icons.person,
//                   controller: usernameController,
//                   // Add any validation for the username as needed
//                 ),
//                 SizedBox(height: 15),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _rememberMe,
//                       onChanged: (value) {
//                         setState(() {
//                           _rememberMe = value ?? false;
//                         });
//                       },
//                     ),
//                     Text(
//                       "Remember me",
//                       style: TextStyle(color: Color.fromRGBO(2, 2, 2, 1), fontSize: 15),
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       try {
//                         UserCredential userCredential =
//                             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                           email: emailController.text,
//                           password: passwordController.text,
//                         );

//                         // Save rememberMe status and user credentials
//                         SharedPreferences prefs = await SharedPreferences.getInstance();
//                         prefs.setBool('rememberMe', _rememberMe);
//                         if (_rememberMe) {
//                           prefs.setString('email', emailController.text);
//                           prefs.setString('password', passwordController.text);
//                         }

//                         // Navigate to the home screen after successful sign-up
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomeScreen()),
//                         );
//                       } catch (e) {
//                         print("Error during sign up: $e");
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Sign-up failed. Please try again."),
//                           ),
//                         );
//                         print("Firebase Auth Error: $e");
//                       }
//                     }
//                   },
//                   child: Text(
//                     "Sign Up",
//                     style: TextStyle(color: Colors.black, fontSize: 15),
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 234, 170, 60)),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already a user?",
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SignInScreen()),
//                         );
//                       },
//                       child: Text(
//                         "Sign In",
//                         style: TextStyle(fontSize: 18, color:Color.fromARGB(240, 44, 91, 91)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField({
//     required String label,
//     required IconData prefixIcon,
//     required TextEditingController controller,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(prefixIcon),
//           suffixIcon: suffixIcon,
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'home_screen.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _rememberMe = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _checkRememberMeStatus();
  }

  Future<void> _checkRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      // Automatically sign in the user if rememberMe is true
      _signInUserFromLocalStorage();
    }
    setState(() {
      _rememberMe = rememberMe;
    });
  }

  Future<void> _signInUserFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    if (email != null && password != null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Navigate to the home screen after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        print("Error during automatic sign-in: $e");
        // Handle sign-in error if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 218, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        automaticallyImplyLeading: false,
        title: Text(
          "Sign Up",
          style: TextStyle(color: Color.fromARGB(255, 223, 218, 218)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/signup.png',
                  height: 120,
                ),
                SizedBox(height: 25),
                buildTextField(
                  label: 'Email',
                  prefixIcon: Icons.email,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                buildTextField(
                  label: 'Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                buildTextField(
                  label: 'Username',
                  prefixIcon: Icons.person,
                  controller: usernameController,
                  // Add any validation for the username as needed
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text(
                      "Remember me",
                      style: TextStyle(color: Color.fromRGBO(2, 2, 2, 1), fontSize: 15),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        UserCredential userCredential =
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        // Save the user's name in Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential.user!.uid)
                            .set({
                          'username': usernameController.text,
                          'email': emailController.text,
                        });

                        // Save rememberMe status and user credentials
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('rememberMe', _rememberMe);
                        if (_rememberMe) {
                          prefs.setString('email', emailController.text);
                          prefs.setString('password', passwordController.text);
                        }

                        // Navigate to the home screen after successful sign-up
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } catch (e) {
                        print("Error during sign up: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Sign-up failed. Please try again."),
                          ),
                        );
                        print("Firebase Auth Error: $e");
                      }
                    }
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 234, 170, 60)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a user?",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontSize: 18, color:Color.fromARGB(240, 44, 91, 91)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}
