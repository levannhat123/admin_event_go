import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';

class AddEventUsecase {
  final EventRepository eventRepository;

  AddEventUsecase(this.eventRepository);

  Future<void> call(EventDetailModel event) async {
    try {
      await eventRepository.addEvent(event);
    } catch (e) {
      rethrow;
    }
  }
}