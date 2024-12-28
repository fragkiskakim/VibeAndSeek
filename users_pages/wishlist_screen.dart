// lib/screens/wishlist_screen.dart

import 'package:flutter/material.dart';
import '../services/wishlist_locations_service.dart';
import '../wishlist_location.dart';
// lib/screens/wishlist_screen.dart

class WishlistScreen extends StatefulWidget {
  final String userId;

  const WishlistScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
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
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF003366)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'MY PROFILE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF003366),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Finlandica',
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // For balance
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Wishlist Header with Heart Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Finlandica',
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
                stream: _service.getWishlistLocationsStream(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorState('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return _buildLoadingState();
                  }

                  final locations = snapshot.data!;

                  if (locations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.group, 'Social'),
                  _buildNavItem(Icons.home, 'Home'),
                  _buildNavItem(Icons.map, 'Map'),
                ],
              ),
            ),
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
          await _service.removeFromWishlist(widget.userId, location.locationId);
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
                    await _service.addToWishlist(
                        widget.userId, location.locationId);
                  } catch (e) {
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
