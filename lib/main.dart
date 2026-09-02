import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Distância',
      home: DistanciaPage(),
    );
  }
}

class DistanciaPage extends StatefulWidget {
  const DistanciaPage({super.key});

  @override
  State<DistanciaPage> createState() => _DistanciaPageState();
}

class _DistanciaPageState extends State<DistanciaPage> {
  double latCasa = -21.44992144952187;
  double longCasa = -46.99558718046699;
  String textoExibicao = 'Clique no botão para calcular a distância.';

  Future<void> calcularDistancia() async {
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

    Position posicao = await Geolocator.getCurrentPosition();

    double distanciaMetros = Geolocator.distanceBetween(
      posicao.latitude,
      posicao.longitude,
      latCasa,
      longCasa,
    );

    setState(() {
      double distanciaKm = distanciaMetros / 1000;
      textoExibicao = 'A distância é de ${distanciaKm.toStringAsFixed(2)} km';
    });

    print('Distância calculada: $distanciaMetros metros');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.home,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Distância entre a escola e minha casa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                textoExibicao,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: calcularDistancia,
                child: const Text('Calcular distância'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
