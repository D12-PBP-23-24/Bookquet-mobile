import 'dart:convert';

List<ItemReadLater> itemFromJson(String str) => List<ItemReadLater>.from(json.decode(str).map((x) => ItemReadLater.fromJson(x)));

String itemToJson(List<ItemReadLater> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemReadLater {
    int id;
    String title;
    String author;
    String description;
    String isbn;
    String genres;
    String coverImg;
    int year;

    ItemReadLater({
        required this.id,
        required this.title,
        required this.author,
        required this.description,
        required this.isbn,
        required this.genres,
        required this.coverImg,
        required this.year,
    });

    @override
    String toString() {
      return 'ItemReadLater{id: $id, title: $title, author: $author, description: $description, isbn: $isbn, genres: $genres, coverImg: $coverImg, year: $year}';
    }

    factory ItemReadLater.fromJson(Map<String, dynamic> json) => ItemReadLater(
    // Use `??` to provide default values in case the field is null.
    id: json["id"] as int? ?? 0,
    title: json["title"] as String? ?? 'Unknown Title',
    author: json["author"] as String? ?? 'Unknown Author',
    description: json["description"] as String? ?? 'No Description',
    isbn: json["isbn"] as String? ?? 'No ISBN',
    genres: json["genres"] as String? ?? 'No Genres',
    coverImg: json["cover_img"] as String? ?? 'No Cover Image',
    year: json["year"] as int? ?? 0,
  );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "description": description,
        "isbn": isbn,
        "genres": genres,
        "cover_img": coverImg,
        "year": year,
    };
}
