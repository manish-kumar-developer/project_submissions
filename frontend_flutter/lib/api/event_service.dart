import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../models/event.dart';
import '../models/pagination.dart';
import 'api_client.dart';
import 'error_utils.dart';

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
      throw ErrorUtils.getFriendlyErrorMessage(e);
    } catch (e) {
      throw 'Failed to load events. Please try again.';
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

      final response = await apiClient.post('events', formData);
      final responseData = response.data as Map<String, dynamic>;
      return Event.fromJson(responseData['data'] ?? responseData);
    } on DioException catch (e) {
      throw ErrorUtils.getFriendlyErrorMessage(e);
    } catch (e) {
      throw 'Failed to create event. Please try again.';
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

      final response = await apiClient.put('events/${event.id}', formData);
      final responseData = response.data as Map<String, dynamic>;
      return Event.fromJson(responseData['data'] ?? responseData);
    } on DioException catch (e) {
      throw ErrorUtils.getFriendlyErrorMessage(e);
    } catch (e) {
      throw 'Failed to update event. Please try again.';
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      await apiClient.delete('events/$eventId');
    } on DioException catch (e) {
      throw ErrorUtils.getFriendlyErrorMessage(e);
    } catch (e) {
      throw 'Failed to delete event. Please try again.';
    }
  }
}