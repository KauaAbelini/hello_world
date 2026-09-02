
import 'package:flutter/material.dart';
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
      title: 'Minha Localização',
      home: const LocalizacaoPage(),
    );
  }
}

class LocalizacaoPage extends StatefulWidget {
  const LocalizacaoPage({super.key});

  @override
  State<LocalizacaoPage> createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> {

  // ==========================================
  // COORDENADAS DA SUA CASA
  // ==========================================

  final double latitudeCasa = -21.44992144952187;
  final double longitudeCasa = -46.99558718046699;

  // ==========================================
  // LOCALIZAÇÃO ATUAL
  // ==========================================

  double latitude = 0;
  double longitude = 0;

  // Distância até a casa
  double distancia = 0;

  // ==========================================
  // BUSCAR LOCALIZAÇÃO
  // ==========================================

  Future<void> buscarLocalizacao() async {

    bool servicoAtivo =
        await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao =
        await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return;
    }

    // Pega a localização atual
    Position posicao =
        await Geolocator.getCurrentPosition();

    // ==========================================
    // CALCULA A DISTÂNCIA
    // ==========================================

    double distanciaCalculada =
        Geolocator.distanceBetween(
      posicao.latitude,
      posicao.longitude,
      latitudeCasa,
      longitudeCasa,
    );

    // ==========================================
    // ATUALIZA OS VALORES NA TELA
    // ==========================================

    setState(() {
      latitude = posicao.latitude;
      longitude = posicao.longitude;
      distancia = distanciaCalculada;
    });

    print('Latitude atual: $latitude');
    print('Longitude atual: $longitude');
    print('Distância até casa: $distancia metros');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Minha Localização'),
      ),

      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [

              const Icon(
                Icons.location_on,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              const Text(
                'Localização Atual',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // ==================================
              // LOCALIZAÇÃO ATUAL
              // ==================================

              Text(
                'Latitude: $latitude',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Longitude: $longitude',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              // ==================================
              // COORDENADAS DA CASA
              // ==================================

              const Text(
                'Minha Casa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Latitude: $latitudeCasa',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Longitude: $longitudeCasa',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // ==================================
              // DISTÂNCIA
              // ==================================

              const Text(
                'Distância até minha casa:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '${distancia.toStringAsFixed(2)} metros',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 30),

              // ==================================
              // BOTÃO
              // ==================================

              ElevatedButton(
                onPressed: buscarLocalizacao,
                child: const Text(
                  'Atualizar Localização',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

