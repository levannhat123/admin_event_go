import 'dart:async';
import 'dart:io';

import 'package:admin_event_go/core/base/base_view_model.dart';
import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:admin_event_go/data/models/event/event_detail_model.dart';
import 'package:admin_event_go/data/models/event/ticket_type_model.dart';
import 'package:admin_event_go/domain/usecase/event/add_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/update_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/delete_event_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/get_event_by_id_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/get_all_events_usecase.dart';
import 'package:admin_event_go/domain/usecase/event/watch_all_events_usecase.dart';
import 'package:admin_event_go/presentation/view_models/dashboad_view_model.dart';
import 'package:flutter/material.dart';

class EventViewModel extends BaseViewModel {
  final DashboadViewModel dashboardViewModel;
  final AddEventUsecase addEventUsecase;
  final UpdateEventUsecase updateEventUsecase;
  final DeleteEventUsecase deleteEventUsecase;
  final GetEventByIdUsecase getEventByIdUsecase;
  final GetAllEventsUsecase getAllEventsUsecase;
  final WatchAllEventsUsecase watchAllEventsUsecase;

  EventDetailModel? _selectedEvent;
  StreamSubscription<List<EventDetailModel>>? _subscription;

  List<EventDetailModel> get events => dashboardViewModel.events;
  EventDetailModel? get selectedEvent => _selectedEvent;

  EventViewModel(
    this.dashboardViewModel, {
    required this.addEventUsecase,
    required this.updateEventUsecase,
    required this.deleteEventUsecase,
    required this.getEventByIdUsecase,
    required this.getAllEventsUsecase,
    required this.watchAllEventsUsecase,
  });

  Future<bool> addEvent(EventDetailModel event) async {
    setBusy(true);
    clearError();
    try {
      await addEventUsecase.call(event);
      setBusy(false);
      return true;
    } catch (e) {
      setError('Failed to add event: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<bool> updateEvent(String eventId, EventDetailModel event) async {
    setBusy(true);
    clearError();

    try {
      await updateEventUsecase.call(eventId, event);
      setBusy(false);
      return true;
    } catch (e) {
      setError('Failed to update event: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    setBusy(true);
    clearError();

    try {
      await deleteEventUsecase.call(eventId);
      events.removeWhere((event) => event.id == eventId);
      notifyListeners();
      setBusy(false);
      return true;
    } catch (e) {
      setError('Failed to delete event: ${e.toString()}');
      setBusy(false);
      return false;
    }
  }

  Future<void> getEventById(String eventId) async {
    setBusy(true);
    clearError();

    try {
      _selectedEvent = await getEventByIdUsecase.call(eventId);
      setBusy(false);
      notifyListeners();
    } catch (e) {
      setError('Failed to get event: ${e.toString()}');
      setBusy(false);
    }
  }

  void watchAll() {
    dashboardViewModel.watchAll();
  }

  void clearSelectedEvent() {
    _selectedEvent = null;
    notifyListeners();
  }

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final addressController = TextEditingController();
  final orgNameController = TextEditingController();
  final orgDescController = TextEditingController();
  final minPriceController = TextEditingController();
  final idLocationController = TextEditingController();

  String? status = 'ACTIVE';
  CategoryModel? selectedCategory;
  bool isFree = false;
  bool isHot = false;
  DateTime? startTime;
  DateTime? endTime;

  List<TicketTypeModel> ticketTypes = [];
  File? bannerImageFile;
  File? logoImageFile;
  String? existingBannerUrl;
  String? existingLogoUrl;

  void loadEventForEdit(EventDetailModel e) {
    titleController.text = e.title;
    descController.text = e.description ?? '';
    locationController.text = e.venue ?? '';
    addressController.text = e.address ?? '';
    orgNameController.text = e.orgName ?? '';
    orgDescController.text = e.orgDescription ?? '';
    minPriceController.text = e.minTicketPrice?.toString() ?? '';
    idLocationController.text = e.locationId ?? '';
    status = e.status ?? 'ACTIVE';
    selectedCategory = e.categories;
    ticketTypes = List.from(e.ticketType ?? []);
    isFree = e.isFree ?? false;
    isHot = e.isHot ?? false;
    startTime = e.startTime;
    endTime = e.endTime;
    existingBannerUrl = e.bannerURL;
    existingLogoUrl = e.orgLogoURL;
    bannerImageFile = null;
    logoImageFile = null;
    notifyListeners();
  }

  void setStatus(String v) {
    status = v;
    notifyListeners();
  }

  void setCategory(CategoryModel v) {
    selectedCategory = v;
    notifyListeners();
  }

  void setIsFree(bool v) {
    isFree = v;
    notifyListeners();
  }

  void setIsHot(bool v) {
    isHot = v;
    notifyListeners();
  }

  void setStartTime(DateTime v) {
    startTime = v;
    notifyListeners();
  }

  void setEndTime(DateTime v) {
    endTime = v;
    notifyListeners();
  }

  void setBannerImage(File? file) {
    bannerImageFile = file;
    notifyListeners();
  }

  void setLogoImage(File? file) {
    logoImageFile = file;
    notifyListeners();
  }

  void addTicketType(TicketTypeModel ticket) {
    ticketTypes.add(ticket);
    notifyListeners();
  }

  void updateTicketType(TicketTypeModel ticket) {
    final index = ticketTypes.indexWhere((t) => t.id == ticket.id);
    if (index != -1) ticketTypes[index] = ticket;
    notifyListeners();
  }

  void deleteTicketType(String id) {
    ticketTypes.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearForm() {
    titleController.clear();
    descController.clear();
    locationController.clear();
    addressController.clear();
    orgNameController.clear();
    orgDescController.clear();
    minPriceController.clear();
    idLocationController.clear();
    status = 'ACTIVE';
    selectedCategory = null;
    bannerImageFile = null;
    logoImageFile = null;
    existingBannerUrl = null;
    existingLogoUrl = null;
    startTime = null;
    endTime = null;
    isFree = false;
    isHot = false;
    ticketTypes.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    locationController.dispose();
    addressController.dispose();
    orgNameController.dispose();
    orgDescController.dispose();
    minPriceController.dispose();
    idLocationController.dispose();

    _subscription?.cancel();
    super.dispose();
  }
}
