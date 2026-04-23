import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/data/models/event/event_model.dart';

abstract class EventRepository {
  Future<EventDetailModel> addEvent(EventDetailModel event);
  Future<EventDetailModel> updateEvent(String eventId, EventDetailModel event);
  Future<void> deleteEvent(String eventId);
  Future<EventDetailModel?> getEventById(String eventId);
  Future<List<EventDetailModel>> getAllEvents();
  Future<List<EventModel>> getAllEventsAsEventModel();
  Stream<List<EventDetailModel>> watchAllEvents();
}