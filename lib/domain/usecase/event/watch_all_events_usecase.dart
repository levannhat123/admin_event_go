import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';

class WatchAllEventsUsecase {
  final EventRepository eventRepository;

  WatchAllEventsUsecase(this.eventRepository);

  Stream<List<EventDetailModel>> call() {
    try {
      return eventRepository.watchAllEvents();
    } catch (e) {
      rethrow;
    }
  }
}

