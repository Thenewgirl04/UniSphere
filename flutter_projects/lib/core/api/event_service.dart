import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../models/uploaded_file.dart';

class EventService {
  EventService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<List<dynamic>> fetchPostedEvents() async {
    final response = await _api.get('/api/events/posted/');
    final data = ApiClient.decodeBody(response);

    if (response.statusCode != 200) {
      throw EventException('Failed to load events');
    }

    return List<dynamic>.from(data as List);
  }

  Future<Map<String, dynamic>> fetchMyEvents() async {
    final response = await _api.get('/api/events/mine/', authenticated: true);
    final data = ApiClient.decodeBody(response);

    if (response.statusCode != 200) {
      throw EventException('Failed to load your events');
    }

    return Map<String, dynamic>.from(data as Map);
  }

  Future<void> createEvent({
    required String name,
    required String category,
    required String description,
    required String date,
    required String time,
    String? contact,
  }) async {
    final response = await _api.post(
      '/api/events/',
      authenticated: true,
      body: {
        'name': name,
        'category': category,
        'description': description,
        'date': date,
        'time': time,
        'contact': contact ?? '',
      },
    );
    final data = ApiClient.decodeBody(response);

    if (response.statusCode != 201) {
      throw EventException(data.toString());
    }
  }

  Future<void> postApprovedEvent({
    required int eventId,
    UploadedFile? flyer,
  }) async {
    final files = <http.MultipartFile>[];
    if (flyer != null) {
      files.add(
        http.MultipartFile.fromBytes(
          'image',
          flyer.bytes,
          filename: flyer.filename,
        ),
      );
    }

    final response = await _api.multipart(
      '/api/events/$eventId/post/',
      method: 'POST',
      files: files,
      authenticated: true,
    );

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw EventException('Failed to publish event: $body');
    }
  }

  Future<Map<String, dynamic>> fetchOrgProfile() async {
    final response = await _api.get('/api/org/profile/', authenticated: true);
    final data = ApiClient.decodeBody(response);

    if (response.statusCode != 200) {
      throw EventException('Failed to load profile');
    }

    return Map<String, dynamic>.from(data as Map);
  }

  Future<void> updateOrgProfile({
    required String name,
    required String category,
    required String description,
    UploadedFile? logo,
  }) async {
    final files = <http.MultipartFile>[];
    if (logo != null) {
      files.add(
        http.MultipartFile.fromBytes(
          'logo',
          logo.bytes,
          filename: logo.filename,
        ),
      );
    }

    final response = await _api.multipart(
      '/api/org/profile/',
      method: 'PUT',
      fields: {
        'name': name,
        'category': category,
        'description': description,
      },
      files: files,
      authenticated: true,
    );

    if (response.statusCode != 200) {
      throw EventException('Failed to update profile');
    }
  }
}

class EventException implements Exception {
  EventException(this.message);
  final String message;

  @override
  String toString() => message;
}
