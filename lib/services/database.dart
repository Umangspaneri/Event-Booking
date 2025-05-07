import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserDetail(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .set(userInfoMap);
      print("User data added successfully!");
    } catch (e) {
      print("Error adding user to Firestore: \$e");
    }
  }

  Stream<QuerySnapshot> getBookingsByUid(String uid) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('user_id', isEqualTo: uid)
        .snapshots();
  }

  Future<void> addEvent(Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("Event")
          .doc(id)
          .set(userInfoMap);
      print("Event added successfully!");
    } catch (e) {
      print("Error adding event to Firestore: \$e");
    }
  }

  Stream<QuerySnapshot> getEventCategories(String category) {
    return FirebaseFirestore.instance
        .collection("Event")
        .where("Category", isEqualTo: category)
        .snapshots();
  }

  Stream<QuerySnapshot> getallEvents() {
    return FirebaseFirestore.instance.collection("Event").snapshots();
  }

  Stream<QuerySnapshot> getBookings(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .snapshots();
  }

  Stream<QuerySnapshot> getTickets() {
    return FirebaseFirestore.instance.collection("Tickets").snapshots();
  }

  Future<void> addUserBooking(
      Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .add(userInfoMap);
  }

  Future<void> addAdminTickets(Map<String, dynamic> userInfoMap) async {
    await FirebaseFirestore.instance.collection("Tickets").add(userInfoMap);
  }
}
