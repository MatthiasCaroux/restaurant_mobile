import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'details/restaurant_detail_page.dart';

class RestaurantMapHome extends StatefulWidget {
  final List<Map<String, dynamic>> restaurants;
  
  const RestaurantMapHome({
    super.key,
    required this.restaurants,
  });

  @override
  State<RestaurantMapHome> createState() => _RestaurantMapHomeState();
}

class _RestaurantMapHomeState extends State<RestaurantMapHome> {
  LatLng? _userLocation;
  final MapController _mapController = MapController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Les permissions sont refusées, on utilise le centre calculé
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // L'utilisateur a refusé définitivement, on utilise le centre calculé
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Obtenir la position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      
      // Petit délai pour permettre à la carte de se rendre
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Centrer la carte sur la position de l'utilisateur
      if (_userLocation != null) {
        _mapController.move(_userLocation!, 13);
      }
    } catch (e) {
      print("Erreur de localisation: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Carte des restaurants",
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: _userLocation ?? _calculateMapCenter(),
                            zoom: 13,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              tileProvider: CancellableNetworkTileProvider(),
                              userAgentPackageName: 'com.example.restaurantapp',
                            ),
                            MarkerLayer(
                              markers: [
                                ..._buildRestaurantMarkers(context),
                                // Ajout du marqueur de position utilisateur s'il est disponible
                                if (_userLocation != null)
                                  Marker(
                                    point: _userLocation!,
                                    width: 20,
                                    height: 20,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: FloatingActionButton.small(
                        onPressed: _getUserLocation,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.my_location, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LatLng _calculateMapCenter() {
    // Si pas de restaurants, on utilise le centre de la France
    if (widget.restaurants.isEmpty) {
      return const LatLng(46.603354, 1.888334); // Centre de la France
    }
    
    // Calculer la moyenne des lat/long de tous les restaurants
    double totalLat = 0;
    double totalLong = 0;
    int validCoords = 0;
    
    for (var restaurant in widget.restaurants) {
      final double? lat = _parseDouble(restaurant['latitude']);
      final double? long = _parseDouble(restaurant['longitude']);
      
      if (lat != null && long != null) {
        totalLat += lat;
        totalLong += long;
        validCoords++;
      }
    }
    
    if (validCoords > 0) {
      return LatLng(totalLat / validCoords, totalLong / validCoords);
    } else {
      return const LatLng(46.603354, 1.888334); // Centre de la France
    }
  }
  
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  List<Marker> _buildRestaurantMarkers(BuildContext context) {
    List<Marker> markers = [];
    
    for (var restaurant in widget.restaurants) {
      final double? lat = _parseDouble(restaurant['latitude']);
      final double? long = _parseDouble(restaurant['longitude']);
      
      if (lat != null && long != null) {
        markers.add(
          Marker(
            point: LatLng(lat, long),
            width: 14,
            height: 14,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantDetailPage(restaurant: restaurant),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
        );
      }
    }
    
    return markers;
  }
}