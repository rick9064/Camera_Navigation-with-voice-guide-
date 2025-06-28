import 'package:flutter/material.dart';
// import 'screens/navigation_screen.dart';
import 'screens/camera_live_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blind Assistance App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        // '/navigation': (context) => NavigationScreen(),
        '/cameraLive': (context) => CameraLiveScreen(), // ✅ removed const
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Navigation Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () => Navigator.pushNamed(context, '/navigation'),
            //   child: const Text('MLKit (Offline) Navigation'),
            // ),
            // const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/cameraLive'),
              child: const Text('Live API (Online) Navigation'),
            ),
          ],
        ),
      ),
    );
  }
}
