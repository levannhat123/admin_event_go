import 'dart:async';

import 'package:admin_event_go/core/base/base_view_model.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/data/models/event/ticket_type_model.dart';
import 'package:admin_event_go/data/models/profile_model.dart';
import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/usecase/event/watch_all_events_usecase.dart';

class DashboadViewModel extends BaseViewModel {
  StreamSubscription<List<EventDetailModel>>? _subscription;
  final AuthRepository _authRepository;
  final WatchAllEventsUsecase watchAllEventsUsecase;

  List<EventDetailModel> _events = [];
  List<EventDetailModel> get events => _events;

  List<ProfileModel> userList = [];
  List<ProfileModel> get users => userList;

  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<TicketTypeModel> allTickets = [];
  List<TicketTypeModel> get ticketTypes => allTickets;

  DashboadViewModel(this.watchAllEventsUsecase, this._authRepository);

  void watchAll() {
    _subscription?.cancel();
    setBusy(true);
    clearError();
    try {
      _subscription = watchAllEventsUsecase.call().listen((list) {
        _events = list;
        _extractAllTickets();
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

  void _extractAllTickets() {
    allTickets.clear();
    for (var event in _events) {
      if (event.ticketType != null) {
        allTickets.addAll(event.ticketType!);
      }
    }
  }

  Future<void> fetchUsers() async {
    try {
      _setLoading(true);
      userList = await _authRepository.getAllProfiles();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError("Lỗi khi lấy users: $e");
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
