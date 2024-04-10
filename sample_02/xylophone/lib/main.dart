import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const XylophoneApp(),
    );
  }
}

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({super.key});

  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  Soundpool soundPool = Soundpool.fromOptions(
    options: SoundpoolOptions.kDefault,
  );
  final List<int> _soundIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initSoundPool();
  }

  Future<void> initSoundPool() async {
    int soundId = await rootBundle
        .load('assets/sounds/do1.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    soundId = await rootBundle
        .load('assets/sounds/re.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    soundId = await rootBundle
        .load('assets/sounds/mi.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    soundId = await rootBundle
        .load('assets/sounds/fa.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    soundId = await rootBundle
        .load('assets/sounds/sol.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    soundId = await rootBundle
        .load('assets/sounds/la.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    soundId = await rootBundle
        .load('assets/sounds/si.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    soundId = await rootBundle
        .load('assets/sounds/do2.wav')
        .then((sound) => soundPool.load(sound));
    _soundIds.add(soundId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Xylophone',
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: keyboard(
                    color: Colors.red,
                    soundId : _soundIds[0],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: keyboard(
                    color: Colors.orange,
                    soundId : _soundIds[1],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: keyboard(
                    color: Colors.yellow,
                    soundId : _soundIds[2],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: keyboard(
                    color: Colors.green,
                    soundId : _soundIds[3],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48.0),
                  child: keyboard(
                    color: Colors.blue,
                    soundId : _soundIds[4],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 56.0),
                  child: keyboard(
                    color: Colors.indigo,
                    soundId : _soundIds[5],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64.0),
                  child: keyboard(
                    color: Colors.purple,
                    soundId : _soundIds[6],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 72.0),
                  child: keyboard(
                    color: Colors.redAccent,
                    soundId : _soundIds[7],
                  ),
                ),
              ],
            ),
    );
  }

  Widget keyboard({
    required Color color,
    required int soundId,
  }) {
    return GestureDetector(
      onTap: () {
        soundPool.play(soundId);
      },
      child: Container(
        width: 50,
        height: double.infinity,
        color: color,
      ),
    );
  }
}
