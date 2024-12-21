import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'dart:ui';
import 'location_info.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng athensCenter = LatLng(37.9838, 23.7275);
  String? activeMarkerId;
  bool isAnyInfoVisible = false;
  late Map<String, dynamic> locations;
  final Set<String> favorites = {};
  final Set<String> visited = {};

  void updateInfoVisibility(bool isVisible, String markerId) {
    setState(() {
      if (isVisible && activeMarkerId != null && activeMarkerId != markerId) {
        return;
      }
      isAnyInfoVisible = isVisible;
      activeMarkerId = isVisible ? markerId : null;
    });
  }

  void toggleFavorite(String locationId) {
    setState(() {
      if (favorites.contains(locationId)) {
        favorites.remove(locationId);
      } else {
        favorites.add(locationId);
      }
    });
  }

  void toggleVisited(String locationId) {
    setState(() {
      if (visited.contains(locationId)) {
        visited.remove(locationId);
      } else {
        visited.add(locationId);
      }
    });
  }

  Color getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'museum':
        return Colors.brown;
      case 'tourist_attraction':
        return Colors.blue;
      case 'bar':
        return Colors.purple;
      case 'restaurant':
        return Colors.red;
      case 'cafe':
        return Colors.orange;
      case 'park':
        return Colors.green;
      case 'natural_feature':
        return Colors.teal;
      case 'neighborhood':
        return Colors.amber;
      case 'library':
        return Colors.indigo;
      case 'stadium':
        return Colors.deepOrange;
      case 'store':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  List<Marker> _createMarkers(Map<String, dynamic> locationsData) {
    List<Marker> markers = [];

    locationsData.forEach((key, location) {
      if (location['status'] == 'FOUND' &&
          location['latitude'] != null &&
          location['longitude'] != null) {
        final markerId = key;
        markers.add(
          Marker(
            width: 40,
            height: 40,
            point: LatLng(
              location['latitude'] as double,
              location['longitude'] as double,
            ),
            child: ClickableMarker(
              markerId: markerId,
              isActive: activeMarkerId == markerId,
              color:
                  getColorForType(location['types']?[0] ?? 'point_of_interest'),
              locationInfo: LocationInfo(
                name: location['name'] ?? 'Unknown Location',
                rating: location['rating']?.toString() ?? 'N/A',
                description:
                    location['description'] ?? 'No description available',
                type: location['types']?[0]?.toString().replaceAll('_', ' ') ??
                    'point of interest',
                address: location['address'] ?? 'No address available',
              ),
              onInfoVisibilityChanged: (isVisible) =>
                  updateInfoVisibility(isVisible, markerId),
            ),
          ),
        );
      }
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athens Attractions Map'),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(Icons.push_pin, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  visited.length.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red[300]),
                const SizedBox(width: 4),
                Text(
                  favorites.length.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future:
            DefaultAssetBundle.of(context).loadString('assets/locations.json'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            locations = json.decode(snapshot.data!);
            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: athensCenter,
                    initialZoom: 13.0,
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
                if (isAnyInfoVisible && activeMarkerId != null)
                  Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isAnyInfoVisible = false;
                              activeMarkerId = null;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          locations[activeMarkerId]['name'] ??
                                              'Unknown Location',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          visited.contains(activeMarkerId)
                                              ? Icons.push_pin
                                              : Icons.push_pin_outlined,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () =>
                                            toggleVisited(activeMarkerId!),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(
                                          favorites.contains(activeMarkerId)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red[300],
                                        ),
                                        onPressed: () =>
                                            toggleFavorite(activeMarkerId!),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 24),
                                        onPressed: () {
                                          setState(() {
                                            isAnyInfoVisible = false;
                                            activeMarkerId = null;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (locations[activeMarkerId]['rating'] !=
                                      null) ...[
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) {
                                              final rating = double.tryParse(
                                                      locations[activeMarkerId]
                                                              ['rating']
                                                          .toString()) ??
                                                  0;
                                              if (index < rating.floor()) {
                                                return const Icon(Icons.star,
                                                    size: 16,
                                                    color: Colors.amber);
                                              } else if (index < rating) {
                                                return const Icon(
                                                    Icons.star_half,
                                                    size: 16,
                                                    color: Colors.amber);
                                              } else {
                                                return Icon(Icons.star_outline,
                                                    size: 16,
                                                    color: Colors.grey[300]);
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '(${locations[activeMarkerId]['rating']})',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  Text(
                                    locations[activeMarkerId]['address'] ??
                                        'No address available',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    locations[activeMarkerId]['description'] ??
                                        'No description available',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      (locations[activeMarkerId]['types']?[0] ??
                                              'point of interest')
                                          .toString()
                                          .replaceAll('_', ' ')
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
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
    Key? key,
    required this.markerId,
    required this.isActive,
    required this.color,
    required this.locationInfo,
    required this.onInfoVisibilityChanged,
  }) : super(key: key);

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
      end: 2.5, // Increased scale for more noticeable hover effect
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
