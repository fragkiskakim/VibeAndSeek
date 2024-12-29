import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'location_info.dart';
import 'app_styles.dart';
import 'filter_panel.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/header_1_line.dart';
//import '../../themes/text_styles.dart';
import '../utils/global_state.dart';
import 'wishlist_locations_service.dart';

// lib/screens/main_map.dart
import 'visited_locations_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng athensCenter = LatLng(37.9838, 23.7275);
  String? activeMarkerId;
  bool isAnyInfoVisible = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WishlistLocationsService _wishlistService = WishlistLocationsService();
  final VisitedLocationsService _visitedService = VisitedLocationsService();
  final String? userId = GlobalState().currentUserId;
  Set<String> favorites = {};
  Set<String> visited = {};

  // Initialize with all types
  final Set<String> activeFilters = {
    'museum',
    'tourist_attraction',
    'bar',
    'restaurant',
    'cafe',
    'park',
    'natural_feature',
    'neighborhood',
    'library',
    'stadium',
    'store',
  };

  final Map<String, Color> typeColors = {
    'museum': Colors.brown,
    'tourist_attraction': Colors.blue,
    'bar': Colors.purple,
    'restaurant': Colors.red,
    'cafe': Colors.orange,
    'park': Colors.green,
    'natural_feature': Colors.teal,
    'neighborhood': Colors.amber,
    'library': Colors.indigo,
    'stadium': Colors.deepOrange,
    'store': Colors.pink,
  };

  @override
  void initState() {
    super.initState();
    _loadUserWishlist();
    _loadVisitedLocations();
  }

  Future<void> _loadUserWishlist() async {
    _firestore
        .collection('User_Wishlist')
        .doc('user3')
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return;

      Set<String> newFavorites = {};
      final data = snapshot.data()!;

      data.forEach((key, value) {
        if (value is Map && value.containsKey('location_id')) {
          newFavorites.add(value['location_id'].toString());
        }
      });

      if (mounted) {
        setState(() {
          favorites = newFavorites;
        });
      }
    });
  }

  Future<void> _loadVisitedLocations() async {
    _firestore
        .collection('User_Visited')
        .doc('user3')
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return;

      Set<String> newVisited = {};
      final data = snapshot.data()!;

      data.forEach((key, value) {
        if (value is Map && value.containsKey('location_id')) {
          newVisited.add(value['location_id'].toString());
        }
      });

      if (mounted) {
        setState(() {
          visited = newVisited;
        });
      }
    });
  }

  void updateInfoVisibility(bool isVisible, String markerId) {
    setState(() {
      if (isVisible && activeMarkerId != null && activeMarkerId != markerId) {
        return;
      }
      isAnyInfoVisible = isVisible;
      activeMarkerId = isVisible ? markerId : null;
    });
  }

  Future<void> toggleFavorite(String locationId) async {
    try {
      if (favorites.contains(locationId)) {
        await _wishlistService.removeFromWishlist(locationId);
        setState(() {
          favorites.remove(locationId);
        });
      } else {
        await _wishlistService.addToWishlist(locationId);
        setState(() {
          favorites.add(locationId);
        });
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            favorites.contains(locationId)
                ? 'Added to wishlist'
                : 'Removed from wishlist',
            style: const TextStyle(fontFamily: 'Finlandica'),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling favorite: $e');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update wishlist',
            style: TextStyle(fontFamily: 'Finlandica'),
          ),
        ),
      );
    }
  }

  Future<void> toggleVisited(String locationId) async {
    try {
      if (visited.contains(locationId)) {
        await _visitedService.removeFromVisited(locationId);
        setState(() {
          visited.remove(locationId);
        });
      } else {
        await _visitedService.addToVisited(locationId);
        setState(() {
          visited.add(locationId);
        });
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            visited.contains(locationId)
                ? 'Marked as visited'
                : 'Removed from visited places',
            style: const TextStyle(fontFamily: 'Finlandica'),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling visited: $e');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update visited places',
            style: TextStyle(fontFamily: 'Finlandica'),
          ),
        ),
      );
    }
  }

  void handleFiltersChanged(Set<String> newFilters) {
    if (!mounted) return;
    setState(() {
      activeFilters.clear();
      activeFilters.addAll(newFilters);
    });
  }

  Color getColorForType(String type) {
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }

  List<Marker> _createMarkers(List<DocumentSnapshot> locations) {
    if (activeFilters.isEmpty) return [];

    return locations.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final locationType = data['types']?[0] ?? 'point_of_interest';
      return activeFilters.contains(locationType);
    }).map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final markerId = doc.id;
      final locationType = data['types']?[0] ?? 'point_of_interest';

      return Marker(
        width: 40,
        height: 40,
        point: LatLng(
          data['latitude'] as double,
          data['longitude'] as double,
        ),
        builder: (ctx) => Stack(
          children: [
            ClickableMarker(
              markerId: markerId,
              isActive: activeMarkerId == markerId,
              color: getColorForType(locationType),
              locationInfo: LocationInfo(
                name: data['name'] ?? 'Unknown Location',
                rating: data['rating']?.toString() ?? 'N/A',
                description: data['description'] ?? 'No description available',
                type: locationType.toString().replaceAll('_', ' '),
                address: data['address'] ?? 'No address available',
              ),
              onInfoVisibilityChanged: (isVisible) =>
                  updateInfoVisibility(isVisible, markerId),
            ),
            if (visited.contains(markerId))
              const Positioned(
                bottom: -8,
                right: -8,
                child: Icon(
                  Icons.push_pin,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            if (favorites.contains(markerId))
              const Positioned(
                top: -8,
                right: -8,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 16,
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: Column(
        children: [
          // Header
          const SimpleHeader(
            title: 'MAP',
            underlineWidth: 150,
          ),

          // Main content (map and markers)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('Locations').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final locations = snapshot.data!.docs;

                return Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        center: athensCenter,
                        zoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: _createMarkers(locations),
                        ),
                      ],
                    ),
                    FilterPanel(
                      onFiltersChanged: handleFiltersChanged,
                      typeColors: typeColors,
                      activeFilters: activeFilters,
                    ),
                    if (isAnyInfoVisible && activeMarkerId != null)
                      StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection('Locations')
                            .doc(activeMarkerId)
                            .snapshots(),
                        builder: (context, locationSnapshot) {
                          if (!locationSnapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final locationData = locationSnapshot.data!.data()
                              as Map<String, dynamic>;

                          return Stack(
                            children: [
                              // Blurred background
                              Positioned.fill(
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              // Close on background tap
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isAnyInfoVisible = false;
                                      activeMarkerId = null;
                                    });
                                  },
                                  child: Container(color: Colors.transparent),
                                ),
                              ),
                              // Location info card
                              Positioned(
                                top: 20,
                                left: 20,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Material(
                                    elevation: 12,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppStyles.blueColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Text(
                                              locationData['name'] ??
                                                  'Unknown Location',
                                              style: AppStyles.nameOfPoint,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          if (locationData['rating'] !=
                                              null) ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (index) {
                                                      final rating = double.tryParse(
                                                              locationData[
                                                                      'rating']
                                                                  .toString()) ??
                                                          0;
                                                      if (index <
                                                          rating.floor()) {
                                                        return const Icon(
                                                            Icons.star,
                                                            size: 16,
                                                            color:
                                                                Colors.amber);
                                                      } else if (index <
                                                          rating) {
                                                        return const Icon(
                                                            Icons.star_half,
                                                            size: 16,
                                                            color:
                                                                Colors.amber);
                                                      } else {
                                                        return Icon(
                                                            Icons.star_outline,
                                                            size: 16,
                                                            color: Colors
                                                                .grey[300]);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '(${locationData['rating']})',
                                                  style: AppStyles
                                                      .descriptionOfPoint,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                          Text(
                                            locationData['address'] ??
                                                'No address available',
                                            style: AppStyles.descriptionOfPoint
                                                .copyWith(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            locationData['description'] ??
                                                'No description available',
                                            style: AppStyles.descriptionOfPoint,
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              (locationData['types']?[0] ??
                                                      'point of interest')
                                                  .toString()
                                                  .replaceAll('_', ' ')
                                                  .toUpperCase(),
                                              style: AppStyles
                                                  .descriptionOfPoint
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      visited.contains(
                                                              activeMarkerId)
                                                          ? Icons.push_pin
                                                          : Icons
                                                              .push_pin_outlined,
                                                      color: Colors.amber,
                                                    ),
                                                    onPressed: () =>
                                                        toggleVisited(
                                                            activeMarkerId!),
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  IconButton(
                                                    icon: Icon(
                                                      favorites.contains(
                                                              activeMarkerId)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: Colors.red[300],
                                                    ),
                                                    onPressed: () =>
                                                        toggleFavorite(
                                                            activeMarkerId!),
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close,
                                                    size: 24,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  setState(() {
                                                    isAnyInfoVisible = false;
                                                    activeMarkerId = null;
                                                  });
                                                },
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),

          // Navigation buttons at bottom
          const NavigationButtons(),
        ],
      ),
    );
  }
}

class ClickableMarker extends StatefulWidget {
  final String markerId;
  final bool isActive;
  final Color color;
  final LocationInfo locationInfo;
  final Function(bool) onInfoVisibilityChanged;

  const ClickableMarker({
    super.key,
    required this.markerId,
    required this.isActive,
    required this.color,
    required this.locationInfo,
    required this.onInfoVisibilityChanged,
  });

  @override
  State<ClickableMarker> createState() => _ClickableMarkerState();
}

class _ClickableMarkerState extends State<ClickableMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          onEnter: (_) {
            setState(() {
              isHovered = true;
              _controller.forward();
            });
          },
          onExit: (_) {
            setState(() {
              isHovered = false;
              _controller.reverse();
            });
          },
          child: GestureDetector(
            onTap: () => widget.onInfoVisibilityChanged(!widget.isActive),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                Icons.location_pin,
                color: widget.color,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
