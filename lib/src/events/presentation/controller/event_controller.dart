import 'package:ch_db_admin/src/events/domain/usecases/create.dart';
import 'package:ch_db_admin/src/events/domain/usecases/delete.dart';
import 'package:ch_db_admin/src/events/domain/usecases/read.dart';
import 'package:ch_db_admin/src/events/domain/usecases/update.dart';
import 'package:flutter/foundation.dart';
import 'package:ch_db_admin/src/events/domain/entities/event.dart';

class EventController extends ChangeNotifier {
  final CreateEvent createEventUseCase;
  final UpdateEvent updateEventUseCase;
  final GetEvents getEventsUseCase;
  final DeleteEvent deleteEventUseCase;

  List<Event> _events = [];
  // final List<Event> _filteredEvents = [];
  // List<Event> get events => _filteredEvents;

  String _message = '';
  String get message => _message;

  EventController({
    required this.createEventUseCase,
    required this.updateEventUseCase,
    required this.getEventsUseCase,
    required this.deleteEventUseCase,
  });

  List<Event> filterEvents(String searchText){
    final filteredEvents = _events
        .where((event) =>
            event.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
        return filteredEvents;
  }

  // Fetch all events
  Future<void> fetchEvents() async {
    final result = await getEventsUseCase.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        notifyListeners();
      },
      (events) {
        _events = events;
        notifyListeners();
      },
    );
  }

  // Create a new event
  Future<void> createEvent(Event event) async {
    final result = await createEventUseCase.execute(event);
    result.fold(
      (failure) {
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _message = message;
        _events.add(event); // Add the newly created event to the list
        notifyListeners();
      },
    );
  }

  // Update an existing event
  Future<void> updateEvent(Event event) async {
    final result = await updateEventUseCase.execute(event);
    result.fold(
      (failure) {
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _message = message;
        // Update the event in the list
        _events = _events.map((e) => e.id == event.id ? event : e).toList();
        notifyListeners();
      },
    );
  }

  // Delete an event
  Future<void> deleteEvent(Event event) async {
    final result = await deleteEventUseCase.execute(event);
    result.fold(
      (failure) {
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _message = message;
        _events
            .removeWhere((e) => e.id == event.id); // Remove the deleted event
        notifyListeners();
      },
    );
  }
}
