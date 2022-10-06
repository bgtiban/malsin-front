import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


void main() async {
  Configuration conf = const Configuration();
  await conf.configureFlutterConfig();

  runApp(const HomeWidget());
}

class Configuration {
  const Configuration();

  configureFlutterConfig() async{
    WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
    await FlutterConfig.loadEnvVariables();
  }

}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  // State<HomeWidget> createState() => _MyAppState(); // lambda style
  State<StatefulWidget> createState() {
    return HomeWidgetState();
  }

}

class HomeWidgetState extends State<HomeWidget> {
  late GoogleMapController mapController;
  final LatLng initialCamPosition = const LatLng(40.417015, -3.703205);
  Location location = Location();

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude! , l.longitude!), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const IconButton(onPressed: null, icon: Icon(Icons.menu_rounded)),
          title: Text(FlutterConfig.get('API_GOOGLE_MAPS_KEY') ?? 'API_GOOGLE_MAPS_KEY not found'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(target: initialCamPosition),
          mapType: MapType.normal,
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
        )
      ),
    );
  }
}


