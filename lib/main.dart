import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(TaxiBasraApp());

class TaxiBasraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تكسي البصرة',
      theme: ThemeData(fontFamily: 'Cairo', primaryColor: Colors.orange),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng basraCenter = LatLng(30.5085, 47.7804);
  LatLng? myLocation;
  LatLng? pickup;
  LatLng? destination;
  bool isPickupSelected = true;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (serviceEnabled && permission != LocationPermission.denied) {
      Position pos = await Geolocator.getCurrentPosition();
      setState(() {
        myLocation = LatLng(pos.latitude, pos.longitude);
        pickup = myLocation;
        mapController.move(myLocation!, 15);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: basraCenter,
              initialZoom: 13,
              onTap: (tapPos, latLng) {
                setState(() {
                  if (isPickupSelected) {
                    pickup = latLng;
                  } else {
                    destination = latLng;
                  }
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.taxi.basra',
              ),
              MarkerLayer(markers: [
                if (myLocation != null)
                  Marker(point: myLocation!, width: 50, height: 50, child: Icon(Icons.my_location, color: Colors.blue, size: 35)),
                if (pickup != null)
                  Marker(point: pickup!, width: 60, height: 60, child: Icon(Icons.location_on, color: Colors.green, size: 45)),
                if (destination != null)
                  Marker(point: destination!, width: 60, height: 60, child: Icon(Icons.location_on, color: Colors.red, size: 45)),
              ]),
              if (pickup != null && destination != null)
                PolylineLayer(polylines: [
                  Polyline(points: [pickup!, destination!], color: Colors.orange, strokeWidth: 4)
                ])
            ],
          ),
          Positioned(
            top: 50, left: 15, right: 15,
            child: Column(
              children: [
                _buildSearchBox("من: موقعي الحالي - البصرة", Icons.my_location, true, pickup != null),
                SizedBox(height: 10),
                _buildSearchBox("إلى: اختر على الخريطة", Icons.search, false, destination != null),
              ],
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
              child: Column(
                children: [
                  Row(children: [
                    _typeCard("اقتصادي", "4,000 د.ع", Icons.directions_car, true),
                    _typeCard("بلي", "6,000 د.ع", Icons.local_taxi, false),
                    _typeCard("عائلي", "8,000 د.ع", Icons.airport_shuttle, false),
                  ]),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity, height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        if (pickup == null || destination == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("اختر نقطة الانطلاق والوصول على الخريطة")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم طلب التكسي! السائق قادم... 🚕")));
                        }
                      },
                      child: Text("اطلب تكسي البصرة الآن", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(String text, IconData icon, bool isPickup, bool active) {
    return GestureDetector(
      onTap: () => setState(() => isPickupSelected = isPickup),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: isPickupSelected == isPickup ? Colors.orange.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isPickupSelected == isPickup ? Colors.orange : Colors.grey.shade300, width: 2),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(children: [
          Icon(icon, color: isPickup ? Colors.green : Colors.red),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontWeight: FontWeight.bold))),
          if (active) Icon(Icons.check_circle, color: Colors.green, size: 20),
        ]),
      ),
    );
  }

  Widget _typeCard(String title, String price, IconData icon, bool selected) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colors.black : Colors.grey.shade300),
        ),
        child: Column(children: [
          Icon(icon, color: selected ? Colors.white : Colors.black),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: selected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(price, style: TextStyle(color: selected ? Colors.white70 : Colors.black54, fontSize: 10)),
        ]),
      ),
    );
  }
}
