import 'package:cleancity/sharedPref/UserStorage.dart';
import 'package:cleancity/utils/LocationHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  var user;
  LatLng? currentPosition;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadUser();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Position position = await LocationHelper.getCurrentLocation();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentPosition != null) {
        _mapController.move(currentPosition!, 20.0);
      }
    });
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserStorage.loadUserFromSharedPref();
    setState(() {
      user = loadedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(size: 40, Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName ?? "",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Reward Points : ${user.rewardPoints.toString()}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "You are here 📌",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),

              // Fixed height map
              SizedBox(
                height: 400,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: currentPosition!,
                    initialZoom: 17.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=YAYwAjQRuasjViM5q0Fo',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentPosition!,
                          width: 70,
                          height: 70,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
