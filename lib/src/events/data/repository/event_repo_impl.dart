import 'dart:io';

import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/events/data/data_source/remote.dart';
import 'package:ch_db_admin/src/events/data/models/event.dart';
import 'package:ch_db_admin/src/events/domain/entities/event.dart';
import 'package:ch_db_admin/src/events/domain/repository/event_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class EventRepoImpl implements EventRepo {
  final EventRemoteDb eventRemoteDb;

  EventRepoImpl({required this.eventRemoteDb});

  @override
  Future<Either<Failure, String>> createEvent(Event event) async {
    final eventModel = EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      organizerId: event.organizerId,
      imageUrl: event.imageUrl,
    );
    try {
      final result = await eventRemoteDb.createEvent(eventModel);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error adding member',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }
  }

  @override
  Future<Either<Failure, String>> updateEvent(Event event) async {
    final eventModel = EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      organizerId: event.organizerId,
      imageUrl: event.imageUrl,
    );
    try {
      final result = await eventRemoteDb.updateEvent(eventModel);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error adding member',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final eventsModel = await eventRemoteDb.getEvents();
      final events = List<Event>.from(eventsModel).toList();
      return Right(events);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error getting event',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }
  }

  @override
  Future<Either<Failure, String>> deleteEvent(Event event) async {
    try {
      final result = await eventRemoteDb.deleteEvent(event.id);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(Failure(e.message ?? 'Error updating event',
          code: e.code)); // Firebase failure
    } on SocketException catch (_) {
      return Left(Failure('No internet connection')); // Network failure
    } catch (e) {
      return Left(Failure('Unknown error: $e')); // Generic failure
    }
  }
}
