// lib/models/wishlist_location.dart

class WishlistLocation {
  final String locationId;
  final String? name;
  final String? description;
  final String? category;
  final Map<String, dynamic>? additionalData;

  WishlistLocation({
    required this.locationId,
    this.name,
    this.description,
    this.category,
    this.additionalData,
  });

  factory WishlistLocation.fromJson(Map<String, dynamic> json) {
    return WishlistLocation(
      locationId: json['location_id'] ?? '',
      name: json['name'],
      description: json['description'],
      category: json['category'],
      additionalData: json,
    );
  }
}
