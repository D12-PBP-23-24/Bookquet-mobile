// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

List<dashboard> userProfileFromJson(String str) => List<dashboard>.from(json.decode(str).map((x) => dashboard.fromJson(x)));

String userProfileToJson(List<dashboard> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class dashboard {
    String model;
    int pk;
    Fields fields;

    dashboard({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory dashboard.fromJson(Map<String, dynamic> json) => dashboard(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String nickname;
    int phone;
    int age;
    String region;

    Fields({
        required this.nickname,
        required this.phone,
        required this.age,
        required this.region,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        nickname: json["nickname"],
        phone: json["phone"],
        age: json["age"],
        region: json["region"],
    );

    Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "phone": phone,
        "age": age,
        "region": region,
    };
}