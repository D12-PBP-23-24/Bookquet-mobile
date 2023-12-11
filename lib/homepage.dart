import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PrioritySelectionScreen.dart';
import 'book.dart';
// import 'package:homepage/book_detail_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TextEditingController _searchController;
  late Future<List<Book>> _booksFuture;
  String _selectedGenre = 'All';

  final List<Map<String, String>> _genreChoices = [
    {'label': 'All', 'value': 'All'},
    {'label': 'Young Adult', 'value': 'Young Adult'},
    {'label': 'Fantasy', 'value': 'Fantasy'},
    {'label': 'Classics', 'value': 'Classics'},
    {'label': 'Historical Fiction', 'value': 'Historical Fiction'},
    {'label': 'Childrens', 'value': 'Childrens'},
    {'label': 'Fiction', 'value': 'Fiction'},
    {'label': 'Science Fiction', 'value': 'Science Fiction'},
    {'label': 'Horror', 'value': 'Horror'},
    {'label': 'Nonfiction', 'value': 'Nonfiction'},
    {'label': 'Romance', 'value': 'Romance'},
    {'label': 'Mystery', 'value': 'Mystery'},
    {'label': 'Picture Books', 'value': 'Picture Books'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _booksFuture = fecthBook();
  }

  Future<List<Book>> fecthBook() async {
    var url = Uri.parse('http://localhost:8000/get-book');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> books = [];
    for (var i in data) {
      if (i != null) {
        books.add(Book.fromJson(i));
      }
    }

    return books;
  }

  List<Book> _searchBooks(String query, List<Book> books) {
    return books.where((book) {
      return (book.fields.title.toLowerCase().contains(query.toLowerCase()) ||
          book.fields.author.toLowerCase().contains(query.toLowerCase())) &&
          (_selectedGenre == 'All' || book.fields.genres.contains(_selectedGenre));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xffe4fef3),
            padding: const EdgeInsets.all(24.0),
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bookquet',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Di setiap buku, terdapat karangan kata-kata berbunga!',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari buku disini!',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _booksFuture = fecthBook();
                });
              },
            ),
          ),
          const Text(
            'Genre Buku',
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedGenre,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenre = newValue!;
                  _booksFuture = fecthBook();
                });
              },
              items: _genreChoices.map<DropdownMenuItem<String>>((Map<String, String> genre) {
                return DropdownMenuItem<String>(
                  value: genre['value']!,
                  child: Text(genre['label']!),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8.0),
          const Center(
            child: Text(
              'Daftar Buku',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: FutureBuilder(
              future: _booksFuture,
              builder: (context, AsyncSnapshot<List<Book>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada buku.",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ),
                  );
                } else {
                  List<Book> filteredBooks = _searchBooks(_searchController.text, snapshot.data!);

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      mainAxisExtent: 500,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      int filledStars = filteredBooks[index].fields.averageRate.round();
                      int emptyStars = 5 - filledStars;

                      List<Widget> starIcons = List.generate(
                        filledStars,
                        (index) => const Icon(Icons.star),
                      );

                      List<Widget> borderStarIcons = List.generate(
                        emptyStars,
                        (index) => const Icon(Icons.star_border),
                      );

                      return InkWell(
                        onTap: () {
                          // // TODO: Routing ke William
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BookDetailPage(bookTitle: filteredBooks[index].fields.title),
                          //   ),
                          // );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...starIcons,
                                    ...borderStarIcons,
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Expanded(
                                  child: Image.network(
                                    filteredBooks[index].fields.coverImg,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    filteredBooks[index].fields.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  subtitle: Text(
                                    filteredBooks[index].fields.author,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                ListTile(
                                  leading: Text(
                                    filteredBooks[index].fields.genres,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    filteredBooks[index].fields.year.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PrioritySelectionScreen(bookId: filteredBooks[index].pk),
                                      ),
                                    );
                                  },
                                  child: const Text("Read Later"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}