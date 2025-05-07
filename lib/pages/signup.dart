import 'package:new_event_booking/admin/admin_auth_screen.dart';
import 'package:new_event_booking/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false; // Added to show loading state

  void handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
    });

    await AuthMethods().signInWithGoogle(context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset("images/onboarding.png"),
          SizedBox(height: 10.0),
          Text(
            "Unlock the Future of",
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Welcome To Evento",
            style: TextStyle(
                color: Color(0xff6351ec),
                fontSize: 27.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.0),
          Text(
            "Discover, Book, and experience unforgettable moments effortlessly!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 50.0),
          GestureDetector(
            onTap: handleGoogleSignIn,
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                  color: Color(0xff6351ec),
                  borderRadius: BorderRadius.circular(40)),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/google.png",
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 20.0),
                        Text(
                          "Sign in with Google",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 23.0,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminAuthScreen()),
              );
            },
            child: Text(
              "Admin Side",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
