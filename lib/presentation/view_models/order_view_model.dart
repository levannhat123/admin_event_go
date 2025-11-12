import 'package:admin_event_go/core/base/base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderViewModel extends BaseViewModel {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>? _ordersStream;

  void init() {
    if (_ordersStream != null) return;
    _ordersStream = _db
        .collectionGroup('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? get ordersStream => _ordersStream;
}