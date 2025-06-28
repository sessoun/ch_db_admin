import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/events/domain/entities/event.dart';
import 'package:dartz/dartz.dart';

abstract class EventRepo {
  Future<Either<Failure, String>> createEvent(Event event);
  Future<Either<Failure, String>> updateEvent(Event event);
  Future<Either<Failure, List<Event>>> getEvents();
  Future<Either<Failure, String>> deleteEvent(Event event);
}
