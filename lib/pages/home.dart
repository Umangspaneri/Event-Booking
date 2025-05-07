import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:new_event_booking/pages/categories_event.dart';
import 'package:new_event_booking/pages/detail_page.dart';
import 'package:new_event_booking/services/database.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? eventStream;
  String? userLocation;
  String? userName;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    getUserData();
    getUserLocation();
    ontheload();
  }

  ontheload() async {
    eventStream = DatabaseMethods().getallEvents();
    if (mounted) {
      setState(() {});
    }
  }

  getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists && userData.data() != null && mounted) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          setState(() {
            userName = data['Name'] ?? 'No Name Found';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  getUserLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    final currentLocation = await location.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude!, currentLocation.longitude!);

    if (mounted) {
      setState(() {
        userLocation =
            "${placemarks.first.locality}, ${placemarks.first.country}";
      });
    }
  }

  Widget allEvents() {
    return StreamBuilder(
      stream: eventStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text('No events available.'));
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            String inputDate = ds["Date"];
            String eventName = ds["Name"].toString().toLowerCase();
            String eventCategory =
                ds["Category"]?.toString().toLowerCase() ?? "";

            if (searchQuery.isNotEmpty &&
                !eventName.contains(searchQuery) &&
                !eventCategory.contains(searchQuery)) {
              return Container();
            }

            DateTime parsedDate = DateTime.parse(inputDate);
            String formattedDate = DateFormat('MMM, dd').format(parsedDate);
            DateTime currentDate = DateTime.now();
            bool hasPassed = currentDate.isAfter(parsedDate);

            if (hasPassed) {
              return Container();
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      date: ds["Date"],
                      detail: ds["Detail"],
                      image: ds["Image"],
                      location: ds["Location"],
                      name: ds["Name"],
                      price: ds["Price"],
                      time: ds["Time"],
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "images/event.jpg",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              ds["Name"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "₹${ds["Price"]}",
                            style: TextStyle(
                                color: Color(0xff6351ec),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 18),
                          Flexible(
                            child: Text(
                              ds["Location"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      userLocation ?? "Fetching location...",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Hello, ${userName ?? 'Fetching name...'}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "There are 20 events around\nyour location.",
                style: TextStyle(
                    color: Color(0xff6351ec),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: searchController,
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val.trim().toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search_outlined),
                      border: InputBorder.none,
                      hintText: "Search an Event"),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    categoryCard("Music", "images/musical.png"),
                    SizedBox(width: 16),
                    categoryCard("Clothing", "images/tshirt.png"),
                    SizedBox(width: 16),
                    categoryCard("Festival", "images/confetti.png"),
                    SizedBox(width: 16),
                    categoryCard("Food", "images/dish.png"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Upcoming Events",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("See all",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 10),
              allEvents(),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoriesEvent(eventcategory: title)));
      },
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 110,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 30, width: 30),
              const SizedBox(height: 5),
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ),
    );
  }
}
