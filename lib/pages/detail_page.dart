import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_event_booking/pages/booking.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class DetailPage extends StatefulWidget {
  String image, name, location, date, detail, price, time;
  DetailPage({
    super.key,
    required this.date,
    required this.detail,
    required this.image,
    required this.location,
    required this.time,
    required this.name,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int ticket = 1;
  int total = 0;
  late Razorpay _razorpay;
  String? userName;
  String readableAddress = '';

  @override
  void initState() {
    super.initState();
    total = int.parse(widget.price);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    fetchUserData();
    convertCoordinatesToAddress();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void fetchUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? user.email ?? "Unknown User";
      });
    }
  }

  void convertCoordinatesToAddress() async {
    try {
      List<String> latLong = widget.location.split(',');
      double lat = double.parse(latLong[0]);
      double long = double.parse(latLong[1]);
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      Placemark place = placemarks[0];
      setState(() {
        readableAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      print("Location conversion error: $e");
      readableAddress = widget.location; // fallback to original
    }
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_txwA53PD3dbftd', // Replace with your Razorpay key
      'amount': total * 100, // Amount in paisa
      'name': 'Event Booking',
      'description': widget.name,
      'prefill': {
        'contact': '8888888888', // Static contact
        'email': 'testuser@example.com' // Static email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Save booking data
      await FirebaseFirestore.instance.collection('bookings').add({
        'user_id': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_uid',
        'user_name': userName ?? 'Unknown',
        'event_name': widget.name,
        'event_location': readableAddress,
        'event_date': widget.date,
        'event_time': widget.time,
        'tickets_booked': ticket,
        'total_amount': total,
        'payment_id': response.paymentId,
        'payment_status': 'Success',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // // Save ticket data
      // await FirebaseFirestore.instance.collection('tickets').add({
      //   'ticket_id': response.paymentId,
      //   'user_id': FirebaseAuth.instance.currentUser?.uid ?? 'unknown_uid',
      //   'user_name': userName ?? 'Unknown',
      //   'event_name': widget.name,
      //   'event_date': widget.date,
      //   'event_time': widget.time,
      //   'quantity': ticket,
      //   'price_paid': total,
      //   'issue_date': FieldValue.serverTimestamp(),
      // });

      // Show success dialog and navigate to booking page
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: Text('Payment Successful! Ticket Created Successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => Booking()),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error saving booking/ticket: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Icon(Icons.error, color: Colors.red, size: 60),
        content: Text('Payment Failed'),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('External Wallet Selected'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "images/event.jpg",
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(9),
                          margin: EdgeInsets.only(top: 40.0, left: 20.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black45),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_month, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  widget.date,
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Icon(Icons.location_on, color: Colors.white),
                                SizedBox(width: 5.0),
                                Text(
                                  readableAddress,
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  widget.time,
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "About Event",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.detail,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Row(
                children: [
                  Text(
                    "Number of Tickets",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 40.0),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            total = total + int.parse(widget.price);
                            ticket = ticket + 1;
                            setState(() {});
                          },
                          child: Text(
                            "+",
                            style: TextStyle(
                              color: Color(0xff6351ec),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          ticket.toString(),
                          style: TextStyle(
                            color: Color(0xff6351ec),
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (ticket > 1) {
                              total = total - int.parse(widget.price);
                              ticket = ticket - 1;
                              setState(() {});
                            }
                          },
                          child: Text(
                            "-",
                            style: TextStyle(
                              color: Color(0xff6351ec),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    "Amount : ₹$total",
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      openCheckout();
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff6351ec),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
