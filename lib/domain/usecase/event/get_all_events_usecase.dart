import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';

class GetAllEventsUsecase {
  final EventRepository eventRepository;

  GetAllEventsUsecase(this.eventRepository);

  Future<List<EventDetailModel>> call() async {
    try {
      return await eventRepository.getAllEvents();
    } catch (e) {
      rethrow;
    }
  }
}
