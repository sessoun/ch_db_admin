import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/src/events/domain/entities/event.dart';
import 'package:ch_db_admin/src/events/domain/repository/event_repo.dart';
import 'package:dartz/dartz.dart';

class GetEvents {
  final EventRepo eventRepo;

  GetEvents({required this.eventRepo});

  Future<Either<Failure, List<Event>>> execute() {
    return eventRepo.getEvents();
  }
}
