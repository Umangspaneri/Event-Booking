import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_event_booking/admin/home.dart';
import 'package:new_event_booking/firebase_options.dart';
import 'package:new_event_booking/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Checking if Firebase is initialized successfully
  if (Firebase.apps.isNotEmpty) {
    print("✅ Firebase is connected!");
  } else {
    print("❌ Firebase is NOT connected!");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Booking Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: ManageEvent(),
      home: SignUp(),
      // home: Upload_Event(),
      // home: Profile(),
      // home: Booking(),
      // home: BottomNav(),
      // home: CategoriesEvent(),
      // home: TicketEvent(),
      // home: DetailPage(),
      // home: Home(),
      // home: AdminHome(),
    );
  }
}
