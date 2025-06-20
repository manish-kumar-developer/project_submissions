import 'package:dio/dio.dart';
import 'package:frontend_flutter/api/api_client.dart';
import 'package:frontend_flutter/models/event.dart';
import 'package:frontend_flutter/models/pagination.dart';

class EventService {
  final ApiClient _apiClient = ApiClient();

  Future<PaginationResponse<Event>> getEvents({int? cursor}) async {

    final response = await _apiClient.get('/events');
    return PaginationResponse<Event>.fromJson(
      response.data,
          (json) => Event.fromJson(json),
    );
  }

  Future<Event> getEvent(int id) async {
    final response = await _apiClient.get('/events/$id');
    return Event.fromJson(response.data['data']);
  }

  Future<Event> createEvent(Event event, List<int>? imageBytes) async {
    final data = {
      'name': event.name,
      'description': event.description,
      'event_date': event.eventDate.toIso8601String(),
    };

    if (imageBytes != null) {
      data['image'] = MultipartFile.fromBytes(imageBytes, filename: 'event.jpg') as String;
    }

    final response = await _apiClient.postFormData('/events', data);
    return Event.fromJson(response.data['data']);
  }

  Future<Event> updateEvent(Event event, List<int>? imageBytes) async {
    final data = {
      'name': event.name,
      'description': event.description,
      'event_date': event.eventDate.toIso8601String(),
    };

    if (imageBytes != null) {
      data['image'] = MultipartFile.fromBytes(imageBytes, filename: 'event.jpg') as String;
    }

    final response = await _apiClient.putFormData('/events/${event.id}', data);
    return Event.fromJson(response.data['data']);
  }

  Future<void> deleteEvent(int id) async {
    await _apiClient.delete('/events/$id');
  }
}