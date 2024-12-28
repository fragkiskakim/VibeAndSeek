// lib/services/wishlist_locations_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../wishlist_location.dart';

class WishlistLocationsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<WishlistLocation>> getWishlistLocationsStream(String userId) {
    print('Fetching wishlist locations for user: $userId');

    return _firestore
        .collection('User_Wishlist')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists || userDoc.data() == null) {
        print('No wishlist document found');
        return [];
      }

      try {
        final data = userDoc.data()!;
        print('User wishlist data: $data');

        Set<String> locationIds = {};

        // Handle numbered fields (1, 2, 3, etc.)
        data.forEach((key, value) {
          if (value is Map && value.containsKey('location_id')) {
            locationIds.add(value['location_id'].toString());
          }
        });

        // Also handle the direct location_id field if it exists
        if (data.containsKey('location_id')) {
          if (data['location_id'] is List) {
            locationIds.addAll(List<String>.from(data['location_id']));
          } else if (data['location_id'] is String) {
            locationIds.add(data['location_id']);
          }
        }

        print('Found wishlist location IDs: $locationIds');

        if (locationIds.isEmpty) {
          return [];
        }

        List<WishlistLocation> locations = [];

        await Future.wait(
          locationIds.map((id) async {
            try {
              var locDoc =
                  await _firestore.collection('Locations').doc(id).get();
              if (locDoc.exists && locDoc.data() != null) {
                var locationData = locDoc.data()!;
                locationData['location_id'] = id;
                locations.add(WishlistLocation.fromJson(locationData));
                print('Added wishlist location: ${locDoc.id}');
              }
            } catch (e) {
              print('Error fetching location $id: $e');
            }
          }),
        );

        print('Returning ${locations.length} wishlist locations');
        return locations;
      } catch (e) {
        print('Error processing wishlist locations: $e');
        return [];
      }
    });
  }

  // Add a location to wishlist
  Future<void> addToWishlist(String userId, String locationId) async {
    try {
      // Get the current count of wishlist items
      DocumentSnapshot doc =
          await _firestore.collection('User_Wishlist').doc(userId).get();

      int nextIndex = 1;
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        nextIndex = data.length + 1;
      }

      // Add the new location with a numbered key
      await _firestore.collection('User_Wishlist').doc(userId).set({
        nextIndex.toString(): {
          'location_id': locationId,
          'added_at': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      print(
          'Successfully added location $locationId to wishlist at position $nextIndex');
    } catch (e) {
      print('Error adding to wishlist: $e');
      rethrow;
    }
  }

  // Remove a location from wishlist
  Future<void> removeFromWishlist(String userId, String locationId) async {
    try {
      // Get current wishlist document
      DocumentSnapshot doc =
          await _firestore.collection('User_Wishlist').doc(userId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Wishlist not found');
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Find the key(s) to remove based on location_id
      List<String> keysToRemove = [];
      data.forEach((key, value) {
        if (value is Map && value['location_id'] == locationId) {
          keysToRemove.add(key);
        }
      });

      // Remove all instances of the location
      if (keysToRemove.isNotEmpty) {
        Map<String, dynamic> updates = {};
        for (String key in keysToRemove) {
          updates[key] = FieldValue.delete();
        }

        await _firestore
            .collection('User_Wishlist')
            .doc(userId)
            .update(updates);

        print('Successfully removed location $locationId from wishlist');
      } else {
        print('Location $locationId not found in wishlist');
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
      rethrow;
    }
  }

  // Get a single location details
  Future<WishlistLocation?> getLocationDetails(String locationId) async {
    try {
      var doc = await _firestore.collection('Locations').doc(locationId).get();
      if (doc.exists && doc.data() != null) {
        var data = doc.data()!;
        data['location_id'] = locationId;
        return WishlistLocation.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching location details: $e');
      rethrow;
    }
  }
}
