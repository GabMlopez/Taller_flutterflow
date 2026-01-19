import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controladores/mongo_connection.dart';
import '../functions/samples/toggle_sample.dart'; // o toggleFavorite si cambió el nombre
import '../functions/samples/upload_sample.dart';
import '../pages/provider/globar_player.dart';
import 'package:just_audio/just_audio.dart';
import '../functions/samples/get_audio.dart';
import '../functions/samples/play_sample.dart';

class SamplesPageWidget extends StatefulWidget {
  const SamplesPageWidget({super.key});

  @override
  State<SamplesPageWidget> createState() => _SamplesPageWidgetState();
}

class _SamplesPageWidgetState extends State<SamplesPageWidget> {
  late Future<List<Map<String, dynamic>>> _samplesFuture;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _samplesFuture = getSamples(context);
  }

  @override
  void dispose() {
    // NO dispose globalPlayer aquí para que siga sonando al cambiar de pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: const Color(0xFF0EB0BE),
              automaticallyImplyLeading: false,
              title: const Align(
                alignment: AlignmentDirectional(0, 0),
                child: Text('Samples'),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Controles globales de reproducción (solo visibles si algo reproduce)
                          StreamBuilder<PlayerState>(
                            stream: globalPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final playing = playerState?.playing ?? false;

                              if (!playing) return const SizedBox.shrink();

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      iconSize: 40,
                                      icon: Icon(
                                        playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                      ),
                                      onPressed: () async {
                                        if (playing) {
                                          await globalPlayer.pause();
                                        } else {
                                          await globalPlayer.play();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      iconSize: 40,
                                      icon: const Icon(Icons.stop_circle),
                                      onPressed: () => globalPlayer.stop(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          Expanded(
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: _samplesFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                }

                                final samples = snapshot.data ?? [];

                                if (samples.isEmpty) {
                                  return const Center(child: Text('No hay samples todavía'));
                                }

                                return RefreshIndicator(
                                  onRefresh: () async {
                                    setState(() {
                                      _samplesFuture = getSamples(context);
                                    });
                                  },
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: samples.length,
                                    itemBuilder: (context, index) {
                                      final sample = samples[index];
                                      final isFavorite = sample['favorito'] as bool? ?? false;
                                      final nombre = sample['nombre'] as String? ?? 'Sin nombre';

                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        child: ListTile(
                                          leading: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: isFavorite ? Colors.red : null,
                                            size: 32,
                                          ),
                                          title: Text(
                                            nombre,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text('ID: ${sample['id']}'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.play_arrow, size: 32),
                                                onPressed: () async {
                                                  final sampleId = sample['id'];
                                                  if (sampleId == null) {
                                                    print('ID del sample es null');
                                                    return;
                                                  }

                                                  final dbService = context.read<DatabaseService>();
                                                  await playSample(dbService, sampleId);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                                  color: isFavorite ? Colors.red : null,
                                                ),
                                                onPressed: () async {
                                                  await toggleFavorite(context, sample);
                                                  setState(() {
                                                    _samplesFuture = getSamples(context);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // ¡Aquí está el FAB que faltaba!
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await uploadSample(context);

            setState(() {
              _samplesFuture = getSamples(context);
            });
          },
          child: Icon(Icons.upload_sharp),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // posición por defecto
      ),
    );
  }
}