// lib/models/coupon.dart

class Coupon {
  final String id;
  final String code;
  final String storeName;
  final int discountPercentage;
  final Map<String, dynamic>? additionalData;

  Coupon({
    required this.id,
    required this.code,
    required this.storeName,
    required this.discountPercentage,
    this.additionalData,
  });

  factory Coupon.fromFirestore(
      Map<String, dynamic> firestoreMap, String documentId) {
    return Coupon(
      id: documentId,
      code: firestoreMap['coupon_code'] ?? '',
      storeName: firestoreMap['store_name'] ?? '',
      discountPercentage: firestoreMap['discount_percentage']?.toInt() ?? 0,
      additionalData: firestoreMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coupon_code': code,
      'store_name': storeName,
      'discount_percentage': discountPercentage,
    };
  }

  @override
  String toString() {
    return 'Coupon{id: $id, code: $code, storeName: $storeName, discountPercentage: $discountPercentage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coupon && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Coupon copyWith({
    String? id,
    String? code,
    String? storeName,
    int? discountPercentage,
    Map<String, dynamic>? additionalData,
  }) {
    return Coupon(
      id: id ?? this.id,
      code: code ?? this.code,
      storeName: storeName ?? this.storeName,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}

// Model for user's coupon reference
class UserCoupon {
  final String couponId;

  UserCoupon({
    required this.couponId,
  });

  factory UserCoupon.fromFirestore(Map<String, dynamic> firestoreMap) {
    return UserCoupon(
      couponId: firestoreMap['coupon_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coupon_id': couponId,
    };
  }

  @override
  String toString() => 'UserCoupon{couponId: $couponId}';
}
