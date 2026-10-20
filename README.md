# Idle Game (nombre provisional)

Prototipo móvil local con Flutter, Flame y Dart. Nombre comercial provisional.

Concepto: [Farol de Ceniza](docs/GAME_CONCEPT.md). Su actualización interactiva prevalece sobre el diseño automático inicial.

Plan de trabajo: [TODO completo](TODO.md) · [Investigación, sistemas propuestos y criterios de terminado](docs/GAME_ROADMAP.md). Las ampliaciones están propuestas, no implementadas ni activadas automáticamente.

## Estado actual

- Proyecto generado para Android, iOS y web.
- Combate manual por botón o toque en la escena; automático solo si se activa.
- Cuatro ataques manuales cargan una llamarada de triple daño, que el jugador decide cuándo usar.
- Guardafaroles y criatura ilustrados con vectores originales, sin assets externos.
- Oro, mejora de mecha, tres tramos restaurables y pausa.
- Escena a todo el viewport, HUD contextual sobre personajes y tabs inferiores Combate, Mecha y Ruta. [Criterios y fuentes de distribución móvil](docs/MOBILE_RPG_LAYOUT.md).
- Pruebas deterministas de combate, compra, progresión, ciclo de vida e interfaz estrecha con texto ampliado.
- Sin guardado ni progreso offline: recargar reinicia la partida.
- Sin backend, cuentas, anuncios, compras ni servicios externos.

## Desarrollo

Requiere Flutter compatible con el SDK Dart declarado en `pubspec.yaml`.

```sh
flutter pub get
flutter run
```

`flutter run` requiere un dispositivo o emulador compatible. Para Android:

```sh
flutter build apk --debug
```

Salida: `build/app/outputs/flutter-apk/app-debug.apk`.

## Verificación

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

La compilación iOS requiere macOS y Xcode. Compilar Android no sustituye probar en un dispositivo físico.

## Alcance propuesto para el primer prototipo

Combate, oro, mejora y ruta implementados. Guardado local versionado y recuperación pendientes. La lógica Dart vive en `lib/domain/`, separada del renderizado en `lib/presentation/`.

No se incluyen assets externos. Flutter usa licencia BSD-3-Clause y Flame MIT; conservar avisos de dependencias. El identificador `com.example.idle_game` generado es provisional, no una identidad de publicación.
