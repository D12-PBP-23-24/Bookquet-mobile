import 'dart:convert';
import 'package:bookquet_mobile/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const FeedbackList({super.key});

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
        title: const Text(
          'Feedback List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          bool isCurrentUser = feedbacks[index]['user'] == request.jsonData['username'];
          return Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(feedbacks[index]['comment']),
              subtitle: Text('${feedbacks[index]['user']}' ' - ' '${feedbacks[index]['timestamp']}'),
              leading: const Icon(Icons.person),
              trailing: isCurrentUser ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteFeedback(feedbacks[index]['id']);
                },
              ) : null,
              tileColor: isCurrentUser ? Colors.green.shade50 : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
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

  AddFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Feedback',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Memberikan masukan anda untuk pengembangan aplikasi ini',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
            const SizedBox(height: 32),
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
