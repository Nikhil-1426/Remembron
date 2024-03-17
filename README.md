# Remembron
DevsHouse'24 Project

## What is Remembron? 
We noticed that as of 15th March 2023, more than 55 million people have Dementia. More so, the cause for nearly 70% of those cases was diagnosed to be Alzheimer's Disease. The symptoms of this condition include:
-  Forgetting things and recent events often
-  Getting lost while walking or driving
-  Being unable to identify familiar people or environments
-  Unable to follow conversations 

This lead to birth of the idea of Remembron, an app focused to assist people who are suffering from Alzhiemer's using intuitive methods which include Facial Recognition, Geo-fencing, Audio tracking using Speech-to-Text (STT) and Reminders using Text-to-Speech (TTS). So as to help them overcome the difficulties faced due to their condition in day to day life and be their virtual caretaker.

## Features (Why Remembron?)

### Facial Recognition

Alzheimer's Disease is a condition which is known to affect one's mental and cognitive abilities, sometimes even in a manner that leads them to forget about the one's closest to them, their families and friends. In order to assist and guide one if such a scenario were to occur we have incorporated a Facial Recognition feature which identifies the person's face shown to it and their relation to the user (if any) and tells the user about the same.

So how did we do it?
We created a machine learning _convolutional neural network(CNN)_ model which identifies and compares images and lets the user know their realtion to the person whose picture it is. The model gets live trained by the video input given by the user and uses it for prediction. The video gets broken down frame by frame and the facial information is extracted from it by using _Haar Cascade_. The model trains itself on this data.

### Geo-fencing

As mentioned before, the cognitive abilities of a person having Alzheimer's gets affected leading them to forget their surrounding and even their way home when they are on a walk outside. This can cause them to end up even wandering somewhere unkown or potentially dangerous to them. For the prevention of such a scenario, we have used geo-fencing, i.e, we have set a home location and created 2 boundaries(or fences) of differing radius around it to act as a safeguard for them.

-  The inner and outer fences radius can be specified by the user.
-  Upon passing out of the inner fence the user gets a message in the text format and TTS format as well. Once they pass the outer fence as well they begin to get
  a notification as well the directions for them to head home on the app.
-  We used IP tracking for Geolocation of the user which was achieved by using the API _ipgeolocation_.

### UI & UX

Statistically, in 2023 in America itself 73% of the cases of Alzheiemer's have occured to people of ages 75 and older. This number increases exponentially globally in regards to the people who are at the higher end of the age spectrum. Keeping this in mind, we have incorporated a simple and easy to use UI and UX for them so as to give them the ease of using the app.

**Salient Features:**
- With the help of FireAuthentication for Sign up and Sign in, we have created a secure access to the app.
- The frontend has been entirely constructed using Flutter/Dart. Meanwhile, the backend is composed of a Node.js server which sends requests(APIs) to fetch media data using python scripts which is then saved on firebase_admin and google cloud.
- Includes a reminder's scroll list which is mutable i.e we can add, edit or remove the reminders. (Daily reminders update real time).

### Speech to Text(STT) and Text to Speech(TTS)

Alzheimer's leads to people forgetting even the most minute tasks which they usually do in their day to day life. They often need to be reminded of the tasks they do daily like having timely meals, taking their medicines on time and so on. The caretaker or a family member of the user usually reminds them about these tasks verbally but there come times when they themselves have different things to attend to and they can't pay that much attention to the user who himself can forget about the verbal reminders. 

So, We have implemented a STT algorithm which detects the conversations that the user goes through daily and tracks down keywords in those conversations and creates files containing the conversations revolving around those keywords(like medicine or meeting) which theselves get integrated as a reminder if the content of the conversation was regarding that.

These reminders along with all the other reminds and many other features are interacted with the user using TTS, i.e giving him the verbal reminder of the usual tasks and if he crosses the geo-fence.


