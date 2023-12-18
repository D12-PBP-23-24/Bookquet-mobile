import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookquet_mobile/models/review_book.dart';

class ReviewPage extends StatefulWidget {
  final int bookId;
  final TextEditingController rateController = TextEditingController();
  ReviewPage({Key? key, required this.bookId}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late CookieRequest request;
  late int bookId;
  late Future<ReviewBook> _bookFuture;

  final TextEditingController commentController = TextEditingController();
  int rating = -1; // initial value
  String validationError = '';

  @override
  void initState() {
    super.initState();
    bookId = widget.bookId;
    request = context.read<CookieRequest>();
    _bookFuture = fetchBook();
  }

  Future<ReviewBook> fetchBook() async {
    var url =
        Uri.parse('http://127.0.0.1:8000/book-preview/preview-mobile/$bookId');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    return ReviewBook.fromJson(data);
  }

  Future<void> addReview(CookieRequest request, BuildContext context) async {
    final response = await request.post(
      ('http://127.0.0.1:8000/book-preview/add-review-mobile/$bookId/'),
      {'rate': rating.toString(), 'comment': commentController.text},
    );

    if (response['status'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terima kasih telah memberikan ulasan!'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview & Review Page"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              FutureBuilder(
                future: _bookFuture,
                builder: (context, AsyncSnapshot<ReviewBook> snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (!snapshot.hasData) {
                      return const Text("aa");
                    } else {
                      ReviewBook data = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              bool isWideScreen = constraints.maxWidth > 600;
                              return isWideScreen
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * 0.4,
                                          child: Image.network(
                                            data.book.coverImg,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.04,
                                        ),
                                        Container(
                                          width: constraints.maxWidth * 0.56,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${data.book.title}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 24.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Chip(
                                                    label: Text(
                                                      data.book.genres,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                'by ${data.book.author}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(height: 16.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ...List.generate(
                                                    5,
                                                    (index) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0),
                                                      child: Image.network(
                                                        index <
                                                                data.rate
                                                                    .averageRating
                                                            ? 'https://cdn.discordapp.com/attachments/812715106999861249/1186097355913695312/filled-star.png?ex=6592023e&is=657f8d3e&hm=c57c7d4ccb74ba72e15cc52604bf75928c67c03588040a4d4b81ce7d732d1632&'
                                                            : 'https://cdn.discordapp.com/attachments/812715106999861249/1186097322036306010/empty-star.png?ex=65920236&is=657f8d36&hm=658242801ba1870902ca03414d8ee44f567a232dc50eba67b443e4965f7ad5be&',
                                                        width: 30.0,
                                                        height: 30.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' (${data.book.userRated})',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 16.0),
                                              Text(
                                                data.book.description,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          data.book.coverImg,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        SizedBox(height: 16.0),
                                        Row(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: [
                                                  TextSpan(
                                                    text: 'This Is The Title',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Chip(
                                              label: Text(
                                                data.book.genres,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'by ${data.book.author}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ...List.generate(
                                              5,
                                              (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0),
                                                child: Image.network(
                                                  index <
                                                          data.rate
                                                              .averageRating
                                                      ? 'https://cdn.discordapp.com/attachments/812715106999861249/1186097355913695312/filled-star.png?ex=6592023e&is=657f8d3e&hm=c57c7d4ccb74ba72e15cc52604bf75928c67c03588040a4d4b81ce7d732d1632&'
                                                      : 'https://cdn.discordapp.com/attachments/812715106999861249/1186097322036306010/empty-star.png?ex=65920236&is=657f8d36&hm=658242801ba1870902ca03414d8ee44f567a232dc50eba67b443e4965f7ad5be&',
                                                  width: 30.0,
                                                  height: 30.0,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              ' (${data.book.userRated})',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16.0),
                                        Text(
                                          data.book.description,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),

                          // KOMENTAR THING
                          SizedBox(height: 30.0),
                          Text(
                            "Beberapa ulasan yang sudah diterima",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          Container(
                            height: 300.0,
                            child: SingleChildScrollView(
                              child: Column(
                                children: data.comments.isNotEmpty
                                    ? List.generate(
                                        data.comments.length > 4
                                            ? 4
                                            : data.comments.length,
                                        (index) {
                                          final randomIndex = index;

                                          return Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.comments[randomIndex]
                                                        .user,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.0),
                                                  Text(data
                                                      .comments[randomIndex]
                                                      .comment),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : [
                                        // Display a message when there are no comments
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Belum ada komentar yang diberikan pada buku ini.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ),

                          SizedBox(height: 30.0),
                          Text(
                            "Beli penilaian pada buku ini",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    rating = index + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Image.network(
                                    index < rating
                                        ? 'https://cdn.discordapp.com/attachments/812715106999861249/1186097355913695312/filled-star.png?ex=6592023e&is=657f8d3e&hm=c57c7d4ccb74ba72e15cc52604bf75928c67c03588040a4d4b81ce7d732d1632&'
                                        : 'https://cdn.discordapp.com/attachments/812715106999861249/1186097322036306010/empty-star.png?ex=65920236&is=657f8d36&hm=658242801ba1870902ca03414d8ee44f567a232dc50eba67b443e4965f7ad5be&',
                                    width: 50.0,
                                    height: 50.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 500.0,
                            height: 150.0,
                            child: TextField(
                              controller: commentController,
                              textAlign: TextAlign.center,
                              maxLines: null,
                              expands: true,
                              decoration: InputDecoration(
                                hintText: 'Berikan komentarmu...',
                                border: OutlineInputBorder(),
                                errorText: validationError.isNotEmpty
                                    ? validationError
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (validateInput()) {
                                addReview(request, context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: Container(
                              width: 150.0,
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateInput() {
    if (rating == -1 || commentController.text.isEmpty) {
      setState(() {
        validationError = 'Input tidak valid';
      });
      return false;
    } else {
      setState(() {
        validationError = '';
      });
      return true;
    }
  }
}
