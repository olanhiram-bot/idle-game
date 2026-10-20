# Assets y dependencias

## Arte y audio propios

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
