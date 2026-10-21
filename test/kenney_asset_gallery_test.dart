import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/presentation/kenney_asset_gallery.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('loads the selected Kenney preview sprites in the gallery', (
    tester,
  ) async {
    final binaryMessenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const assetChannel = MethodChannel('flutter/assets');
    binaryMessenger.setMockMessageHandler(assetChannel.name, (message) async {
      final name = utf8.decode(message!.buffer.asUint8List());
      if (name == 'AssetManifest.bin') {
        return const StandardMethodCodec().encodeSuccessEnvelope(
          Uint8List.fromList(<int>[]),
        );
      }
      final data = await File(name).readAsBytes();
      return ByteData.sublistView(data);
    });
    final gallery = KenneyAssetGallery();
    await tester.pumpWidget(MaterialApp(home: GameWidget(game: gallery)));
    await tester.pumpAndSettle();

    expect(gallery.imagesLoaded, 8);
    await tester.pumpWidget(const SizedBox.shrink());
    binaryMessenger.setMockMessageHandler(assetChannel.name, null);
  });
}
