import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/events/data/data_source/remote.dart';
import 'package:ch_db_admin/src/events/data/repository/event_repo_impl.dart';
import 'package:ch_db_admin/src/events/domain/repository/event_repo.dart';
import 'package:ch_db_admin/src/events/domain/usecases/create.dart';
import 'package:ch_db_admin/src/events/domain/usecases/delete.dart';
import 'package:ch_db_admin/src/events/domain/usecases/read.dart';
import 'package:ch_db_admin/src/events/domain/usecases/update.dart';
import 'package:ch_db_admin/src/events/presentation/controller/event_controller.dart';

void initEventDep() {
  // Registering the EventRemoteDb (Firebase) and EventRepo
  locator.registerLazySingleton<EventRemoteDb>(() => EventRemoteDb());

  // Register the EventRepoImpl with EventRemoteDb injected
  locator.registerLazySingleton<EventRepo>(
    () => EventRepoImpl(eventRemoteDb: locator.get<EventRemoteDb>()),
  );

  // Register UseCases
  locator.registerLazySingleton<CreateEvent>(
    () => CreateEvent(eventRepo: locator.get<EventRepo>()),
  );
  locator.registerLazySingleton<UpdateEvent>(
    () => UpdateEvent(eventRepo: locator.get<EventRepo>()),
  );
  locator.registerLazySingleton<GetEvents>(
    () => GetEvents(eventRepo: locator.get<EventRepo>()),
  );
  locator.registerLazySingleton<DeleteEvent>(
    () => DeleteEvent(eventRepo: locator.get<EventRepo>()),
  );

  // Register the EventController with all the use cases injected
  locator.registerFactory<EventController>(
    () => EventController(
      createEventUseCase: locator.get<CreateEvent>(),
      updateEventUseCase: locator.get<UpdateEvent>(),
      getEventsUseCase: locator.get<GetEvents>(),
      deleteEventUseCase: locator.get<DeleteEvent>(),
    ),
  );
}
