import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_event_booking/services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Import the services package

class Upload_Event extends StatefulWidget {
  const Upload_Event({super.key});

  @override
  State<Upload_Event> createState() => Upload_EventState();
}

class Upload_EventState extends State<Upload_Event> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();

  final List<String> eventcategory = ["Music", "Food", "Clothing", "Festival"];
  String? value;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 0);

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final datetime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('hh:mm a').format(datetime);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> uploadEvent() async {
    if (selectedImage == null) {
      Fluttertoast.showToast(msg: "Please select an image first!");
      return;
    }

    if (namecontroller.text.isEmpty ||
        pricecontroller.text.isEmpty ||
        value == null ||
        locationcontroller.text.isEmpty ||
        detailcontroller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields!");
      return;
    }

    try {
      String id = randomAlphaNumeric(10);
      Map<String, dynamic> uploadevent = {
        "Image": "", // Handle image upload separately
        "Name": namecontroller.text,
        "Price": pricecontroller.text,
        "Category": value,
        "Location": locationcontroller.text,
        "Detail": detailcontroller.text,
        "Date": DateFormat('yyyy-MM-dd').format(selectedDate),
        "Time": formatTimeOfDay(selectedTime),
      };

      await DatabaseMethods().addEvent(uploadevent, id);
      Fluttertoast.showToast(
        msg: "Event Uploaded Successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      setState(() {
        namecontroller.clear();
        pricecontroller.clear();
        detailcontroller.clear();
        locationcontroller.clear();
        selectedImage = null;
        value = null;
      });
    } catch (e) {
      print("Upload Error: $e");
      Fluttertoast.showToast(
        msg: "Upload failed! Try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the system UI to show the status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Optional: make the status bar color transparent
      statusBarIconBrightness:
          Brightness.dark, // Optional: change status bar icon brightness
    ));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 5.5),
                    Text(
                      "Upload Event",
                      style: TextStyle(
                          color: Color(0xff6351ec),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: getImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(20)),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                selectedImage!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildTextField(
                    "Event Name", namecontroller, "Enter Event Name"),
                buildTextField("Ticket Price", pricecontroller, "Enter Price"),
                buildDropdown(),
                SizedBox(height: 10),
                buildTextField("Event Details", detailcontroller,
                    "What will be on that event.....",
                    maxLines: 4),
                buildTextField(
                    "Event Location", locationcontroller, "Enter Location"),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: uploadEvent,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff6351ec),
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      width: 200,
                      child: Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xffececf8),
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hint),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Category",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xffececf8),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: eventcategory.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: ((value) => setState(() {
                    this.value = value;
                  })),
              dropdownColor: Colors.white,
              hint: Text("Select Category"),
              iconSize: 36,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              value: value,
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                _pickDate();
              },
              child: Icon(Icons.calendar_month, color: Colors.blue, size: 20),
            ),
            SizedBox(width: 10),
            Text(
              DateFormat('yyyy-MM-dd').format(selectedDate),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                _pickTime();
              },
              child: Icon(
                Icons.alarm,
                color: Colors.blue,
                size: 30,
              ),
            ),
            SizedBox(width: 10),
            Text(
              formatTimeOfDay(selectedTime),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}
