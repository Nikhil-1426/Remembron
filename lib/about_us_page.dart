import 'package:flutter/material.dart';
import 'home_screen.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 218, 218),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(240, 44, 91, 91),
        title: Text("About Us" , style: TextStyle(color: Color.fromARGB(179, 251, 236, 236), fontSize: 22)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Remembron!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Meet the creators behind Remembron – Arnav, Nikhil, Ninad, and Sharvin. We are a dedicated team driven by empathy and a shared commitment to making a difference in the lives of those navigating the challenges of Alzheimer's. Remembron is more than an app; it's a comforting companion on the Alzheimer's journey, designed for simplicity and user-friendly support. Our mission is clear: provide thoughtful assistance through easy navigation. With a focus on simplicity, Remembron offers a seamless, adaptable experience for users and caregivers, prioritizing privacy with secure local storage. Join us in creating a community where compassion and technology intersect, making every moment matter for those touched by Alzheimer's.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              "Contact Information:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Email: your@email.com",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Phone: +91 (123) 456-7890",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Follow Us:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildSocialMediaIcon(Icons.facebook, "Facebook"),
                /* _buildSocialMediaIcon(Icons.twitter, "Twitter"),
                _buildSocialMediaIcon(Icons.instagram, "Instagram"), */
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildCircularIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.only(right: 12), // Adjust the right padding as needed
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
}
