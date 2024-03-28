import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _MapState();
}

class _MapState extends State<TestApp> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(10.732734759792725, 106.69977462350948), zoom: 16);
  BitmapDescriptor iconBitMap = BitmapDescriptor.defaultMarker;

  Set<Marker> markers = {};
  bool isInsideLocation = false;
  double radius = 0;

  List<LatLng> listPolygons = const [
    LatLng(10.73343784161409, 106.69639213882168),
    LatLng(10.733140054627112, 106.69978513319467),
    LatLng(10.730731395097495, 106.70003189642024),
    LatLng(10.73030974595168, 106.69736578067798)
  ];

  void addCustomIcon() async {
    var value = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(1, 1), devicePixelRatio: 1),
        'assets/images/marker_icon.png');
    setState(() {
      iconBitMap = value;
    });
  }

  bool isLocationInsideTDTU(LatLng location) {
    List<map_tool.LatLng> convertPolygonsPoints = listPolygons
        .map((e) => map_tool.LatLng(e.latitude, e.longitude))
        .toList();
    isInsideLocation = map_tool.PolygonUtil.containsLocation(
        map_tool.LatLng(location.latitude, location.longitude),
        convertPolygonsPoints,
        false);
    if (isInsideLocation) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
        backgroundColor: AppColors.primaryButton,
        centerTitle: true,
        title: const Text(
          'My Location',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                googleMapController = controller;
              },
              // polygons: {
              //   Polygon(
              //     polygonId: const PolygonId('Ton Duc Thang Location'),
              //     points: listPolygons,
              //     fillColor: Colors.blue.withOpacity(0.1),
              //     strokeColor: Colors.blue,
              //     strokeWidth: 2,
              //   )
              // },
              circles: {
                Circle(
                    circleId: const CircleId('ID1'),
                    radius: radius,
                    fillColor: AppColors.primaryButton.withOpacity(0.2),
                    strokeColor: AppColors.primaryButton.withOpacity(0.1),
                    strokeWidth: 5,
                    center: const LatLng(10.7326688766, 106.699768066))
              },
            ),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CustomText(
                          message: 'Distance',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                          message: '${radius.ceil()}m',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppColors.primaryText)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Slider(
                      label: 'Distance',
                      value: radius,
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          radius = value;
                        });
                      }),
                ],
              ),
            ),
          )
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     Position position = await GetLocation().determinePosition();
      //     var address = await GetLocation().getAddressFromLatLong(position);
      //     googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      //         CameraPosition(
      //             target: LatLng(position.latitude, position.longitude),
      //             zoom: 16)));

      //     // markers.clear();
      //     markers.add(Marker(
      //         icon: iconBitMap,
      //         infoWindow: const InfoWindow(title: 'Current Location'),
      //         markerId: const MarkerId('CurrentLocation'),
      //         draggable: true,
      //         position: LatLng(position.latitude, position.longitude)));
      //     bool check = isLocationInsideTDTU(
      //         LatLng(position.latitude, position.longitude));
      //     if (check) {
      //       print('INSIDE-----------------------');
      //     } else {
      //       print('OUTSIDE-------------------------');
      //     }
      //   },
      //   label: const Text(
      //     'Current Location',
      //     style: TextStyle(color: Colors.white, fontSize: 15),
      //   ),
      //   backgroundColor: AppColors.primaryButton,
      //   foregroundColor: Colors.white,
      //   icon: const Icon(Icons.location_history),
      // ),
    );
  }
}
