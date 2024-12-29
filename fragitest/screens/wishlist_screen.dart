// lib/screens/wishlist_screen.dart

import 'package:flutter/material.dart';
import 'wishlist_locations_service.dart';
import 'wishlist_location.dart';
import '../utils/global_state.dart';
import '../widgets/my_icon_profile.dart';
import '../widgets/bottom_nav_bar.dart';
// lib/screens/wishlist_screen.dart

class WishlistScreen extends StatefulWidget {
  final String? userId = GlobalState().currentUserId;

  WishlistScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistLocationsService _service = WishlistLocationsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with Profile Text
            Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                children: [
                  MyIconProfile(
                    titlePart1: 'MY',
                    titlePart2: 'PROFILE',
                    iconPath: 'assets/images/my_profile_icon.png',
                    underlinePath: 'assets/images/underline.png',
                    underlineWidth: 180,
                  ),
                  SizedBox(height: 20),
                  // Wishlist Header with Heart Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'WISHLIST',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaesarDressing',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Wishlist Items
            Expanded(
              child: StreamBuilder<List<WishlistLocation>>(
                stream: _service.getWishlistLocationsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorState('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return _buildLoadingState();
                  }

                  final locations = snapshot.data!;

                  if (locations.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Color(0xFF003366),
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Your wishlist is empty',
                            style: TextStyle(
                              color: Color(0xFF003366),
                              fontSize: 18,
                              fontFamily: 'Finlandica',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildWishlistItems(locations);
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

  Widget _buildWishlistItems(List<WishlistLocation> locations) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return _buildWishlistItem(location);
      },
    );
  }

  Widget _buildWishlistItem(WishlistLocation location) {
    return Dismissible(
      key: Key(location.locationId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Confirm Removal',
                style: TextStyle(
                  color: Color(0xFF003366),
                  fontFamily: 'Finlandica',
                ),
              ),
              content: const Text(
                'Are you sure you want to remove this location from your wishlist?',
                style: TextStyle(
                  fontFamily: 'Finlandica',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        try {
          await _service.removeFromWishlist(location.locationId);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Location removed from wishlist',
                style: TextStyle(fontFamily: 'Finlandica'),
              ),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () async {
                  try {
                    await _service.addToWishlist(location.locationId);
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Failed to restore location',
                          style: TextStyle(fontFamily: 'Finlandica'),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        } catch (e) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Failed to remove from wishlist',
                style: TextStyle(fontFamily: 'Finlandica'),
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF003366), width: 1),
        ),
        child: ListTile(
          leading: const Icon(
            Icons.play_arrow,
            color: Color(0xFF003366),
            size: 24,
          ),
          title: Text(
            location.name ?? 'Unknown Location',
            style: const TextStyle(
              color: Color(0xFF003366),
              fontFamily: 'Finlandica',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFF003366)),
          onTap: () => _showLocationDetails(location),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF003366)),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF003366),
            fontSize: 12,
            fontFamily: 'Finlandica',
          ),
        ),
      ],
    );
  }

  void _showLocationDetails(WishlistLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          location.name ?? 'Location Details',
          style: const TextStyle(
            fontFamily: 'Finlandica',
            color: Color(0xFF003366),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (location.description != null)
                Text(
                  location.description!,
                  style: const TextStyle(fontFamily: 'Finlandica'),
                ),
              if (location.category != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Category: ${location.category}',
                  style: const TextStyle(fontFamily: 'Finlandica'),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
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
