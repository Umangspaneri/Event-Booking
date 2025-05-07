import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateCategory extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  UpdateCategory({super.key});

  void _updateCategory(BuildContext context, String docId, String oldName) {
    _controller.text = oldName;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Update Category"),
        content: TextField(controller: _controller),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('Categories')
                  .doc(docId)
                  .update({'name': _controller.text.trim()});
              Navigator.pop(context);
            },
            child: Text("Update"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Category")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(doc['name']),
                trailing: Icon(Icons.edit),
                onTap: () => _updateCategory(context, doc.id, doc['name']),
              );
            },
          );
        },
      ),
    );
  }
}
