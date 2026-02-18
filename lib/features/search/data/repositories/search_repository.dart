import 'dart:io';
import 'package:dio/dio.dart';
import '../models/search_intent_model.dart';

class SearchRepository {
  final Dio _dio;

  SearchRepository(this._dio);

  // Resolve base URL from dart-define or env; fallback to localhost
  String get _baseUrl {
    const defineUrl = String.fromEnvironment('API_BASE_URL');
    if (defineUrl.isNotEmpty) return defineUrl;

    final envUrl = Platform.environment['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) return envUrl;

    // Emulator loopback for Android
    // Using actual LAN IP to ensure connectivity from emulator/device
    // If this changes, update it here.
    return 'https://breezy-clubs-pull.loca.lt';
  }

  Future<SearchIntentModel> getIntent(String query) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/intent',
        data: {'query': query},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Unexpected response format from server');
      }

      return SearchIntentModel.fromJson(data);
    } catch (e) {
      // Basic error handling for now
      throw Exception('Failed to get intent: $e');
    }
  }
}
