import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../models/event.dart';
import '../models/pagination.dart';
import 'api_client.dart';

class EventService {
  final ApiClient apiClient;

  EventService({required this.apiClient});

  Future<Pagination<Event>> getEvents({int page = 1}) async {
    try {
      final response = await apiClient.get(
        '/events',
        params: {'page': page.toString()},
      );


      return Pagination.fromJson(
        response.data as Map<String, dynamic>,
            (json) => Event.fromJson(json),
      );
    } on DioException catch (e) {
      throw Exception('Failed to load events: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  Future<Event> createEvent(Event event, Uint8List? imageBytes) async {
    try {
      final formData = FormData.fromMap({
        'name': event.name,
        'description': event.description,
        'event_date': event.eventDate.toIso8601String(),
        if (imageBytes != null)
          'image': MultipartFile.fromBytes(
            imageBytes,
            filename: 'event_image.jpg',
          ),
      });

      // Use regular post method with FormData
      final response = await apiClient.post('events', formData);

      final responseData = response.data as Map<String, dynamic>;
      return Event.fromJson(responseData['data'] ?? responseData);
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to create event: $errorMessage');
    }
  }

  Future<Event> updateEvent(Event event, Uint8List? imageBytes) async {
    try {
      final formData = FormData.fromMap({
        'name': event.name,
        'description': event.description,
        'event_date': event.eventDate.toIso8601String(),
        if (imageBytes != null)
          'image': MultipartFile.fromBytes(
            imageBytes,
            filename: 'event_image.jpg',
          ),
      });

      // Use regular put method with FormData
      final response = await apiClient.put('events/${event.id}', formData);

      final responseData = response.data as Map<String, dynamic>;
      return Event.fromJson(responseData['data'] ?? responseData);
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to update event: $errorMessage');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      await apiClient.delete('events/$eventId');
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to delete event: $errorMessage');
    }
  }
}