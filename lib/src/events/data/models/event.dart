import 'package:ch_db_admin/src/events/domain/entities/event.dart';

class EventModel extends Event {
  EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    required super.location,
    required super.organizerId,
    required super.imageUrl,
  });

  // Example of method to convert EventModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'organizerId': organizerId,
    };
  }

  // Example of method to create EventModel from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      organizerId: json['organizerId'],
      imageUrl: json['imageUrl'],
    );
  }
}
