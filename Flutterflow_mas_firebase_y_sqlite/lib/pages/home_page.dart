import 'package:flutter/material.dart';
import '../styles/color_templates.dart';
import '../functions/samples/play_sample.dart';
import '../functions/samples/toggle_sample.dart';
import 'provider/globar_player.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});
  static String routeName = 'home_page';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late final templateColors colors;

  @override
  void initState() {
    super.initState();
    // Si necesitas inicializar colors aquí (ej: Provider)
    // colors = Provider.of<templateColors>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSpeedControl() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Velocidad de reproducción',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            value: playbackSpeed,
            min: 0.5,
            max: 1.5,
            divisions: 4,
            label: '${playbackSpeed.toStringAsFixed(1)}x',
            onChanged: (value) {
              setState(() {
                playbackSpeed = value;
              });

              updatePlaybackSpeed(value);
              setPlaybackSpeed(value);
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Eco',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: echoEnabled,
                onChanged: (value) async {
                  setState(() {
                    toggleEcho();
                  });

                  if (echoEnabled) {
                    await enableEcho();
                  } else {
                    await disableEcho();
                  }
                },
              ),
            ],
          ),
          /*Text(
            currentSampleName ?? 'Ninguna pista reproduciéndose',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: currentSampleName == null ? Colors.grey : Colors.black,
            ),
          ),*/
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: NestedScrollView(  // ← Aquí va el contenido directamente (sin Scaffold)
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: false,
            backgroundColor: const Color(0xFF0EB0BE),
            automaticallyImplyLeading: false,
            title: const Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text(
                'Mezclador',
                style: TextStyle(color: Colors.white), // opcional: para que el título se vea bien
              ),
            ),
            centerTitle: false,
            elevation: 3,
          ),
        ],
        body: Builder(
          builder: (context) {
            return SafeArea(
              top: false,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _buildSpeedControl(),
                        ], // Aquí van tus widgets de home (ej: cards, sliders, etc.)
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}