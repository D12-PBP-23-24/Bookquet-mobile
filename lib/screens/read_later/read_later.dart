import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookquet_mobile/pbp_django_auth.dart';
import 'package:bookquet_mobile/models/read_later_book.dart';
import 'package:bookquet_mobile/screens/read_later/network_service_for_read_later.dart';

class ReadLaterListScreen extends StatefulWidget {
  @override
  _ReadLaterListScreenState createState() => _ReadLaterListScreenState();
}

class _ReadLaterListScreenState extends State<ReadLaterListScreen> {
  final NetworkService networkService = NetworkService();
  List<ItemReadLater> books = [];
  String priorityFilter = 'all';
  late CookieRequest request;

  @override
  void initState() {
    super.initState();
    request = context.read<CookieRequest>();
    _loadBooks(priorityFilter);
  }

  void _loadBooks(filter) async {
    priorityFilter = filter;
    var fetchedBooks = await networkService.fetchReadLaterBooks(request,priorityFilter);
    setState(() {
      books = fetchedBooks;
    });
    try {
    } catch (e) {
      // Handle exception by showing a message or error state to the user
    }
  }
  void _removeBook(int itemId) async {
    bool success = await networkService.removeFromReadLater(request, itemId);
    if (success) {
      setState(() {
        books.removeWhere((item) => item.id == itemId);
      });
      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book removed successfully')),
      );
    }
    try {
    } catch (e) {
      // Handle the error, maybe show a Snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove the book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Read Later List'),
        backgroundColor: Colors.green, 
      ),
      body: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(child: Text('All'), onPressed: () => {
                _loadBooks("all")
              }),
              ElevatedButton(child: Text('Low'), onPressed: () => {
                _loadBooks("low")

              }),
              ElevatedButton(child: Text('Medium'), onPressed: () => {
                _loadBooks("medium")

              }),
              ElevatedButton(child: Text('High'), onPressed: () => {
                _loadBooks("high")

              }),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child:Text(
              'Priority: $priorityFilter',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
            )
          ),
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Image.network(books[index].coverImg),
                      Text(books[index].title, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(books[index].author),
                      Text(books[index].genres),
                      ElevatedButton(
                        child: Text('Upgrade Priority'),
                        onPressed: () async {
                          bool success = await networkService.upgradePriority(request, books[index].id);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Priority upgraded')));
                            _loadBooks(priorityFilter);
                          } else {
                            // Handle the error
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upgrade priority')));
                          }
                        },
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        // color: Colors.red,
                        child: Text('Remove from Read Later'),
                        onPressed: () {
                          // Handle the remove from read later logic
                          _removeBook(books[index].id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
