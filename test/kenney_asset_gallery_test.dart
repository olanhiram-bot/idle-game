import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/presentation/kenney_asset_gallery.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('loads bundled sprites without filesystem mocks', (tester) async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    expect(
      manifest.listAssets(),
      contains(
        'assets/third_party/kenney/toon-characters/selected/'
        'Female adventurer/PNG/Poses HD/character_femaleAdventurer_idle.png',
      ),
    );
    final gallery = KenneyAssetGallery();
    await tester.runAsync(
      () => gallery.onLoad().timeout(const Duration(seconds: 10)),
    );
    expect(gallery.imagesLoaded, 13);
    gallery.onRemove();
  });
}
