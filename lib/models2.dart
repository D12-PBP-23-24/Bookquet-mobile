// To parse this JSON data, do
//
//     final Item2 = Item2FromJson(jsonString);

import 'dart:convert';

List<Item2> Item2FromJson(String str) => List<Item2>.from(json.decode(str).map((x) => Item2.fromJson(x)));

String Item2ToJson(List<Item2> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item2 {
    Model model;
    int pk;
    Fields fields;

    Item2({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Item2.fromJson(Map<String, dynamic> json) => Item2(
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
    int isbn;
    String genres;
    String coverImg;
    int year;
    int averageRate;
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
        isbn: json["isbn"],
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
