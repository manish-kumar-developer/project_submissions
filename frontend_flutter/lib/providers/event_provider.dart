import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/event_service.dart';
import 'package:frontend_flutter/models/event.dart';


class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _events = [];
  int? _nextCursor;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadEvents() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _eventService.getEvents(cursor: _nextCursor);
      _events = [..._events, ...response.data];
      _nextCursor = response.pagination.nextCursor;
      _hasMore = response.pagination.hasMore;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load events: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> refreshEvents() async {
    if (_isRefreshing) return;

    try {
      _isRefreshing = true;
      notifyListeners();

      _events = [];
      _nextCursor = null;
      _hasMore = true;

      await loadEvents();

      _isRefreshing = false;
      notifyListeners();
    } catch (e) {
      _isRefreshing = false;
      _error = 'Refresh failed: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> createEvent(Event event, List<int>? imageBytes) async {
    try {
      final newEvent = await _eventService.createEvent(event, imageBytes);
      _events.insert(0, newEvent);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create event: ${e.toString()}');
    }
  }

  Future<void> updateEvent(Event event, List<int>? imageBytes) async {
    try {
      final updatedEvent = await _eventService.updateEvent(event, imageBytes);
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update event: ${e.toString()}');
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      await _eventService.deleteEvent(id);
      _events.removeWhere((event) => event.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete event: ${e.toString()}');
    }
  }
}