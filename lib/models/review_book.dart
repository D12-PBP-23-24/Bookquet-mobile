import 'dart:convert';

ReviewBook reviewBookFromJson(String str) =>
    ReviewBook.fromJson(json.decode(str));

String reviewBookToJson(ReviewBook data) => json.encode(data.toJson());

class ReviewBook {
  Book book;
  Rate rate;
  List<Comment> comments;

  ReviewBook({
    required this.book,
    required this.rate,
    required this.comments,
  });

  factory ReviewBook.fromJson(Map<String, dynamic> json) => ReviewBook(
        book: Book.fromJson(json["book"]),
        rate: Rate.fromJson(json["rate"]),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "book": book.toJson(),
        "rate": rate.toJson(),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class Book {
  String title;
  String author;
  String description;
  String genres;
  String coverImg;
  int year;
  int userRated;

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.genres,
    required this.coverImg,
    required this.year,
    required this.userRated,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        title: json["title"],
        author: json["author"],
        description: json["description"],
        genres: json["genres"],
        coverImg: json["cover_img"],
        year: json["year"],
        userRated: json["user_rated"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "description": description,
        "genres": genres,
        "cover_img": coverImg,
        "year": year,
        "user_rated": userRated,
      };
}

class Comment {
  String comment;
  String user;

  Comment({
    required this.comment,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "user": user,
      };
}

class Rate {
  double averageRating;

  Rate({
    required this.averageRating,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        averageRating: json["average_rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "average_rating": averageRating,
      };
}