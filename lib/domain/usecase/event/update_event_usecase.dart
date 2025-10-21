import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';

class UpdateEventUsecase {
  final EventRepository eventRepository;

  UpdateEventUsecase(this.eventRepository);

  Future<void> call(String eventId, EventDetailModel event) async {
    try {
      await eventRepository.updateEvent(eventId, event);
    } catch (e) {
      rethrow;
    }
  }
}
