import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String movimento = 'Dispositivo parado';

  double x = 0;
  double y = 0;
  double z = 0;

  StreamSubscription<AccelerometerEvent>? acelerometro;

  @override
  void initState() {
    super.initState();

    acelerometro = accelerometerEventStream().listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        double movimentoTotal = x.abs() + y.abs() + z.abs();

        if (movimentoTotal > 12) {
          movimento = 'Dispositivo em movimento';
        } else {
          movimento = 'Dispositivo parado';
        }
      });
    });
  }

  @override
  void dispose() {
    acelerometro?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool estaMovendo = movimento == 'Dispositivo em movimento';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acelerômetro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              estaMovendo
                  ? Icons.directions_run
                  : Icons.phone_android,
              size: 60,
              color: estaMovendo ? Colors.orange : Colors.green,
            ),

            const SizedBox(height: 15),

            Text(
              movimento,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: estaMovendo ? Colors.orange : Colors.green,
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'X: ${x.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 10),

            Text(
              'Y: ${y.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 10),

            Text(
              'Z: ${z.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}