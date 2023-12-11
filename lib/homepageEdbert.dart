import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PrioritySelectionScreen.dart';
import 'models2.dart';
import 'network_service.dart';
import 'modelsReadLater.dart';
import 'pbp_django_auth.dart';
import 'read_later_list_screen.dart';

class  HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Books'),
      ),
      body: FutureBuilder<List<Item2>>(
        future: _fetchBooks(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Item2> books = snapshot.data ?? []; // Handle null data
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Text(books[index].fields.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(books[index].fields.author),
                      ElevatedButton(
                        child: Text('Add to Read Later'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrioritySelectionScreen(bookId: books[index].pk),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Item2>> _fetchBooks(BuildContext context) async {
    final request = context.read<CookieRequest>();
    var response = await request.get('http://127.0.0.1:8000/get-book');
    List<Item2> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Item2.fromJson(d));
      }
    }
    return list_product;
  }

  void _addToReadLaterAndNavigate(BuildContext context, int bookId,String priority) async {
    final networkService = NetworkService();
    final request = context.read<CookieRequest>();
    // bool success = await networkService.addToReadLater(request, bookId);
    bool success = await networkService.addToReadLater(request, bookId, priority);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReadLaterListScreen()),
      );
    } else {
      // Handle error
    }
  }
}
