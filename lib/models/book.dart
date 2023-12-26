// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    Model model;
    int pk;
    Fields fields;

    Book({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String author;
    String description;
    String isbn;
    String genres;
    String coverImg;
    int year;
    double averageRate;
    int userRated;
    List<int> favorites;

    Fields({
        required this.title,
        required this.author,
        required this.description,
        required this.isbn,
        required this.genres,
        required this.coverImg,
        required this.year,
        required this.averageRate,
        required this.userRated,
        required this.favorites,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        author: json["author"],
        description: json["description"],
        isbn: json["isbn"].toString(),
        genres: json["genres"],
        coverImg: json["cover_img"],
        year: json["year"],
        averageRate: json["average_rate"],
        userRated: json["user_rated"],
        favorites: List<int>.from(json["favorites"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "description": description,
        "isbn": isbn,
        "genres": genres,
        "cover_img": coverImg,
        "year": year,
        "average_rate": averageRate,
        "user_rated": userRated,
        "favorites": List<dynamic>.from(favorites.map((x) => x)),
    };
}

enum Model {
    MAIN_BOOK
}

final modelValues = EnumValues({
    "main.book": Model.MAIN_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
