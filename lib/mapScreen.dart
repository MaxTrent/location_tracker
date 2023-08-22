import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String userId;
  const MapScreen(this.userId, {super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(_added){
              myMap(snapshot);
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GoogleMap(
              mapType: MapType.normal,
              markers: {
                Marker(
                  markerId: const MarkerId('id'),
                  position: LatLng(
                      snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.userId)['latitude'],
                      snapshot.data!.docs.singleWhere((element) =>
                          element.id == widget.userId)['longitude']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta),
                )
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.userId)['latitude'],
                      snapshot.data!.docs.singleWhere((element) =>
                          element.id == widget.userId)['longitude']),
                  zoom: 14.45),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = false;
                });
              },
            );
          }),
    );
  }

  Future<void> myMap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.userId)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.userId)['longitude']),
            zoom: 14.47)));
  }
}
