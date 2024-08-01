<center>
<img src="https://readme-typing-svg.herokuapp.com?color=FFADD8E6&size=40&width=900&height=80&lines=Welcome+to+Remembron" />
</center>


## Table of Contents
- [Introduction](#-introduction)
- [Live Preview](#live-preview-)
- [Remembron Project](#intro-to-remembron-video)
- [Getting Started](#getting-started)
- [Resources](#resources)
- [Screenshots](#screenshots)
- [Key Features](#key-features)
- [Additional Features](#additional-features)
- [Tech Stack](#tech-stack)
- [About Us](#about-us)

## Remembron

## 💡 Introduction:

**Problem Statement**:  Individuals with Alzheimer's contend with daily tasks, memory lapses, and maintaining connections. Modern solutions lack personalized, automated features and raise privacy concerns. This initiative introduces an audio-visual app designed to address these issues, providing reminders, geopositioning and secure information storage.

**Solution**: Remembron is a comprehensive audio-visual app designed for individuals with Alzheimer’s, offering personalized reminders, geofencing, and guidance. The app features text-to-speech reminders, facial recognition, geofencing capabilities, and speech-to-text functionality to capture information from conversations, ensuring users receive the support they need in their daily lives.


## Live Preview-

**Download the APK:**

- [Remembron APK](https://mega.nz/file/lz8gSaiR#XACtghgstQIZl-s2Q9Y91iyFTSCbjtXEuXce8bA0W34)



# Remembron Project:

## Intro To Remembron Video

[Link to the Video](https://youtu.be/bUzlwzDEm48)



## Getting Started
Before running the project, make sure you have the necessary files downloaded:
1. **firebase_options.dart**: Located in the `lib` folder.
2. **google-services.json**: Located in the `android/app/` directory.

Note : This project requires a paid Google Maps API key; please **create your own API key** to use the project.


## Setup:

### For running it locally

```bash
git clone https://github.com/Nikhil-1426/Remembron
```
```bash
cd Remembron
```
```bash
flutter pub get
```
```bash
flutter run
```

## Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Figma](https://help.figma.com/hc/en-us)
- [Firebase Docs](https://firebase.google.com/docs)
  
# Screenshots
<pre>
<img src = "https://github.com/Nikhil-1426/Remembron/blob/main/assets/LoadingPage.jpg" width = "250">  <img src = "https://github.com/Nikhil-1426/Remembron/blob/main/assets/SignUpPage.jpg" width = "250">  <img src = "https://github.com/Nikhil-1426/Remembron/blob/main/assets/HomePage.jpg" width = "250">
<img src = "https://github.com/Nikhil-1426/Remembron/blob/main/assets/SettingsPage.jpg" width = "250">  <img src= "https://github.com/Nikhil-1426/Remembron/blob/main/assets/UserSetupPage.jpg" width = "250">  <img src = "https://github.com/Nikhil-1426/Remembron/blob/main/assets/GeoFencingPage.jpg" width = "250">
</pre>


## Key Features:
1. **Facial Recognition:**
   - Employs a machine learning convolutional neural network (CNN) model to identify and recognize familiar faces, aiding users in recognizing family and friends       even when Alzheimer's impairs their cognitive abilities.
2. **Geo-fencing:**
   - Sets up virtual boundaries around a specified home location. Alerts the user via text and audio notifications if they wander beyond these boundaries,             providing directions back home to ensure safety.
3. **Speech-to-Text (STT):**
   - Tracks daily conversations to identify key tasks and reminders. Converts spoken words into text to automatically create reminders for important tasks like         taking medications or attending appointments.
4. **Text-to-Speech (TTS):**
   - Delivers reminders and notifications through audio, ensuring that users receive timely verbal prompts for their daily activities and alerts if they cross
     geo-fenced boundaries.

## Additional Features:
- **Reminders:**
   - Allows users to create, edit, and delete daily reminders, which are updated in real-time and can be presented via text or speech.
- **User-Friendly Interface:**
   - Designed with simplicity and ease of use in mind, particularly catering to the elderly demographic who are most affected by Alzheimer's.
- **Secure Authentication:**
   - Uses Firebase Authentication for secure sign-up and sign-in processes.

## Tech Stack
1. **Flutter / Dart:**
   - Used for building a seamless, cross-platform mobile application with a user-friendly interface designed for individuals with Alzheimer's.
2. **Firebase:**
   - Stores user data, reminders, geofencing information, and facial recognition data, providing real-time synchronization and easy access.
3. **FireAuth:**
   - Provides secure user authentication and management, ensuring that user data remains protected.
4. **Google Maps API:**
   - Utilized for geo-fencing and providing directions, ensuring users stay within safe boundaries and can easily find their way back home.
5. **TensorFlow:**
   - Develops and trains the convolutional neural network (CNN) model for facial recognition, ensuring accurate and efficient identification.
6. **Gemini API:**
   - Processes and tracks reminders through the user's conversations.
7. **Figma:**
   - Used for designing and prototyping the app's user interface and user experience, ensuring a visually appealing and intuitive design.


# Hi, We are the makers of Remembron! 👋

## About us

Meet the creators behind Remembron – Arnav, Nikhil, Ninad, and Sharvin. We are a dedicated team driven by empathy and a shared commitment to making a difference in the lives of those navigating the challenges of Alzheimer's. Remembron is more than an app; it's a comforting companion on the Alzheimer's journey, designed for simplicity and user-friendly support. Our mission is clear: provide thoughtful assistance through easy navigation. With a focus on simplicity, Remembron offers a seamless, adaptable experience for users and caregivers, prioritizing privacy with secure local storage. Join us in creating a community where compassion and technology intersect, making every moment matter for those touched by Alzheimer's.

- Nikhil - [Nikhil Parkar](https://www.linkedin.com/in/nikhil-parkar-49b600274/)
- Sharvin - [Sharvin Joshi](https://www.linkedin.com/in/sharvin-joshi-33a57b290/)
- Arnav - [Arnav Parekar](https://linkedin.com/in/arnav-parekar-b55786287/)
- Ninad - [Ninad Mahajan](https://www.linkedin.com/in/ninad-mahajan-014a0b28b/)


## Happy coding 💯

Made with love ❤️
