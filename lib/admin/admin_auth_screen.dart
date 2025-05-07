import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_event_booking/admin/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({super.key});

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Check if the admin is already logged in
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn == true) {
      // Redirect to homepage if already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHome()),
      );
    }
  }

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void loginAdmin() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('admin')
      .where('email', isEqualTo: emailController.text.trim())
      .where('password', isEqualTo: passwordController.text.trim())
      .get();

  if (snapshot.docs.isNotEmpty) {
    final adminData = snapshot.docs.first.data();

    // ✅ Save login status and admin info to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('ADMINNAMEKEY', adminData['name']);
    prefs.setString('ADMINEMAILKEY', adminData['email']);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login successful"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminHome()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Invalid credentials"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  void signupAdmin() async {
    final newDoc = FirebaseFirestore.instance.collection('admin').doc();
    await newDoc.set({
      'id': newDoc.id,
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Admin Registered"),
        backgroundColor: Colors.blue,
      ),
    );
    toggleForm();
  }

  // Logout function
  void logoutAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false); // Clear login status

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged out"),
        backgroundColor: Colors.blue,
      ),
    );

    // Navigate back to the auth screen after logging out
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const AdminAuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Evento",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isLogin)
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLogin ? loginAdmin : signupAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLogin ? "Login" : "Sign Up",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: toggleForm,
                child: Text(
                  isLogin
                      ? "Create an Account"
                      : "Already have an Account? Login",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              // Add logout button to be shown when logged in
              // if (isLogin)
              //   TextButton(
              //     onPressed: logoutAdmin,
              //     child: Text(
              //       "Logout",
              //       style: TextStyle(color: Colors.redAccent),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
