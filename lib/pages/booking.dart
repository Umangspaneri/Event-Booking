import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_event_booking/services/database.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? bookingStream;

  Future<void> getUserUidAndLoadBookings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      bookingStream = DatabaseMethods().getBookingsByUid(uid);

      if (mounted) {
        setState(() {});
      }
    } else {
      print("User not logged in. Cannot load bookings.");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserUidAndLoadBookings();
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.docs.isEmpty) {
          return Center(child: Text("No bookings found."));
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            ds["event_location"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "images/event.jpg",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds["event_name"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 18, color: Colors.blue),
                                SizedBox(width: 5),
                                Text(
                                  ds["event_date"],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 18, color: Colors.blue),
                                SizedBox(width: 5),
                                Text(
                                  ds["event_time"],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.group, color: Colors.blue),
                                SizedBox(width: 5),
                                Text("Tickets: ${ds["tickets_booked"]}"),
                                SizedBox(width: 15),
                                Icon(Icons.currency_rupee_sharp,
                                    color: Colors.green),
                                Text("${ds["total_amount"]}"),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
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
      backgroundColor: Color(0xfff1f3ff),
      appBar: AppBar(
        title: Text("My Bookings"),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: allBookings(),
    );
  }
}
