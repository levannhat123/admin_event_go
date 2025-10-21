import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';

class GetEventByIdUsecase {
  final EventRepository eventRepository;

  GetEventByIdUsecase(this.eventRepository);

  Future<EventDetailModel?> call(String eventId) async {
    try {
      return await eventRepository.getEventById(eventId);
    } catch (e) {
      rethrow;
    }
  }
}
