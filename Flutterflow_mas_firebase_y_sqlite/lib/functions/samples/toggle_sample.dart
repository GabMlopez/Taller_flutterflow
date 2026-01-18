import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';

import '../../controladores/mongo_connection.dart';
double playbackSpeed = 1.0;
String? currentSampleName;
bool echoEnabled = false;

Future<void> toggleFavorite(BuildContext context, Map<String, dynamic> sample) async {
  final dbService = context.read<DatabaseService>();
  final collection = await dbService.collection('samples');

  final newFavorite = !(sample['favorito'] as bool);

  await collection.update(
    where.eq('_id', sample['_id']),
    modify.set('favorito', newFavorite),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(newFavorite ? 'Agregado a favoritos' : 'Quitado de favoritos'),
    ),
  );
}

void updatePlaybackSpeed(double value) {
  playbackSpeed = value;
}

void setCurrentSampleName(String name) {
  currentSampleName = name;
}

void toggleEcho() {
  echoEnabled = !echoEnabled;
}