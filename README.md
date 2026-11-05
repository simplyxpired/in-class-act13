# firebase_auth_app

# In-Class Activity 13 - Firebase Authentication

This is my Flutter app for In-Class Activity 13. I used Firebase Authentication so a user can make an account, log in, change their password, and sign out.

## What the app does

- Create an account using an email and password
- Log in with an existing account
- Show the user's email on the profile screen
- Change the password while logged in
- Sign out and return to the login screen
- Hide passwords while typing them
- Show basic messages when something goes wrong

## How I set it up

I made a Firebase project and enabled **Email/Password** under Authentication > Sign-in method. I connected the Flutter app to Firebase using FlutterFire CLI. The app uses `firebase_core` and `firebase_auth`.

To set up the app with your own Firebase project:

1. Install Flutter and the Firebase CLI / FlutterFire CLI.
2. Run `flutter pub get` in the project folder.
3. Run `flutterfire configure` and choose your Firebase project to generate the Firebase configuration.
4. In Firebase Console, enable **Authentication > Sign-in method > Email/Password**.
5. Start an Android emulator or connect an Android phone.
6. Run `flutter run`.

The app needs an internet connection to use Firebase Authentication. Do not put passwords, service account keys, or other private credentials in GitHub.

## Files I worked with

- `lib/main.dart` - starts Firebase and the Flutter app
- `lib/auth_service.dart` - handles the Firebase sign up, login, sign out, and password change functions
- `lib/auth_gate.dart` - checks if a user is logged in and picks which screen to show
- `lib/authentication_screen.dart` - login and sign up screen
- `lib/profile_screen.dart` - shows the email and lets users change passwords or sign out
- `lib/firebase_options.dart` - FlutterFire configuration

## Testing

I checked the following in the app:

- Registered an account and checked that it appeared in Firebase Console
- Logged in and opened the profile page
- Changed the password and saw the success message
- Tried incorrect login information and checked the error message
- Signed out to return to the authentication screen

I also found that Firebase login needs an internet connection. I did not add a Forgot Password button in this activity.



## What I learned

This activity helped me understand how Firebase can handle user accounts instead of saving passwords myself. I also learned about `authStateChanges()` and how the app can show a different screen depending on whether someone is logged in.
