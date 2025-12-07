import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:admin_event_go/core/base/base_view_model.dart';
import 'package:admin_event_go/core/constants/app_strings.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/data/models/event/ticket_type_model.dart';
import 'package:admin_event_go/data/models/profile_model.dart';
import 'package:admin_event_go/data/repositories/auth_repository.dart';
import 'package:admin_event_go/domain/usecase/event/watch_all_events_usecase.dart';

class DashboadViewModel extends BaseViewModel {
  StreamSubscription<List<EventDetailModel>>? _subscription;
  final AuthRepository _authRepository;
  final WatchAllEventsUsecase watchAllEventsUsecase;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _orderSub;
  double _totalRevenue = 0.0;
  int _totalOrders = 0;
  List<FlSpot> _dailyTicketSpots = [];
  List<String> _dayLabels = [];
  String get totalRevenueString =>
      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(_totalRevenue);
  String get totalOrdersString => _totalOrders.toString();
  List<FlSpot> get dailyTicketSpots => _dailyTicketSpots;
  List<String> get dayLabels => _dayLabels;
  double get maxDailyTickets {
    if (_dailyTicketSpots.isEmpty) return 10;
    double maxVal = _dailyTicketSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return maxVal == 0 ? 10 : maxVal;
  }

  List<EventDetailModel> _events = [];
  List<EventDetailModel> get events => _events;

  List<ProfileModel> userList = [];
  List<ProfileModel> get users => userList;
  List<ProfileModel> staffList = [];
  List<ProfileModel> get staff => staffList;

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
      _subscription = watchAllEventsUsecase.call().listen(
        (list) {
          _events = list;
          _extractAllTickets();
          setBusy(false);
          notifyListeners();
        },
        onError: (err) {
          setError('${AppStrings.watchEventsFailed}${err.toString()}');
          setBusy(false);
        },
      );
    } catch (e) {
      setError(
          '${AppStrings.startWatchingEventsFailed}${e.toString()}');
      setBusy(false);
    }

    _watchOrders();
  }

  void _watchOrders() {
    _orderSub?.cancel();
    _orderSub = _db
        .collectionGroup('orders')
        .snapshots()
        .listen(
          (snapshot) {
            double calculatedRevenue = 0.0;
            int calculatedOrders = snapshot.docs.length;

            for (var doc in snapshot.docs) {
              final data = doc.data();
              if (data['paymentStatus'] == 'completed') {
                calculatedRevenue += (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
              }
            }
            _processChartData(snapshot.docs);
            _totalRevenue = calculatedRevenue;
            _totalOrders = calculatedOrders;
            notifyListeners();
          },
          onError: (e) {
            print("Lỗi khi lắng nghe orders: $e");
          },
        );
  }

  void _processChartData(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final Map<int, int> dailyTicketCounts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var doc in docs) {
      final data = doc.data();
      final createdAtTimestamp = data['createdAt'] as Timestamp?;
      if (createdAtTimestamp == null) continue;

      final orderDate = createdAtTimestamp.toDate();
      final orderDateMidnight = DateTime(orderDate.year, orderDate.month, orderDate.day);

      final differenceInDays = today.difference(orderDateMidnight).inDays;

      if (differenceInDays >= 0 && differenceInDays <= 6) {
        int dayIndex = 6 - differenceInDays;

        final ticketsList = (data['tickets'] as List<dynamic>?) ?? [];
        int ticketsInThisOrder = 0;
        for (var item in ticketsList) {
          ticketsInThisOrder += (item['quantity'] as int? ?? 0);
        }

        dailyTicketCounts[dayIndex] = (dailyTicketCounts[dayIndex] ?? 0) + ticketsInThisOrder;
      }
    }

    final List<FlSpot> spots = [];
    final List<String> labels = [];
    final DateFormat dayFormatter = DateFormat('E');

    for (int i = 0; i <= 6; i++) {
      spots.add(FlSpot(i.toDouble(), dailyTicketCounts[i]!.toDouble()));
      final day = now.subtract(Duration(days: 6 - i));
      labels.add(dayFormatter.format(day));
    }

    _dailyTicketSpots = spots;
    _dayLabels = labels;
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
      _setError("${AppStrings.fetchUsersErrorWithDetails}$e");
    }
  }Future<void> fetchStaff() async {
    try {
      _setLoading(true);
      staffList = await _authRepository.getAllStaff();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError("${AppStrings.fetchUsersErrorWithDetails}$e");
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

  @override
  void dispose() {
    _subscription?.cancel();
    _orderSub?.cancel();
    super.dispose();
  }
}
