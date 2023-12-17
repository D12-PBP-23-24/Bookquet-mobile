import 'package:flutter/material.dart';
import '../../pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'network_service_for_read_later.dart';
import '../../models/read_later_book.dart';

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

    }
  }
  void _removeBook(int itemId) async {
    bool success = await networkService.removeFromReadLater(request, itemId);
    if (success) {
      setState(() {
        books.removeWhere((item) => item.id == itemId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book removed successfully')),
      );
    }
    try {
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove the book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Read Later List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0, 
                children: <Widget>[
                  ElevatedButton(child: Text('All'), onPressed: () => _loadBooks("all")),
                  ElevatedButton(child: Text('Low'), onPressed: () => _loadBooks("low")),
                  ElevatedButton(child: Text('Medium'), onPressed: () => _loadBooks("medium")),
                  ElevatedButton(child: Text('High'), onPressed: () => _loadBooks("high")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Priority: $priorityFilter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'Montserrat'),
              )
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // to disable ListView's own scrolling
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
                          _removeBook(books[index].id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
