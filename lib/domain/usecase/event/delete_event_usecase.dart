import 'package:admin_event_go/data/repositories/event/event_repository.dart';

class DeleteEventUsecase {
  final EventRepository eventRepository;

  DeleteEventUsecase(this.eventRepository);

  Future<void> call(String eventId) async {
    try {
      await eventRepository.deleteEvent(eventId);
    } catch (e) {
      rethrow;
    }
  }
}
