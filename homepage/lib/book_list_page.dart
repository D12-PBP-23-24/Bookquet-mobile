import 'package:flutter/material.dart';
import 'book_detail_page.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final List<Map<String, dynamic>> allBooks = [
    {
      'title': 'In Cold Blood',
      'image': 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1424931136l/168642.jpg',
      'author': 'Truman Capote',
    },
    {
      'title': 'The Adventures of Huckleberry Finn',
      'image': 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1546096879l/2956.jpg',
      'author': 'Mark Twain, Guy Cardwell (Notes), John Seelye (Introduction)',
    },
    {
      'title': 'Harry Potter and the Order of the Phoenix',
      'image': 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1546910265l/2.jpg',
      'author': 'J.K. Rowling, Mary GrandPré (Illustrator)',
    },
    {
      'title': 'Fight Club',
      'image': 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1558216416l/36236124._SY475_.jpg',
      'author': 'Chuck Palahniuk (Goodreads Author)',
    },
    {
      'title': 'The Scarlet Letter',
      'image': 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1404810944l/12296.jpg',
      'author': 'Nathaniel Hawthorne, Thomas E. Connolly (Annotations), Nina Baym (Introduction)',
    },
    // Tambahkan buku-buku lainnya
  ];

  List<Map<String, dynamic>> displayedBooks = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedBooks = List.from(allBooks);
  }

  void _performSearch(String query) {
    setState(() {
      displayedBooks = allBooks
          .where((book) =>
              book['title'].toLowerCase().contains(query.toLowerCase()) ||
              book['author'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          automaticallyImplyLeading: false,
          title: Text(
            'Bookquet',
            style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Di setiap buku, terdapat karangan kata-kata berbunga! ✨\n\n',
              style: TextStyle(fontSize: 17.0),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'If you don’t like to read, you haven’t found the right book.\n\n'
              'J.K. Rowling',
              style: TextStyle(fontSize: 13.0),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
              ),
              itemCount: displayedBooks.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(bookTitle: displayedBooks[index]['title']),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    child: Center( // Tambahkan widget Center di sini
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Letakkan widget di tengah secara vertikal
                          children: [
                            Container(
                              width: double.infinity,
                              height: 120.0,
                              child: Image.network(
                                displayedBooks[index]['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              displayedBooks[index]['title'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center, // Pusatkan teks secara horizontal
                            ),
                            Text(
                              'Author: ${displayedBooks[index]['author']}',
                              textAlign: TextAlign.center, // Pusatkan teks secara horizontal
                            ),
                          ],
                        ),
                      ),
                    ),
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
