# Reddit-Clone

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Reddit-Clone is a Flutter application that replicates the popular social media platform Reddit. It utilizes Riverpod 2.0 for state management, Firebase for backend services and authentication/login.

- [Riverpod 2.0](https://riverpod.dev/): Riverpod is a simple yet powerful state management library for Flutter, designed to be easy to use and understand.

- [Firebase](https://firebase.google.com/): Firebase provides a comprehensive suite of backend services, including authentication and a real-time database, making it a perfect fit for building modern mobile and web applications.

## Features

- Material You design theme: Reddit-Clone incorporates the Material You design theme, which allows for a customizable and visually appealing user interface. Learn more about [Material You](https://material.io/design/material-you).

- Google/Guest Authentication: Users can authenticate via Google sign-in or as a guest.

- Create/Join Community (Subreddits): Users can create and join communities based on their interests, enabling them to connect with like-minded individuals.

- Community Profile: Each community has its own profile page, displaying information such as the community description and banner.

- Edit Description and Banner of Community: Community moderators can edit the description and banner image of their communities, allowing for customization and personalization.

- Make New Posts: Users can create new posts within the communities they are a part of, initiating discussions and sharing content.

- Display Posts from Joined Communities: The app displays posts only from the communities the user is a member of, ensuring a personalized and relevant feed.

- Upvote and Downvote: Users can express their opinion on posts by upvoting or downvoting them, contributing to the post's popularity.

- Comments: Users can engage in discussions by leaving comments on posts, fostering conversations and interactions within the community.

- Awarding the Post: Reddit-Clone allows users to award posts, acknowledging and appreciating quality content.

- Karma System: Users earn karma points based on their activity and contributions, reflecting their reputation within the community.

- Adding Moderators for Communities: Community owners can add moderators to assist in managing and maintaining the community.

- Delete Posts: Community moderators and post creators can delete posts, ensuring content moderation and community guidelines adherence.

- User Profile: Each user has a profile page showcasing their activity, posts, and karma points.

- Edit User Profile: Users can edit their profile information, including their profile picture and bio.

- Browsing All Communities: Users can explore and discover various communities based on their interests, expanding their network and interactions.

## Screenshots

![Screenshot 1](screenshots/screenshot1.png)
![Screenshot 2](screenshots/screenshot2.png)
![Screenshot 3](screenshots/screenshot3.png)
![Screenshot 4](screenshots/screenshot4.png)
![Screenshot 5](screenshots/screenshot5.png)
![Screenshot 6](screenshots/screenshot6.png)
![Screenshot 7](screenshots/screenshot7.png)
![Screenshot 8](screenshots/screenshot8.png)

## Installation

After cloning this repository, navigate to the `flutter-reddit-clone` folder. Then, follow these steps:

1. Create a Firebase project.
2. Enable authentication methods such as Google Sign-In and Guest Sign-In.
3. Configure Firestore rules to secure your database.
4. Create Android and iOS apps in the Firebase project.
5. Use the FlutterFire CLI to add the Firebase project to this app.

Finally, run the following commands to start the app:

```bash
flutter pub get
open -a simulator
"# Reddit-clone" 
