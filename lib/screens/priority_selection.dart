import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'network_service_for_read_later.dart';
import '../pbp_django_auth.dart';
import 'read_later.dart'; 

class PrioritySelectionScreen extends StatefulWidget {
  final int bookId;

  PrioritySelectionScreen({required this.bookId});

  @override
  _PrioritySelectionScreenState createState() => _PrioritySelectionScreenState();
}

class _PrioritySelectionScreenState extends State<PrioritySelectionScreen> {
  String selectedPriority = 'low'; // Default priority value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Your Priority',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedPriority,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPriority = newValue!;
                });
              },
              items: <String>['low', 'medium', 'high']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _addToReadLater(context, selectedPriority);
              },
              child: Text('Add to Read Later'),
            ),
          ],
        ),
      ),
    );
  }

  void _addToReadLater(BuildContext context, String priority) async {
    final networkService = NetworkService();
    final request = context.read<CookieRequest>();
    bool success = await networkService.addToReadLater(request, widget.bookId, priority);
    if (success) {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReadLaterListScreen()),
      );
      // Navigator.pop(context); // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Buku sudah pernah ditambahkan dengan prioritas lain")));
    }
  }
}
