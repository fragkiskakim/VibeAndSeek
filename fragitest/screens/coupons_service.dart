// lib/services/coupons_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'coupon.dart';
import '../utils/global_state.dart';

class CouponsService {
  final String? userId = GlobalState().currentUserId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Coupon>> getUserCouponsStream() {
    if (kDebugMode) {
      print('Fetching coupons for user: $userId');
    }

    return _firestore
        .collection('User_Coupons')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists || userDoc.data() == null) {
        if (kDebugMode) {
          print('No user coupons document found');
        }
        return [];
      }

      try {
        final data = userDoc.data()!;
        if (kDebugMode) {
          print('User coupons data: $data');
        }

        Set<String> couponIds = {};

        // Handle numbered fields (1, 2, 3, etc.)
        data.forEach((key, value) {
          if (value is Map && value.containsKey('coupon_id')) {
            couponIds.add(value['coupon_id'].toString());
          } else if (value is String) {
            couponIds.add(value);
          }
        });

        if (kDebugMode) {
          print('Found coupon IDs: $couponIds');
        }

        if (couponIds.isEmpty) {
          return [];
        }

        List<Coupon> coupons = [];

        // Fetch actual coupon details from the Coupons collection
        await Future.wait(
          couponIds.map((id) async {
            try {
              var couponDoc =
                  await _firestore.collection('Coupons').doc(id).get();
              if (couponDoc.exists && couponDoc.data() != null) {
                var couponData = couponDoc.data()!;
                coupons.add(Coupon.fromFirestore(couponData, couponDoc.id));
                if (kDebugMode) {
                  print('Added coupon: ${couponDoc.id}');
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error fetching coupon $id: $e');
              }
            }
          }),
        );

        if (kDebugMode) {
          print('Returning ${coupons.length} coupons');
        }
        return coupons;
      } catch (e) {
        if (kDebugMode) {
          print('Error processing coupons: $e');
        }
        return [];
      }
    });
  }

  // Add a coupon to a user's collection
  Future<void> addCouponToUser(String couponId) async {
    try {
      // Get the current coupons document
      final userCouponsDoc =
          await _firestore.collection('User_Coupons').doc(userId).get();

      if (!userCouponsDoc.exists) {
        // If no document exists, create one with the first coupon
        await _firestore.collection('User_Coupons').doc(userId).set({
          '1': {'coupon_id': couponId}
        });
      } else {
        // If document exists, add the new coupon with the next available number
        final data = userCouponsDoc.data()!;
        int nextNumber = 1;
        while (data.containsKey(nextNumber.toString())) {
          nextNumber++;
        }

        await _firestore.collection('User_Coupons').doc(userId).update({
          nextNumber.toString(): {'coupon_id': couponId}
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding coupon to user: $e');
      }
      rethrow;
    }
  }

  // Remove a coupon from a user's collection
  Future<void> removeCouponFromUser(String couponId) async {
    try {
      final userCouponsDoc =
          await _firestore.collection('User_Coupons').doc(userId).get();

      if (userCouponsDoc.exists && userCouponsDoc.data() != null) {
        final data = userCouponsDoc.data()!;
        String? keyToRemove;

        // Find the key containing the coupon_id
        data.forEach((key, value) {
          if (value is Map &&
              value.containsKey('coupon_id') &&
              value['coupon_id'] == couponId) {
            keyToRemove = key;
          }
        });

        if (keyToRemove != null) {
          await _firestore
              .collection('User_Coupons')
              .doc(userId)
              .update({keyToRemove!: FieldValue.delete()});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing coupon from user: $e');
      }
      rethrow;
    }
  }

  // Get a single coupon by ID
  Future<Coupon?> getCouponById(String couponId) async {
    try {
      final couponDoc =
          await _firestore.collection('Coupons').doc(couponId).get();

      if (couponDoc.exists && couponDoc.data() != null) {
        return Coupon.fromFirestore(couponDoc.data()!, couponDoc.id);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting coupon by ID: $e');
      }
      rethrow;
    }
  }

  // Validate a coupon code
  Future<bool> validateCoupon(String couponCode) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('Coupons')
          .where('coupon_code', isEqualTo: couponCode)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error validating coupon: $e');
      }
      return false;
    }
  }
}
