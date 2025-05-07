import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  final String eventId;
  final QueryDocumentSnapshot eventData;

  const EditEvent({super.key, required this.eventId, required this.eventData});

  @override
  State<EditEvent> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController detailController;
  late TextEditingController timeController;
  late TextEditingController priceController;

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.eventData['Name'] ?? '');
    locationController =
        TextEditingController(text: widget.eventData['Location'] ?? '');
    dateController =
        TextEditingController(text: widget.eventData['Date'] ?? '');
    detailController =
        TextEditingController(text: widget.eventData['Detail'] ?? '');
    timeController =
        TextEditingController(text: widget.eventData['Time'] ?? '');
    priceController =
        TextEditingController(text: widget.eventData['Price'] ?? '');
  }

  void updateEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isUpdating = true);
      try {
        await FirebaseFirestore.instance
            .collection('Event')
            .doc(widget.eventId)
            .update({
          'Name': nameController.text.trim(),
          'Location': locationController.text.trim(),
          'Date': dateController.text.trim(),
          'Detail': detailController.text.trim(),
          'Time': timeController.text.trim(),
          'Price': priceController.text.trim(),
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("✅ Event Updated")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("❌ Failed: $e")));
      } finally {
        setState(() => isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Location", locationController),
              _buildTextField("Date", dateController),
              _buildTextField("Time", timeController),
              _buildTextField("Price", priceController,
                  keyboardType: TextInputType.number),
              _buildTextField("Detail", detailController, maxLines: 3),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isUpdating ? null : updateEvent,
                child: isUpdating
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Update Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => (value == null || value.trim().isEmpty)
            ? '$label cannot be empty'
            : null,
      ),
    );
  }
}
