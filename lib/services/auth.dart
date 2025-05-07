import 'package:new_event_booking/pages/bottomnav.dart';
import 'package:new_event_booking/services/database.dart';
import 'package:new_event_booking/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await Firebase.initializeApp();

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        print("Google Sign-In canceled by user.");
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await auth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        Map<String, dynamic> userInfoMap = {
          "Name": userDetails.displayName ?? "N/A",
          "Image": userDetails.photoURL ?? "",
          "Email": userDetails.email ?? "N/A",
          "id": userDetails.uid,
        };

        await DatabaseMethods().addUserDetail(userInfoMap, userDetails.uid);

        // Save to SharedPreferences
        await SharedpreferenceHelper().saveUserId(userDetails.uid);
        await SharedpreferenceHelper()
            .saveUserName(userDetails.displayName ?? "N/A");
        await SharedpreferenceHelper()
            .saveUserEmail(userDetails.email ?? "N/A");
        await SharedpreferenceHelper()
            .saveUserImage(userDetails.photoURL ?? "");

        if (!context.mounted) return;

        Fluttertoast.showToast(
          msg: "Registered Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    } catch (e) {
      print("Error in Google Sign-In: $e");
      if (!context.mounted) return;

      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
