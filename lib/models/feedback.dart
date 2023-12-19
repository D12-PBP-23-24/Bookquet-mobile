import 'dart:convert';

List<AppFeedback> appFeedbackFromJson(String str) => List<AppFeedback>.from(json.decode(str).map((x) => AppFeedback.fromJson(x)));

String appFeedbackToJson(List<AppFeedback> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppFeedback {
    String model;
    int pk;
    Fields fields;

    AppFeedback({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory AppFeedback.fromJson(Map<String, dynamic> json) => AppFeedback(
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
    int user;
    String comment;
    DateTime timestamp;

    Fields({
        required this.user,
        required this.comment,
        required this.timestamp,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        comment: json["comment"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "comment": comment,
        "timestamp": timestamp.toIso8601String(),
    };
}
