import 'dart:convert';
import 'package:bookquet_mobile/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookquet_mobile/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FeedbackList(),
    );
  }
}

class FeedbackList extends StatefulWidget {
  @override
  _FeedbackListState createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  List<Map<String, dynamic>> feedbacks = [];
  late CookieRequest request;

  @override
  void initState() {
    super.initState();
    request = context.read<CookieRequest>();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get
      (Uri.parse('http://127.0.0.1:8000/feedback/'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      setState(() {
        // print(response.body);
        feedbacks = List<Map<String, dynamic>>.from(json.decode(response.body)['feedbacks']);
      });
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback List'),
      ),
      body: ListView.builder(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('ID: ${feedbacks[index]['id']}'),
            subtitle: Text('User: ${feedbacks[index]['user']} - Comment: ${feedbacks[index]['comment']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteFeedback(feedbacks[index]['id']);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah feedback
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFeedback()),
          ).then((_) {
            // Refresh data setelah tambah feedback
            fetchData();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> deleteFeedback(int feedbackId) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:8000/feedback/delete/$feedbackId'));

    if (response.statusCode == 204) {
      // Jika penghapusan berhasil, refresh data
      fetchData();
    } else {
      // Tampilkan pesan error jika penghapusan gagal
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete feedback'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class AddFeedback extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Comment'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addFeedback(context.read<CookieRequest>(), context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addFeedback(CookieRequest request, BuildContext context) async {
    final response = await request.post(
      ('http://127.0.0.1:8000/feedback/add/'),
      {'comment': commentController.text},
    );

    if (response['status'] == 201) {
      // Jika penambahan berhasil, kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      // Tampilkan pesan error jika penambahan gagal
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to add feedback'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
