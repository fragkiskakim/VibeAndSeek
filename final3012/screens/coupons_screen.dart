import 'package:flutter/material.dart';
import 'coupons_service.dart';
import 'coupon.dart';
import 'package:flutter/services.dart';
import '../utils/global_state.dart';
import '../widgets/my_icon_profile.dart';
import '../widgets/bottom_nav_bar.dart';

class CouponsScreen extends StatefulWidget {
  final String? userId = GlobalState().currentUserId;

  CouponsScreen({
    super.key,
  });

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final CouponsService _service = CouponsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Back Button and Title
            const MyIconProfile(
              titlePart1: 'MY',
              titlePart2: 'PROFILE',
              iconPath: 'assets/images/my_profile_icon.png',
              underlinePath: 'assets/images/underline.png',
              underlineWidth: 180,
            ),
            const SizedBox(height: 50),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_offer,
                  color: Color(0xFF003366),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'MY COUPONS',
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CaesarDressing',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Coupons List
            Expanded(
              child: StreamBuilder<List<Coupon>>(
                stream: _service.getUserCouponsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorState('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
                      ),
                    );
                  }

                  final coupons = snapshot.data!;

                  if (coupons.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildCouponsList(coupons);
                },
              ),
            ),
            // Bottom Navigation Bar
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: Color(0xFF003366),
          ),
          SizedBox(height: 16),
          Text(
            'No coupons available',
            style: TextStyle(
              color: Color(0xFF003366),
              fontSize: 18,
              fontFamily: 'Finlandica',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Visit attractions to collect coupons',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Finlandica',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponsList(List<Coupon> coupons) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return _buildCouponCard(coupon);
      },
    );
  }

  Widget _buildCouponCard(Coupon coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EBD9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Store Name Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF003366),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_offer,
                  color: Color(0xFFF2EBD9),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    coupon.storeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Finlandica',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Coupon Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${coupon.discountPercentage}% OFF',
                      style: const TextStyle(
                        color: Color(0xFF003366),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Finlandica',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _copyCouponCode(coupon.code),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EBD9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          coupon.code,
                          style: const TextStyle(
                            color: Color(0xFF003366),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Finlandica',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to copy code',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Finlandica',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyCouponCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon code $code copied to clipboard!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF003366),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFF003366),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF003366),
                fontSize: 16,
                fontFamily: 'Finlandica',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontFamily: 'Finlandica'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
