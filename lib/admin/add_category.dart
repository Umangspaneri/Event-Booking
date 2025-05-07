import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AddCategory({super.key});

  void _addCategory(BuildContext context) {
    final String category = _controller.text.trim();
    if (category.isNotEmpty) {
      FirebaseFirestore.instance.collection('Categories').add({
        'name': category,
      }).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Category Added')));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addCategory(context),
              child: Text("Add Category"),
            ),
          ],
        ),
      ),
    );
  }
}
