import 'dart:async';

import 'package:admin_event_go/core/base/base_view_model.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/domain/usecase/event/add_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/update_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/delete_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/get_event_by_id_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/get_all_events_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/watch_all_events_usecase.dart';

class EventViewModel extends BaseViewModel {
  final AddEventUsecase addEventUsecase;
  final UpdateEventUsecase updateEventUsecase;
  final DeleteEventUsecase deleteEventUsecase;
  final GetEventByIdUsecase getEventByIdUsecase;
  final GetAllEventsUsecase getAllEventsUsecase;
  final WatchAllEventsUsecase watchAllEventsUsecase;

  List<EventDetailModel> _events = [];
  EventDetailModel? _selectedEvent;
  StreamSubscription<List<EventDetailModel>>? _subscription;

  List<EventDetailModel> get events => _events;
  EventDetailModel? get selectedEvent => _selectedEvent;

  EventViewModel({
    required this.addEventUsecase,
    required this.updateEventUsecase,
    required this.deleteEventUsecase,
    required this.getEventByIdUsecase,
    required this.getAllEventsUsecase,
    required this.watchAllEventsUsecase,
  });

  Future<bool> addEvent(EventDetailModel event) async {
    setBusy(true);
    clearError();
    try {
      await addEventUsecase.call(event);
      setBusy(false);
      return true;
    } catch (e) {
      setError('Failed to add event: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<bool> updateEvent(String eventId, EventDetailModel event) async {
    setBusy(true);
    clearError();

    try {
      await updateEventUsecase.call(eventId, event);
      setBusy(false);
      return true;
    } catch (e) {
      setError('Failed to update event: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    setBusy(true);
    clearError();

    try {
      await deleteEventUsecase.call(eventId);
      _events.removeWhere((event) => event.id == eventId);
      notifyListeners();
      setBusy(false);
      return true;
    } catch (e) {
      setError('Failed to delete event: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<void> getEventById(String eventId) async {
    setBusy(true);
    clearError();

    try {
      _selectedEvent = await getEventByIdUsecase.call(eventId);
      setBusy(false);
      notifyListeners();
    } catch (e) {
      setError('Failed to get event: ${e.toString()}');
      setBusy(false);
    }
  }

  Future<void> getAllEvents() async {
    setBusy(true);
    clearError();

    try {
      _events = await getAllEventsUsecase.call();
      setBusy(false);
      notifyListeners();
    } catch (e) {
      setError('Failed to get all events: ${e.toString()}');
      setBusy(false);
    }
  }

  /// Start realtime listening to events collection and update [_events] on each snapshot.
  void watchAll() {
    _subscription?.cancel();
    setBusy(true);
    clearError();
    try {
      _subscription = watchAllEventsUsecase.call().listen((list) {
        _events = list;
        setBusy(false);
        notifyListeners();
      }, onError: (err) {
        setError('Failed to watch events: ${err.toString()}');
        setBusy(false);
      });
    } catch (e) {
      setError('Failed to start watching events: ${e.toString()}');
      setBusy(false);
    }
  }

  void clearSelectedEvent() {
    _selectedEvent = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
