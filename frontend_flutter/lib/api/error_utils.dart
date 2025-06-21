// lib/api/error_utils.dart
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ErrorUtils {
  static String getFriendlyErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    else if (error is String) {
      return error;
    }
    else {
      return "Something is wrong";
    }
  }

  static String _handleDioError(DioException e) {
    final response = e.response;

    // Handle specific status codes
    switch (response?.statusCode) {
      case 400:
        return _extractMessage(response) ?? 'Invalid request. Please check your input.';
      case 401:
        return _extractMessage(response)?? 'Your session has expired. Please log in again.';
      case 403:
        return _extractMessage(response)?? 'You don\'t have permission for this action.';
      case 404:
        return _extractMessage(response) ??'Resource not found. Please try again later.';
      case 422:
        return _extractValidationErrors(response) ?? 'Validation failed. Please check your input.';
      case 429:
        return _extractMessage(response)?? 'Too many requests. Please wait before trying again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return _handleNetworkErrors(e);
    }
  }


  static String? _extractMessage(Response? response) {
    if (response?.data is Map) {
      return response?.data['message']?.toString() ??
          response?.data['error']?.toString();
    }
    return response?.data?.toString();
  }

  static String? _extractValidationErrors(Response? response) {
    if (response?.data is Map) {
      final errors = response?.data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        return firstError.toString();
      }
    }
    return _extractMessage(response);
  }

  static String _handleNetworkErrors(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please connect to the internet.';
      case DioExceptionType.badCertificate:
        return 'Security error. Please contact support.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }


}