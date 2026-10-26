# Assets y dependencias

## Arte y audio propios

## Elenco Toon integrado

El elenco visible usa los seis personajes de **Kenney Toon Characters**, CC0:
Luz = Female adventurer; Bastión = Male adventurer; Ascua = Female person;
Vigía = Male person; enemigos = Zombie y Robot. Los dos enemigos tienen variantes
de encuentros que conservan las estadísticas y reglas de la campaña anterior.
Los IDs guardados `farol`, `bastion`, `ascua` y los índices de encuentros se conservan;
`vigia` es una elección nueva. No se mezclan personajes Roguelike.

`assets/toon/` contiene 36 PNG originales del ZIP (seis poses por personaje),
`License.txt` y `manifest.json` con ruta interna y SHA-256. Fuente:
https://kenney.nl/assets/toon-characters . Escalado uniforme y apoyo inferior;
reposo, ataque en dos poses, daño, derrota y protección. La caché compartida está
acotada al elenco y no se destruye al cerrar selector/galería.
Los vectores anteriores permanecen como respaldo técnico, no como elenco principal.
RPG Base aporta el suelo; audio sigue siendo original.

### Estado previo al reemplazo del elenco

`lib/presentation/characters.dart`, `world_art.dart`, `title_screen.dart` y `lantern_scene.dart`: ilustración vectorial original del proyecto, sin assets de terceros. Las imágenes compartidas por el usuario se usan como referencia de jerarquía y acabado, no como archivos redistribuidos. No se descargaron imágenes, fuentes ni paquetes nuevos para el rediseño. `assets/audio/*.wav`: tonos sintetizados localmente con seno y envolvente decreciente, PCM mono a 22050 Hz; sin muestras externas ni servicio pagado. No se afirma registro de marca.

## Licencias revisadas en paquetes instalados

- `audioplayers`: LICENSE inspeccionado; encabezado «MIT License  Copyright (c) 2017 Blue Fire  Permission is hereby granted, free of charge, t».
- `file_selector`: LICENSE inspeccionado; encabezado «Copyright 2013 The Flutter Authors  Redistribution and use in source and binary forms, wit».
- `flame_audio`: LICENSE inspeccionado; encabezado «MIT License  Copyright (c) 2021 Blue Fire  Permission is hereby granted, free of charge, t».
- `path_provider`: LICENSE inspeccionado; encabezado «Copyright 2013 The Flutter Authors  Redistribution and use in source and binary forms, wit».
- `sembast`: LICENSE inspeccionado; encabezado «Copyright (c) 2020, Alexandre Roux Tekartik All rights reserved.  Redistribution and use i».
- `sembast_web`: LICENSE inspeccionado; encabezado «Copyright (c) 2020, Alexandre Roux Tekartik All rights reserved.  Redistribution and use i».
- `web`: LICENSE inspeccionado; encabezado «Copyright 2023, the Dart project authors.  Redistribution and use in source and binary for».

Conservar los avisos completos de las dependencias en la distribución. La licencia del código no concede derechos de marcas o arte ajeno. Revisar también licencias transitivas al preparar release.
