import 'package:dio/dio.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../models/geocoding_address_model.dart';

class GeocodingService {
  GeocodingService();

  /// Convert a lat,long (e.g. "90.6754,78.9876") into a human readable address.
  /// If `ApiConstants.googleMapsApiKey` is empty, returns a simulated address so
  /// the app can work offline/testing.
  Future<GeocodingAddressModel> getAddressFromLatLng(String latLng) async {
    // Normalize input and try to extract two numeric parts
    final cleaned = latLng.replaceAll(RegExp(r"[^0-9+\-.,]"), '');
    final parts = cleaned
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (parts.length < 2) {
      // Unable to parse lat/lng, return input so UI sees raw value and we can debug
      return GeocodingAddressModel(formattedAddress: latLng);
    }

    final lat = parts[0];
    final lng = parts[1];

    // Ensure they're numeric-ish
    final latNum = double.tryParse(lat);
    final lngNum = double.tryParse(lng);
    if (latNum == null || lngNum == null) {
      return GeocodingAddressModel(formattedAddress: latLng);
    }

    // If no Google API key is configured, attempt to use OpenStreetMap Nominatim
    // as a fallback to obtain a real formatted address.
    if (ApiConstants.googleMapsApiKey.isEmpty) {
      try {
        final dio = Dio();
        // Nominatim requires a valid User-Agent/Referer. Add a polite header.
        dio.options.headers['User-Agent'] =
            'flutter_lakshman1020/1.0 (+https://example.com)';
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
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data as Map<String, dynamic>;
          final displayName = data['display_name'] as String?;
          if (displayName != null && displayName.isNotEmpty) {
            return GeocodingAddressModel(formattedAddress: displayName);
          }
        }
      } catch (e) {
        // ignore and fall back to simulated
      }

      final simulated = _simulateAddress(lat, lng);
      return GeocodingAddressModel(formattedAddress: simulated);
    }

    // Otherwise use Google Maps Geocoding API
    try {
      final dio = Dio();
      final url = 'https://maps.googleapis.com/maps/api/geocode/json';
      final response = await dio.get(
        url,
        queryParameters: {
          'latlng': '$lat,$lng',
          'key': ApiConstants.googleMapsApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if ((data['results'] as List).isNotEmpty) {
          final first = data['results'][0] as Map<String, dynamic>;
          return GeocodingAddressModel.fromJson(first);
        }
      }

      // fallback
      return GeocodingAddressModel(formattedAddress: '$lat, $lng');
    } catch (e) {
      // If any error occurs, return the lat,lng as fallback
      return GeocodingAddressModel(formattedAddress: '$lat, $lng');
    }
  }

  String _simulateAddress(String lat, String lng) {
    // Very lightweight deterministic simulation so tests are predictable
    final latShort = lat.contains('.') ? lat.split('.').first : lat;
    final lngShort = lng.contains('.') ? lng.split('.').first : lng;
    return 'Simulated Address at $latShort.$lngShort Road, Demo City';
  }
}
