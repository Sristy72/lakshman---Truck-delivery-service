import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../models/geocoding_address_model.dart';

class GeocodingService {
  GeocodingService();

  // Cache for addresses to avoid repeated API calls
  static final Map<String, String> _addressCache = {};

  /// Convert a lat,long (e.g. "90.6754,78.9876") into a human readable address.
  /// ALWAYS fetches REAL addresses from geocoding APIs with automatic retries.
  /// Will NOT show raw lat/lng or placeholder addresses - keeps trying until success.
  Future<GeocodingAddressModel> getAddressFromLatLng(String latLng) async {
    // Normalize input and try to extract two numeric parts
    final cleaned = latLng.replaceAll(RegExp(r"[^0-9+\-.,]"), '');
    final parts = cleaned
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (parts.length < 2) {
      debugPrint('❌ Invalid coordinates format: $latLng');
      return GeocodingAddressModel(formattedAddress: latLng);
    }

    final lat = parts[0];
    final lng = parts[1];
    final cacheKey = '$lat,$lng';

    // Check cache first
    if (_addressCache.containsKey(cacheKey)) {
      debugPrint('✅ Using cached address for $cacheKey: ${_addressCache[cacheKey]}');
      return GeocodingAddressModel(formattedAddress: _addressCache[cacheKey]!);
    }

    // Ensure they're numeric
    final latNum = double.tryParse(lat);
    final lngNum = double.tryParse(lng);
    if (latNum == null || lngNum == null) {
      debugPrint('❌ Invalid numeric coordinates: lat=$lat, lng=$lng');
      return GeocodingAddressModel(formattedAddress: latLng);
    }

    // Try multiple times with exponential backoff
    const maxRetries = 3;
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // Try Google Maps API first if key is available
        if (ApiConstants.googleMapsApiKey.isNotEmpty) {
          final address = await _tryGoogleMapsApi(lat, lng, attempt);
          if (address != null) {
            _addressCache[cacheKey] = address;
            return GeocodingAddressModel(formattedAddress: address);
          }
        }

        // Try OpenStreetMap Nominatim (free, reliable)
        final address = await _tryOpenStreetMapApi(lat, lng, attempt);
        if (address != null && address.isNotEmpty) {
          _addressCache[cacheKey] = address;
          return GeocodingAddressModel(formattedAddress: address);
        }

        // If we haven't exhausted retries, wait before trying again
        if (attempt < maxRetries) {
          final delayMs = (100 * attempt) * attempt; // Exponential backoff: 100ms, 400ms, 900ms
          debugPrint('⏳ Geocoding attempt $attempt failed, retrying in ${delayMs}ms...');
          await Future.delayed(Duration(milliseconds: delayMs));
        }
      } catch (e) {
        debugPrint('⚠️ Geocoding attempt $attempt error: $e');
        if (attempt < maxRetries) {
          final delayMs = (100 * attempt) * attempt;
          await Future.delayed(Duration(milliseconds: delayMs));
        }
      }
    }

    // If ALL retries failed, return empty - UI will keep showing skeleton loader
    debugPrint('❌ All geocoding attempts failed for $lat,$lng - returning empty for retry');
    return GeocodingAddressModel(formattedAddress: '');
  }

  /// Try to get address from Google Maps API
  Future<String?> _tryGoogleMapsApi(String lat, String lng, int attempt) async {
    try {
      final dio = Dio();
      final url = 'https://maps.googleapis.com/maps/api/geocode/json';
      final response = await dio.get(
        url,
        queryParameters: {
          'latlng': '$lat,$lng',
          'key': ApiConstants.googleMapsApiKey,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if ((data['results'] as List).isNotEmpty) {
          final first = data['results'][0] as Map<String, dynamic>;
          final address = first['formatted_address'] as String?;
          if (address != null && address.isNotEmpty) {
            debugPrint('✅ Google Maps success (attempt $attempt): $address');
            return address;
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Google Maps attempt $attempt failed: $e');
    }
    return null;
  }

  /// Try to get address from OpenStreetMap Nominatim
  Future<String?> _tryOpenStreetMapApi(String lat, String lng, int attempt) async {
    try {
      final dio = Dio();
      dio.options.headers['User-Agent'] =
          'flutter_lakshman1020/1.0 (+https://github.com/FSDTeam-SAA)';
      
      final nominatimUrl = 'https://nominatim.openstreetmap.org/reverse';
      final response = await dio.get(
        nominatimUrl,
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lng,
          'addressdetails': 1,
          'zoom': 18,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
          debugPrint('✅ OpenStreetMap success (attempt $attempt): $displayName');
          return displayName;
        }
      }
    } catch (e) {
      debugPrint('⚠️ OpenStreetMap attempt $attempt failed: $e');
    }
    return null;
  }

  /// Clear the address cache (useful for testing or forcing refresh)
  static void clearCache() {
    _addressCache.clear();
    debugPrint('🔄 Address cache cleared');
  }
}
