import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../api/event_service.dart';
import '../models/event.dart';
import '../models/pagination.dart';

class EventProvider with ChangeNotifier {
  EventService? _eventService;

  List<Event> _events = [];
  int _currentPage = 1;
  int? _lastPage;
  bool _isLoading = false;
  String? _error;
  bool _hasMore = true;

  EventProvider({EventService? eventService}) {
    _eventService = eventService;
  }

  set eventService(EventService service) {
    _eventService = service;
  }

  List<Event> get events => _events;
  int get currentPage => _currentPage;
  int? get lastPage => _lastPage;
  bool get isLoading => _isLoading;
  bool get canLoadMore => _hasMore && !_isLoading;
  bool get hasError => _error != null;
  String? get error => _error;

  Future<void> loadInitialEvents() async {
    _resetState();
    await _fetchEvents();
  }

  Future<void> loadNextPage() async {
    if (canLoadMore) {
      _currentPage++;
      await _fetchEvents();
    }
  }

  Future<void> refreshEvents() async {
    _resetState();
    await _fetchEvents();
  }

  void _resetState() {
    _currentPage = 1;
    _events = [];
    _lastPage = null;
    _error = null;
    _hasMore = true;
    notifyListeners();
  }

  Future<void> _fetchEvents() async {
    if (_eventService == null || !_hasMore || _isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final pagination = await _eventService!.getEvents(page: _currentPage);

      // Convert meta values to integers safely
      _lastPage = _toInt(pagination.lastPage);
      final currentPageInt = _toInt(pagination.currentPage);
      final lastPageInt = _toInt(pagination.lastPage);

      _hasMore = currentPageInt < lastPageInt;

      if (_currentPage == 1) {
        _events = pagination.data;
      } else {
        _events.addAll(pagination.data);
      }
    } catch (e) {
      _error = e.toString();
      if (_currentPage > 1) _currentPage--;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return (value as num).toInt();
  }

  // Event management methods
  Future<void> createEvent(Event event, Uint8List? imageBytes) async {
    if (_eventService == null) return;

    try {
      final createdEvent = await _eventService!.createEvent(event, imageBytes);
      _events.insert(0, createdEvent);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create event: ${e.toString()}');
    }
  }

  Future<void> updateEvent(Event event, Uint8List? imageBytes) async {
    if (_eventService == null) return;

    try {
      final updatedEvent = await _eventService!.updateEvent(event, imageBytes);
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update event: ${e.toString()}');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    if (_eventService == null) return;

    try {
      await _eventService!.deleteEvent(eventId);
      _events.removeWhere((e) => e.id == eventId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete event: ${e.toString()}');
    }
  }

  // Add setter for currentPage
  set currentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}