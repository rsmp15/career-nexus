import 'dart:convert';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:dio/dio.dart';
import '../models/machine.dart';
import 'api_client.dart';

class InventoryService {
  final ApiClient apiClient;

  InventoryService(this.apiClient);

  Future<List<Machine>> getMachines({
    double? lat,
    double? lng,
    double radius = 5000,
    String? category,
    String? owner,
  }) async {
    final query = <String, dynamic>{};
    if (lat != null && lng != null) {
      query['point'] = '$lng,$lat';
      query['dist'] = radius;
    }
    if (category != null) query['category'] = category;
    if (owner != null) query['owner'] = owner;

    final response = await apiClient.dio.get(
      '/api/machines/',
      queryParameters: query,
    );

    final features = response.data['features'] as List;
    return features.map((f) {
      final props = f['properties'] as Map<String, dynamic>;
      props['id'] = f['id'];
      props['location'] = f['geometry'];
      return Machine.fromJson(props);
    }).toList();
  }

  Future<Machine> createMachine(Machine machine, {String? imagePath}) async {
    // If image is present, use FormData
    if (imagePath != null) {
      final Map<String, dynamic> data = machine.toJson();
      // Ensure category is lowercase for backend
      if (data['category'] != null) {
        data['category'] = data['category'].toString().toLowerCase();
      }
      final formData = FormData();

      // Add fields
      data.forEach((key, value) {
        if (key == 'location') {
          // Send location as JSON string for GeoJSON field
          formData.fields.add(MapEntry(key, jsonEncode(value)));
        } else if (value != null && key != 'image') {
          // Skip existing image url if any
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add file
      formData.files.add(
        MapEntry('image', await MultipartFile.fromFile(imagePath)),
      );

      final response = await apiClient.dio.post(
        '/api/machines/',
        data: formData,
      );

      // Handle response
      final resData = response.data;
      if (resData['type'] == 'Feature') {
        final props = resData['properties'] as Map<String, dynamic>;
        props['id'] = resData['id'];
        props['location'] = resData['geometry'];
        return Machine.fromJson(props);
      }
      return Machine.fromJson(resData);
    } else {
      // Standard JSON
      final Map<String, dynamic> data = machine.toJson();
      if (data['category'] != null) {
        data['category'] = data['category'].toString().toLowerCase();
      }
      final response = await apiClient.dio.post('/api/machines/', data: data);

      final responseData = response.data;
      if (responseData['type'] == 'Feature') {
        final props = responseData['properties'] as Map<String, dynamic>;
        props['id'] = responseData['id'];
        props['location'] = responseData['geometry'];
        return Machine.fromJson(props);
      }
      return Machine.fromJson(responseData);
    }
  }

  Future<List<Machine>> getMyMachines() async {
    final response = await apiClient.dio.get(
      '/api/machines/',
      queryParameters: {'owner': 'me'},
    );
    final features = response.data['features'] as List;
    return features.map((f) {
      final props = f['properties'] as Map<String, dynamic>;
      props['id'] = f['id'];
      props['location'] = f['geometry'];
      return Machine.fromJson(props);
    }).toList();
  }

  Future<void> deleteMachine(int id) async {
    await apiClient.dio.delete('/api/machines/$id/');
  }

  Future<Machine> addMachine({
    required String name,
    required String category,
    required double pricePerDay,
    required String description,
    required String imagePath,
  }) async {
    final machine = Machine(
      id: 0, // Temp ID
      name: name,
      category: category,
      pricePerHour: pricePerDay
          .toString(), // Mapping Day to Hour/Unit for now as string
      description: description,
      // location is required by backend. Using default (New Delhi) until Location Picker is added.
      location: {
        'type': 'Point',
        'coordinates': [77.2090, 28.6139],
      },
      // ownerId not in model, backend handles user from token
    );

    return createMachine(machine, imagePath: imagePath);
  }

  Future<Machine> updateMachine(Machine machine, {String? imagePath}) async {
    try {
      final url = '/api/machines/${machine.id}/';

      // If image is present, use FormData
      if (imagePath != null) {
        final Map<String, dynamic> data = machine.toJson();
        if (data['category'] != null) {
          data['category'] = data['category'].toString().toLowerCase();
        }
        final formData = FormData();

        // Add fields
        data.forEach((key, value) {
          if (key == 'location') {
            // Skip location in update
          } else if (value != null && key != 'image' && key != 'id') {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });

        // Add file
        formData.files.add(
          MapEntry('image', await MultipartFile.fromFile(imagePath)),
        );

        final response = await apiClient.dio.patch(url, data: formData);

        // Handle response
        final resData = response.data;
        if (resData['type'] == 'Feature') {
          final props = resData['properties'] as Map<String, dynamic>;
          props['id'] = resData['id'];
          props['location'] = resData['geometry'];
          return Machine.fromJson(props);
        }
        return Machine.fromJson(resData);
      } else {
        // Standard JSON PATCH
        final Map<String, dynamic> data = machine.toJson();
        if (data['category'] != null) {
          data['category'] = data['category'].toString().toLowerCase();
        }
        data.remove('image'); // Don't send null image if not updating

        final response = await apiClient.dio.patch(url, data: data);

        final responseData = response.data;
        if (responseData['type'] == 'Feature') {
          final props = responseData['properties'] as Map<String, dynamic>;
          props['id'] = responseData['id'];
          props['location'] = responseData['geometry'];
          return Machine.fromJson(props);
        }
        return Machine.fromJson(responseData);
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('DioException: ${e.message}');
        if (e.response != null) {
          debugPrint('Response Status: ${e.response?.statusCode}');
          debugPrint('Response Data: ${e.response?.data}');
        }
      }
      rethrow;
    }
  }
}
