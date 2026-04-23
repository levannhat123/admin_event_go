import 'package:admin_event_go/data/repositories/event/event_repository.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/data/models/event/event_model.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRepositoryImpl implements EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'events';

  @override
  Future<EventDetailModel> addEvent(EventDetailModel event) async {
    try {
      final jsonData = event.toJson();
      await _firestore.collection(_collectionName).doc(event.id).set(jsonData);
      return event;
    } catch (e) {
      throw Exception('Failed to add event: $e');
    }
  }

  @override
  Future<EventDetailModel> updateEvent(String eventId, EventDetailModel event) async {
    try {
      final eventData = event.toJson();
      eventData.removeWhere((key, value) => value == null);
      await _firestore.collection(_collectionName).doc(eventId).update(eventData);
      return event;
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  @override
  Future<EventDetailModel?> getEventById(String eventId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(eventId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final Map<String, dynamic> jsonData = {
          ...data,
          if (data['startTime'] != null && data['startTime'] is Timestamp)
            'startTime': (data['startTime'] as Timestamp).toDate().toIso8601String(),
          if (data['endTime'] != null && data['endTime'] is Timestamp)
            'endTime': (data['endTime'] as Timestamp).toDate().toIso8601String(),
          'id': data['id'] ?? doc.id,
        };

        return EventDetailModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get event: $e');
    }
  }

  @override
  Future<List<EventDetailModel>> getAllEvents() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();

        final Map<String, dynamic> jsonData = {
          ...data,
          if (data['startTime'] != null && data['startTime'] is Timestamp)
            'startTime': (data['startTime'] as Timestamp).toDate().toIso8601String(),
          if (data['endTime'] != null && data['endTime'] is Timestamp)
            'endTime': (data['endTime'] as Timestamp).toDate().toIso8601String(),
          'id': data['id'] ?? doc.id,
        };
        return EventDetailModel.fromJson(jsonData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all events: $e');
    }
  }

  @override
  Stream<List<EventDetailModel>> watchAllEvents() {
    try {
      return _firestore.collection(_collectionName).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final raw = doc.data();
          final Map<String, dynamic> jsonData = {
            ...raw,
            if (raw['startTime'] != null && raw['startTime'] is Timestamp)
              'startTime': (raw['startTime'] as Timestamp).toDate().toIso8601String(),
            if (raw['endTime'] != null && raw['endTime'] is Timestamp)
              'endTime': (raw['endTime'] as Timestamp).toDate().toIso8601String(),
            'id': raw['id'] ?? doc.id,
          };
          return EventDetailModel.fromJson(jsonData);
        }).toList();
      });
    } catch (e) {
      return Stream.error('Failed to watch events: $e');
    }
  }

  @override
  Future<List<EventModel>> getAllEventsAsEventModel() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return EventModel(
          id: data['id'] as String,
          name: data['title'] as String,
          imageUrl: data['bannerURL'] as String?,
          day: data['startTime'] != null && data['startTime'] is Timestamp
              ? (data['startTime'] as Timestamp).toDate()
              : null,
          price: data['minTicketPrice'] as int?,
          categories: data['categories'] != null
              ? CategoryModel.fromJson(data['categories'] as Map<String, dynamic>)
              : CategoryModel(id: '', name: ''),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all events as EventModel: $e');
    }
  }
}
