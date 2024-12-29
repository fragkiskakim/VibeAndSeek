// lib/models/visited_location.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class VisitedLocation {
  final String locationId;
  final String? name;
  final String? description;
  final String? address;
  final double? rating;
  final String? type;
  final DateTime? visitedAt;
  final Map<String, dynamic>? additionalData;

  VisitedLocation({
    required this.locationId,
    this.name,
    this.description,
    this.address,
    this.rating,
    this.type,
    this.visitedAt,
    this.additionalData,
  });

  factory VisitedLocation.fromJson(Map<String, dynamic> json) {
    DateTime? visitedTimestamp;
    if (json['visited_at'] != null) {
      if (json['visited_at'] is DateTime) {
        visitedTimestamp = json['visited_at'];
      } else if (json['visited_at'] is Timestamp) {
        visitedTimestamp = (json['visited_at'] as Timestamp).toDate();
      }
    }

    return VisitedLocation(
      locationId: json['location_id'] ?? '',
      name: json['name'],
      description: json['description'],
      address: json['address'],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      type: json['types'] != null && (json['types'] as List).isNotEmpty
          ? json['types'][0].toString()
          : null,
      visitedAt: visitedTimestamp,
      additionalData: json,
    );
  }

  // Helper method to format the visited date
  String get formattedVisitedDate {
    if (visitedAt == null) return 'Date not available';
    return '${visitedAt!.day}/${visitedAt!.month}/${visitedAt!.year}';
  }

  // Helper method to get type display name
  String get typeDisplayName {
    if (type == null) return 'Unknown type';
    return type!.replaceAll('_', ' ').toUpperCase();
  }

  // Helper method to get rating display
  String get ratingDisplay {
    if (rating == null) return 'No rating';
    return rating!.toStringAsFixed(1);
  }

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'name': name,
      'description': description,
      'address': address,
      'rating': rating,
      'type': type,
      'visited_at': visitedAt?.toIso8601String(),
      ...?additionalData,
    };
  }
}
