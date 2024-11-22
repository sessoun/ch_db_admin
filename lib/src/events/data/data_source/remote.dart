import 'dart:io';

import 'package:ch_db_admin/shared/exceptions/app_exception.dart';
import 'package:ch_db_admin/shared/exceptions/database_exception.dart';
import 'package:ch_db_admin/shared/exceptions/network_exception.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/events/data/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventRemoteDb {
  final prefs = locator.get<SharedPreferences>();
  final db = FirebaseFirestore.instance
      .collection('organisations')
      .doc(locator.get<SharedPreferences>().getString('org_id'))
      .collection('events');

  // CREATE: Add a new event
  Future<String> createEvent(EventModel eventData) async {
    try {
      // Adding event data to Firestore
      await db.doc().set(eventData.toFirebase());
      print("Event added successfully.");
      return 'Event added successfully';
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Could\'t create event. Try again.',
          code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // READ: Fetch all events
  Future<List<EventModel>> getEvents() async {
    try {
      final snapshot = await db.get();
      final events =
          snapshot.docs.map((doc) => EventModel.fromFirebase(doc)).toList();
      return events;
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Could\'t get all events. Refresh',
          code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // READ: Fetch a single event by its ID
  Future<Map<String, dynamic>?> getEventById(String eventId) async {
    try {
      final docSnapshot = await db.doc(eventId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        print("Event not found.");
        return null;
      }
    } catch (e) {
      print("Error fetching event: $e");
      rethrow;
    }
  }

  // UPDATE: Update an event by ID
  Future<String> updateEvent(EventModel updatedData) async {
    try {
      await db.doc(updatedData.id).update(updatedData.toFirebase());
      print("Event updated successfully.");
      return 'Event updated successfully';
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Could\'t update event. Try again.',
          code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  // DELETE: Delete an event by ID
  Future<String> deleteEvent(String eventId) async {
    try {
      await db.doc(eventId).delete();
      print("Event deleted successfully.");
      return 'EVent deleted successfully';
    } on FirebaseException catch (e) {
      throw DatabaseException(e.message ?? 'Could\'t create event. Try again.',
          code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }
}
