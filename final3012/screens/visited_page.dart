import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import '../widgets/header_1_line_descriptions.dart';
//import '../widgets/bottom_nav_bar.dart';
import 'visited_locations_service.dart';
import 'visited_location.dart';
import '../utils/global_state.dart';
import '../widgets/my_icon_profile.dart';
import '../widgets/bottom_nav_bar.dart';

class VisitedLocationsScreen extends StatefulWidget {
  final String? userId = GlobalState().currentUserId;

  VisitedLocationsScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VisitedLocationsScreenState createState() => _VisitedLocationsScreenState();
}

class _VisitedLocationsScreenState extends State<VisitedLocationsScreen> {
  final VisitedLocationsService _service = VisitedLocationsService();
  static const Color backgroundColor = Color(0xFFF2EBD9); // Beige background
  static const Color primaryColor = Color(0xFF2B3A67); // Dark blue
  static const Color accentColor = Color(0xFFE6B325); // Gold accent

  TextStyle get customTitleStyle => const TextStyle(
        color: primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Finlandica',
        letterSpacing: 1.2,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const MyIconProfile(
              titlePart1: 'MY',
              titlePart2: 'PROFILE',
              iconPath: 'assets/images/my_profile_icon.png',
              underlinePath: 'assets/images/underline.png',
              underlineWidth: 180,
            ),
            const SizedBox(height: 20),
            // Custom App Bar with updated styling
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  // Visited Header with Pin Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.push_pin,
                        color: accentColor,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'VISITED PLACES',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CaesarDressing',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Locations List with updated styling
            Expanded(
              child: StreamBuilder<List<VisitedLocation>>(
                stream: _service.getVisitedLocationsStream(),
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
                        children: [
                          const Icon(
                            Icons.push_pin_outlined,
                            color: primaryColor,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No visited places yet',
                            style: customTitleStyle.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildLocationsList(locations);
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

  Widget _buildLocationsList(List<VisitedLocation> locations) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return Dismissible(
          key: Key(location.locationId),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: backgroundColor),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: backgroundColor,
                  title: Text(
                    'Confirm Removal',
                    style: customTitleStyle.copyWith(fontSize: 20),
                  ),
                  content: const Text(
                    'Are you sure you want to remove this location from your visited places?',
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: 'Finlandica',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel',
                          style: TextStyle(color: primaryColor)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Remove',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) async {
            try {
              await _service.removeFromVisited(location.locationId);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Location removed from visited places',
                    style: TextStyle(fontFamily: 'Finlandica'),
                  ),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () async {
                      try {
                        await _service.addToVisited(location.locationId);
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
                    'Failed to remove from visited places',
                    style: TextStyle(fontFamily: 'Finlandica'),
                  ),
                ),
              );
            }
          },
          child: _buildLocationItem(location),
        );
      },
    );
  }

  Widget _buildLocationItem(VisitedLocation location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(
          Icons.push_pin,
          color: accentColor,
          size: 24,
        ),
        title: Text(
          location.name ?? 'Unknown Location',
          style: const TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Finlandica',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (location.type != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  location.typeDisplayName,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontFamily: 'Finlandica',
                  ),
                ),
              ),
            if (location.visitedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Visited on ${location.formattedVisitedDate}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'Finlandica',
                  ),
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: primaryColor),
        onTap: () => _showLocationDetails(location),
      ),
    );
  }

  void _showLocationDetails(VisitedLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          location.name ?? 'Location Details',
          style: customTitleStyle.copyWith(fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (location.description != null) ...[
                Text(
                  location.description!,
                  style: const TextStyle(
                    fontFamily: 'Finlandica',
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (location.address != null) ...[
                Text(
                  'Address: ${location.address}',
                  style: const TextStyle(
                    fontFamily: 'Finlandica',
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (location.rating != null) ...[
                Row(
                  children: [
                    const Text(
                      'Rating: ',
                      style: TextStyle(
                        fontFamily: 'Finlandica',
                        color: primaryColor,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < location.rating!
                              ? Icons.star
                              : Icons.star_border,
                          color: accentColor,
                          size: 16,
                        ),
                      ),
                    ),
                    Text(
                      ' (${location.ratingDisplay})',
                      style: const TextStyle(
                        fontFamily: 'Finlandica',
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Text(
                'Visited on: ${location.formattedVisitedDate}',
                style: const TextStyle(
                  fontFamily: 'Finlandica',
                  color: primaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
              color: primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: customTitleStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Finlandica',
                  color: backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
