import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:bookquet_mobile/pbp_django_auth.dart';

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
  final TextEditingController commentController = TextEditingController();
  List<Map<String, dynamic>> feedbacks = [];
  late CookieRequest request;

  @override
  void initState() {
    super.initState();
    request = context.read<CookieRequest>();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await request.get('https://bookquet-d12-tk.pbp.cs.ui.ac.id/feedback/');

    setState(() {
      feedbacks = List<Map<String, dynamic>>.from(response['feedbacks']);
      feedbacks.sort((a, b) => b['id'].compareTo(a['id']));
    });
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
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const Text(
                  'Berikan masukan anda untuk pengembangan aplikasi ini!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        margin: const EdgeInsets.only(right: 16.0),
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: commentController,
                          decoration: const InputDecoration(
                            labelText: 'Comment',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Container (
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ButtonTheme(
                          minWidth: double.infinity,
                          child: MaterialButton(
                            onPressed: () {
                              addFeedback(request, context);
                            },
                            child: const Icon(
                              Icons.send, 
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ]
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                bool isCurrentUser = feedbacks[index]['user'] == request.jsonData['username'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(feedbacks[index]['comment']),
                    subtitle: Text('${feedbacks[index]['user']}' ' - ' '${feedbacks[index]['timestamp']}'),
                    // subtitle: Text('${feedbacks[index]['timestamp']}'),
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
          ),
        ]
      ),
    );
  }

  Future<void> deleteFeedback(int feedbackId) async {
    final response = await http.delete(Uri.parse('https://bookquet-d12-tk.pbp.cs.ui.ac.id/feedback/delete/$feedbackId/'));

    if (response.statusCode == 204) {
      fetchData();
    } else if (response.statusCode == 404) {
      print('Feedback not found');
    } else {
      print('Failed to delete feedback. Status code: ${response.statusCode}');
    }
  }

  Future<void> addFeedback(CookieRequest request, BuildContext context) async {
    final response = await request.post(
      ('https://bookquet-d12-tk.pbp.cs.ui.ac.id/feedback/add/'),
      {'comment': commentController.text, 'user': request.jsonData['username']},
    );

    if (response['status'] == 200) {
      // Jika penambahan feedback berhasil, refresh data
      fetchData();
      commentController.clear();
    } else {
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