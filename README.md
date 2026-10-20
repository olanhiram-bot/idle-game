# Idle Game (nombre provisional)

Prototipo móvil local con Flutter, Flame y Dart. Nombre comercial provisional.

Concepto: [Farol de Ceniza](docs/GAME_CONCEPT.md). Su actualización interactiva prevalece sobre el diseño automático inicial.

Plan de trabajo: [TODO completo](TODO.md) · [Investigación y alcance](docs/GAME_ROADMAP.md) · [Estado real y límites](docs/IMPLEMENTATION_STATUS.md).

## Estado actual

- Proyecto generado para Android, iOS y web.
- Combate manual por botón o toque en la escena; automático solo si se activa.
- Academia en Mecha: comprar/mejorar Golpe poderoso, Curación y Sello de hielo con oro; maná y recuperación en pelea. Ruta selecciona rivales desbloqueados; cada victoria aumenta la siguiente dificultad hasta el límite documentado.
- Tres héroes seleccionables en Mecha: Luz, Bastión y Ascua, con vida/daño y arte propios. Ataques con desplazamiento, efectos, números de daño y reacción enemiga. [Reglas y guardado compatible](docs/RPG_COMBAT.md).
- Cuatro ataques manuales cargan una llamarada de triple daño, que el jugador decide cuándo usar.
- Guardafaroles y criatura ilustrados con vectores originales, sin assets externos.
- Rediseño visual: portada ilustrada, mundo nocturno por capas, paneles petróleo/ámbar, taller con módulos y ruta con progreso. [Contrato visual](docs/VISUAL_DESIGN.md).
- Oro, mejora de mecha, tres sectores y jefe final, vida real, protección, derrota y reintento.
- XP/nivel, dos módulos equipables, encargos finitos y selección de encuentros.
- Menú inicial, final, ayuda omitible, ajustes persistentes y audio original opcional.
- Escena a todo el viewport, HUD contextual sobre personajes y tabs inferiores Combate, Mecha y Ruta. [Criterios y fuentes de distribución móvil](docs/MOBILE_RPG_LAYOUT.md).
- Pruebas deterministas de combate, compra, progresión, ciclo de vida e interfaz estrecha con texto ampliado.
- Guardado local validado, respaldo y recuperación; exportación/importación. No genera progreso offline. El navegador puede borrar almacenamiento: exportar sigue siendo recomendable.
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

Campaña y persistencia implementadas; pruebas físicas, playtest humano y parte de la calificación exhaustiva siguen pendientes. La lógica Dart vive en `lib/domain/`, persistencia en `lib/data/` y renderizado en `lib/presentation/`.

No se incluyen assets externos. Flutter usa licencia BSD-3-Clause y Flame MIT; conservar avisos de dependencias. El identificador `com.example.idle_game` generado es provisional, no una identidad de publicación.
