// lib/services/visited_locations_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'visited_location.dart';
import '../utils/global_state.dart';

class VisitedLocationsService {
  final String? userId = GlobalState().currentUserId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<VisitedLocation>> getVisitedLocationsStream() {
    if (kDebugMode) {
      print('Fetching visited locations for user: $userId');
    }

    return _firestore
        .collection('User_Visited')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists || userDoc.data() == null) {
        if (kDebugMode) {
          print('No user document found');
        }
        return [];
      }

      try {
        final data = userDoc.data()!;
        if (kDebugMode) {
          print('User document data: $data');
        }

        Set<String> locationIds = {};

        // Handle numbered fields (1, 2, 3, etc.)
        data.forEach((key, value) {
          if (value is Map && value.containsKey('location_id')) {
            locationIds.add(value['location_id'].toString());
          }
        });

        if (kDebugMode) {
          print('Found location IDs: $locationIds');
        }

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
                if (kDebugMode) {
                  print('Added location: ${locDoc.id}');
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error fetching location $id: $e');
              }
            }
          }),
        );

        if (kDebugMode) {
          print('Returning ${locations.length} locations');
        }
        return locations;
      } catch (e) {
        if (kDebugMode) {
          print('Error processing locations: $e');
        }
        return [];
      }
    });
  }

  // Add a location to visited places
  Future<void> addToVisited(String locationId) async {
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

      if (kDebugMode) {
        print('Successfully added location $locationId to visited places');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to visited places: $e');
      }
      rethrow;
    }
  }

  Future<void> removeFromVisited(String locationId) async {
  try {
    DocumentSnapshot doc = await _firestore.collection('User_Visited').doc(userId).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('Visited document not found');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<MapEntry<String, dynamic>> entries = [];
    
    // Collect all entries except the one to remove
    data.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          value['location_id'] != null &&
          value['location_id'].toString() != locationId) {
        entries.add(MapEntry(key, value));
      }
    });

    // Create new map with reindexed entries
    Map<String, dynamic> newData = {};
    for (int i = 0; i < entries.length; i++) {
      newData[(i + 1).toString()] = entries[i].value;
    }

    // Write the reindexed data back
    await _firestore.collection('User_Visited').doc(userId).set(newData);

    if (kDebugMode) {
      print('Successfully removed location $locationId from visited places');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error removing from visited places: $e');
    }
    rethrow;
  }
}

  // Check if a location is visited
  Future<bool> isLocationVisited(String locationId) async {
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
      if (kDebugMode) {
        print('Error checking visited status: $e');
      }
      return false;
    }
  }
}
