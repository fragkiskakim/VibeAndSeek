// lib/services/coupons_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../coupon.dart';

class CouponsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Coupon>> getUserCouponsStream(String userId) {
    print('Fetching coupons for user: $userId');

    return _firestore
        .collection('User_Coupons')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists || userDoc.data() == null) {
        print('No user coupons document found');
        return [];
      }

      try {
        final data = userDoc.data()!;
        print('User coupons data: $data');

        Set<String> couponIds = {};

        // Handle numbered fields (1, 2, 3, etc.)
        data.forEach((key, value) {
          if (value is Map && value.containsKey('coupon_id')) {
            couponIds.add(value['coupon_id'].toString());
          } else if (value is String) {
            couponIds.add(value);
          }
        });

        print('Found coupon IDs: $couponIds');

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
                print('Added coupon: ${couponDoc.id}');
              }
            } catch (e) {
              print('Error fetching coupon $id: $e');
            }
          }),
        );

        print('Returning ${coupons.length} coupons');
        return coupons;
      } catch (e) {
        print('Error processing coupons: $e');
        return [];
      }
    });
  }

  // Add a coupon to a user's collection
  Future<void> addCouponToUser(String userId, String couponId) async {
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
      print('Error adding coupon to user: $e');
      throw e;
    }
  }

  // Remove a coupon from a user's collection
  Future<void> removeCouponFromUser(String userId, String couponId) async {
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
      print('Error removing coupon from user: $e');
      throw e;
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
      print('Error getting coupon by ID: $e');
      throw e;
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
      print('Error validating coupon: $e');
      return false;
    }
  }
}
