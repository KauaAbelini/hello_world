import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Mapa',
      home: const MapaPage(),
    );
  }
}

// Página do mapa
class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Position? posicao;

  final MapController mapaController = MapController();

  Future<void> buscarLocalizacao() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return;
    }

    Position novaPosicao = await Geolocator.getCurrentPosition();

    setState(() {
      posicao = novaPosicao;
    });


      mapaController.move(
        LatLng(novaPosicao.latitude, novaPosicao.longitude),
        16,
      );
  }

  @override
  void initState() {
    super.initState();
    buscarLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Mapa')),

      body: FlutterMap(
        mapController: mapaController,
        
        options: const MapOptions(
          initialCenter: LatLng(
            -21.458734302408228,
            -46.99401638348058,
          ),
          initialZoom: 13,
        ),

        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.mapa_flutter',
          ),

          if (posicao != null)
          MarkerLayer(
            markers:[
              Marker(
                point: LatLng(posicao!.latitude, posicao!.longitude),
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 50,
                ),
              )
            ]
          )
        ]
      )
    );
  }
}