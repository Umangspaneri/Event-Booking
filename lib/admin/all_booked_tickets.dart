import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Updated Booking model class
class Booking {
  final String eventName;
  final String userName;
  final int ticketsBooked;
  final Timestamp timestamp;
  final String paymentStatus;
  final String eventDate;
  final String eventLocation;

  Booking({
    required this.eventName,
    required this.userName,
    required this.ticketsBooked,
    required this.timestamp,
    required this.paymentStatus,
    required this.eventDate,
    required this.eventLocation,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Booking(
      eventName: data['event_name'] ?? '',
      userName: data['user_name'] ?? '',
      ticketsBooked: data['tickets_booked'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
      paymentStatus: data['payment_status'] ?? '',
      eventDate: data['event_date'] ?? '',
      eventLocation: data['event_location'] ?? '',
    );
  }
}

class AllBookedTicketsScreen extends StatelessWidget {
  const AllBookedTicketsScreen({super.key});

  Stream<List<Booking>> getBookings() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('payment_status', isEqualTo: 'Success')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Booked Tickets'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<Booking>>(
        stream: getBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(
                      '${booking.eventName} (${booking.ticketsBooked} ticket(s))'),
                  subtitle: Text(
                    'User: ${booking.userName}\n'
                    'Date: ${booking.eventDate} at ${booking.eventLocation}',
                  ),
                  trailing: Text(
                    'Status: ${booking.paymentStatus}',
                    style: TextStyle(
                      color: booking.paymentStatus == 'Success'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
