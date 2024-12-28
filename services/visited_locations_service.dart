// lib/services/visited_locations_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../visited_location.dart';

class VisitedLocationsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<VisitedLocation>> getVisitedLocationsStream(String userId) {
    print('Fetching visited locations for user: $userId');

    return _firestore
        .collection('User_Visited')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists || userDoc.data() == null) {
        print('No user document found');
        return [];
      }

      try {
        final data = userDoc.data()!;
        print('User document data: $data');

        Set<String> locationIds = {};

        // Handle numbered fields (1, 2, 3, etc.)
        data.forEach((key, value) {
          if (value is Map && value.containsKey('location_id')) {
            locationIds.add(value['location_id'].toString());
          }
        });

        print('Found location IDs: $locationIds');

        if (locationIds.isEmpty) {
          return [];
        }

        List<VisitedLocation> locations = [];

        await Future.wait(
          locationIds.map((id) async {
            try {
              var locDoc =
                  await _firestore.collection('Locations').doc(id).get();
              if (locDoc.exists && locDoc.data() != null) {
                var locationData = locDoc.data()!;
                locationData['location_id'] = id;
                locations.add(VisitedLocation.fromJson(locationData));
                print('Added location: ${locDoc.id}');
              }
            } catch (e) {
              print('Error fetching location $id: $e');
            }
          }),
        );

        print('Returning ${locations.length} locations');
        return locations;
      } catch (e) {
        print('Error processing locations: $e');
        return [];
      }
    });
  }

  // Add a location to visited places
  Future<void> addToVisited(String userId, String locationId) async {
    try {
      // Get current document to determine next index
      DocumentSnapshot doc =
          await _firestore.collection('User_Visited').doc(userId).get();

      int nextIndex = 1;
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        nextIndex = data.length + 1;
      }

      // Add the new location with timestamp
      await _firestore.collection('User_Visited').doc(userId).set({
        nextIndex.toString(): {
          'location_id': locationId,
          'visited_at': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      print('Successfully added location $locationId to visited places');
    } catch (e) {
      print('Error adding to visited places: $e');
      rethrow;
    }
  }

  // Remove a location from visited places
  Future<void> removeFromVisited(String userId, String locationId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('User_Visited').doc(userId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Visited document not found');
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> updates = {};

      data.forEach((key, value) {
        if (value is Map<String, dynamic> &&
            value['location_id'] != null &&
            value['location_id'].toString() == locationId) {
          updates[key] = FieldValue.delete();
        }
      });

      if (updates.isNotEmpty) {
        await _firestore.collection('User_Visited').doc(userId).update(updates);

        print('Successfully removed location $locationId from visited places');
      } else {
        print('Location $locationId not found in visited places');
      }
    } catch (e) {
      print('Error removing from visited places: $e');
      rethrow;
    }
  }

  // Check if a location is visited
  Future<bool> isLocationVisited(String userId, String locationId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('User_Visited').doc(userId).get();

      if (!doc.exists || doc.data() == null) return false;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return data.values.any((value) =>
          value is Map &&
          value['location_id'] != null &&
          value['location_id'].toString() == locationId);
    } catch (e) {
      print('Error checking visited status: $e');
      return false;
    }
  }
}
