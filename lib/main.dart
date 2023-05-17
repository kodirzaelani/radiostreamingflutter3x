import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Radio Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: 'Radio Player',
      url: 'https://audiostreamserver.indonesiastreaming.com/islamic_center',
      imagePath: 'assets/images/cover.png',
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _radioPlayer.getArtworkImage(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Image artwork;
                if (snapshot.hasData) {
                  artwork = snapshot.data;
                } else {
                  artwork = Image.asset(
                    'assets/images/cover.png',
                    fit: BoxFit.cover,
                  );
                }
                return SizedBox(
                  height: 180,
                  width: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: artwork,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              metadata?[0] ?? 'Radio Islamic Center Kaltim',
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              metadata?[1] ?? '',
              softWrap: false,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
        },
        tooltip: 'Control button',
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
      ),
    );
  }
}
