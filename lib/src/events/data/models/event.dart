import 'package:ch_db_admin/src/events/domain/entities/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'organizerId': organizerId,
    };
  }

  factory EventModel.fromFirebase(DocumentSnapshot doc) {
    return EventModel(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      date:  (doc['date'] as Timestamp).toDate(),
      location: doc['location'],
      organizerId: doc['organizerId'],
      imageUrl: doc['imageUrl'],
    );
  }
}
