# Investigación y selección de assets CC0 para Farol de Ceniza

Fecha de comprobación: 2026-10-20. Descargas inspeccionadas desde las páginas oficiales de Kenney; los archivos instalados en `assets/third_party/kenney/` son versiones de esos ZIP, no assets recreados.

## Fuentes comprobadas

- **Kenney Toon Characters** — 270+ archivos según ficha; sprites de alta resolución con 45 poses por personaje. Previsualización inspeccionada: personajes de cartoon amigables; incluye Female Adventurer, Male Adventurer, Zombie y varios personajes (el robot también aparece en la hoja general). Las poses `idle`, `attack0/1/2`, `hit`, `hurt`, `down` existen como PNG independientes. Licencia confirmada en `License.txt` del ZIP: CC0, uso personal/educativo/comercial.
- **Kenney Roguelike Characters** — la ficha indica 450+ archivos CC0; la descarga real contiene un PNG spritesheet transparente de 918×203, celdas de 16×16 con margen de 1 px, un PNG sobre fondo magenta y archivos de muestra. Alternativa distinta de pixel art.

- **Kenney Fantasy UI Borders** — 140+ piezas y vistas `Default`, `Double`, `Transparent` en PNG. Licencia del ZIP: CC0. Sirve para paneles y marcos de menú, no para copiar literalmente su sample de UI.
- **Kenney RPG Base** — más de 230 piezas 2D con licencia CC0; tiles, objetos y recursos de entorno. No se adopta todo el paquete: tomar solo elementos compatibles con la arena horizontal.
- **Kenney RPG Audio** — la ficha indica 50+ archivos de efectos/foley con licencia CC0; audio sigue pendiente de integración.

Página de Kenney indica CC0 en las fichas; cada ZIP contiene `License.txt` que acompaña al contenido. Atribución no es obligatoria bajo CC0; conservar procedencia/aviso en el proyecto para trazabilidad. Los PNG de personajes se deben usar respetando pixel ratio/original pixels, no estirarlos.

## Encaje con la dirección del juego

La previsualización Toon es claramente cartoon y más legible/alegre que las ilustraciones vectoriales con gradiente actuales. Las pose son mayormente frontal/3-4, no estrictamente lateral. Puede funcionar si se elige deliberadamente una identidad chibi/arcade para todo el elenco; mezclar algunos sprites con los vectores actuales produciría colisión de estilo. El zombie verde humanoide tampoco equivale a la mota, el acorazado, el acechador o el guardián del Umbral. No renombrar el zombie como enemigo del lore.

Fantasy UI Borders es un recurso que sí se puede integrar con bajo riesgo como marco de paneles/cards y retratos; evitar repetir bordes decorativos en cada pieza. Los audio RPG pueden sustituir/probar los tonos sintetizados. El conjunto RPG Base se reserva para assets del escenario donde coincida la perspectiva y escala.

## Integración local verificada

- `kenney_toon-characters.zip`: archivado bajo `assets/third_party/kenney/`; sprites recortados de Female Adventurer, Male Adventurer y Zombie en poses idle/ataque/daño/caída como kit piloto. No son assets ya asociados en runtime a los héroes o enemigos canónicos; conservar los vectores originales hasta validación del dueño.
- `kenney_fantasy-ui-borders.zip`: contiene dos tipos de imagen incompatibles que no se deben superponer tal cual: `PNG/Double/Panel/panel-015.png` es un marco blanco opaco con hueco central transparente, mientras `PNG/Double/Border/panel-border-015.png` tiene un centro transparente y contorno cuadrado simple. Son útiles en estilos claros/blancos, pero no dan el panel de piedra oscuro requerido por la paleta actual; quedan descargados como kit, sin integrarse visualmente.
- `kenney_rpg-audio.zip`: audioclips/ficheros CC0 archivados; aún no se conectan al sistema de sonido.
- `kenney_rpg-base.zip`: tiles/objetos archivados; uso selectivo pendiente.
- `kenney_roguelike-characters.zip`: sprite sheet CC0 archivado; requiere atlas de regiones/escala y una dirección pixel-art explícita antes de aparecer en pantallas normales.

No borrar archivos vectoriales ni reemplazar el formato de todas las escenas por sprites hasta inspeccionar escala, alpha, transparencia, atlas y composición en pantalla. Los ZIP originales y `License.txt` quedan bajo `assets/third_party/kenney/` para trazabilidad/licencia. Estos assets son un kit descargado de referencia, no se han registrado en `pubspec.yaml` ni empacado por Flutter: no forman parte aún del runtime o build. Los PNG filtrados son una shortlist, no sprites ya conectados a los héroes/enemigos del lore.

## Descargas

- https://kenney.nl/assets/toon-characters
- https://kenney.nl/assets/fantasy-ui-borders
- https://kenney.nl/assets/rpg-base
- https://kenney.nl/assets/rpg-audio
- https://kenney.nl/assets/roguelike-characters
- https://creativecommons.org/publicdomain/zero/1.0/

## Sources

[1] Kenney Toon Characters — ficha oficial: 270+ archivos, CC0.
[2] Kenney Fantasy UI Borders — ficha oficial: 140+ archivos, CC0.
[3] Kenney RPG Base — ficha oficial: 230+ archivos, CC0.
[4] Kenney RPG Audio — ficha oficial: 50+ archivos, CC0.
[5] Creative Commons CC0 1.0 — declara permiso para copiar, modificar y distribuir, incluso con fines comerciales, sin pedir permiso; su deed advierte que no verifica el estado de copyright de cada obra.
[6] Kenney Roguelike Characters — ficha oficial: 450+ archivos, CC0.

Extractos verificables, capturados de las fichas al investigar:

- [1] “270× License Creative Commons CC0”
- [2] “Files 140× License Creative Commons CC0”
- [3] “Files 230× License Creative Commons CC0”
- [4] “Files 50× License Creative Commons CC0”
- [5] “You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission”
- [6] “Files 450× License Creative Commons CC0”
