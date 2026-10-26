# Investigación de diseño — Farol de Ceniza

Fecha: 2026-10-26. Estado: investigación y propuesta, **no rediseño implementado**.

## 1. Resumen ejecutivo

**Recomendación del investigador:** conservar los seis personajes Toon aprobados y construir una dirección «aventura nocturna cartoon» alrededor de ellos. Priorizar composición, jerarquía y consistencia antes de descargar más packs. Profesional no significa más decoración: significa que el jugador distingue personaje, amenaza, acción y recompensa sin descifrar una pantalla.

El problema principal observado no es falta de contenido: es competencia entre paneles, texto y escena. El taller conserva barras de combate y arena mientras comprime las compras; el selector dedica mucho espacio al retrato y obliga a desplazarse para llegar al cuarto héroe y a confirmar. La estética del elenco es consistente entre sus seis integrantes, pero necesita una puesta en escena y una familia de controles igual de deliberadas.

### Alcance y límites

- Petición del usuario: investigación exhaustiva para un juego profesional, limpio y llamativo.
- Decisiones ya aceptadas: Flutter + Flame; juego local; todos los personajes Toon como héroes/enemigos; vista propia de selección; escena inmersiva; navegación inferior; evitar apariencia de aplicación Material genérica.
- Esta investigación no cambia economía, combate, guardados, temática comercial definitiva ni código. No incorpora anuncios, compras, gacha, cuentas ni servicios.
- Las medidas y direcciones nuevas de este informe son propuestas del investigador, no decisiones ya aprobadas.
- No se mide retención ni diversión humana. No se afirma que un cambio visual aumentará ingresos o conversión.

## 2. Método y evidencia

Se inspeccionaron `game_theme.dart`, `game_controls.dart`, `rpg_view.dart`, `campaign_menu.dart`, `character_view.dart`, `settings.dart`, renderer y documentación visual. Se recorrió la versión web local de producción, en 390×844 y 1280×800 píxeles CSS. Se guardaron ocho capturas originales en `docs/design-evidence/`:

| Archivo | Estado inspeccionado |
|---|---|
| mobile-start.png | Portada |
| mobile-combat.png | Preparación, ayuda abierta |
| mobile-active.png | Combate activo, antes del primer golpe |
| mobile-upgrades.png | Taller, inicio del scroll |
| mobile-heroes.png | Selector, primera posición |
| mobile-route.png | Ruta, posición observada |
| mobile-settings.png | Ajustes, inicio de la hoja |
| desktop-combat.png | Preparación en escritorio |

Las observaciones se contrastaron con DOM y código. La lectura visual automática confundió nombre del juego con nombre del héroe y describió combate por turnos: **se descartan esas inferencias**. El juego es combate en tiempo real; PM es maná. También confundió selección provisional con confirmación: el check del retrato no sustituye el botón «Jugar con…», que está más abajo.

Cobertura externa: documentación de plataforma, accesibilidad específica de juegos, artículo de diseño de Unity, referencia visual oficial de Clash Royale y sample de Kenney UI. No se jugó a esos títulos ni se auditó su interfaz completa. No se presenta una imagen promocional como validación de UX. Fallaron extracciones iniciales por timeout; se recuperaron mediante HTTP directo. Game UI Database devolvió 403 y las rutas consultadas de AFK Arena/Archero en Interface In Game devolvieron 404; no se usan como evidencia. No es un censo de todos los juegos del mercado.

## 3. Qué aportan las fuentes

| Fuente | Evidencia consultada | Aplicación propuesta | Qué NO demuestra |
|---|---|---|---|
| Unity, UI e inmersión | La interfaz debe encajar con identidad, situación y contenido; reducir texto puede mejorar foco.[1] | Reducir instrucciones permanentes; UI propia sin ocultar estado táctico | No obliga a cambiar motor ni a hacer UI diegética |
| Game Accessibility Guidelines | Fondo sencillo, contraste, texto claro y controles separados.[2][3][9] | Superficies tranquilas detrás de cifras, lectura rápida, targets amplios | No prescribe nuestra paleta o estilo artístico |
| Android Developers | Targets de al menos 48×48 dp; contraste textual según tamaño/peso.[4] | Conservar targets aunque un botón parezca pequeño | No equivale a una certificación Android física |
| W3C | Contraste no textual 3:1 para información necesaria; reducción de animación no esencial.[10][11] | Foco/selección distinguibles, respeto a reducir movimiento | No todo borde decorativo necesita 3:1; AAA no es requisito ya contratado |
| Flutter | Coste de reconstrucciones, saveLayer y efectos que crean buffers intermedios.[5] | Evitar blur/glow masivo; medir antes de añadir efectos | No prueba que hoy exista jank |
| Kenney Toon | Ficha CC0 y pack aprobado.[6] | Elenco fijo como base de estilo | CC0 no crea identidad comercial exclusiva |
| Clash Royale | Página oficial e imagen de arena en teléfono inspeccionada.[7] | Siluetas claras, suelo más tranquilo, sombras de contacto, prioridades cromáticas | No copiar personajes, UI, monetización, marcas ni 3D |
| Kenney UI Pack | Ficha CC0 y sample de paneles, botones y recompensas.[8] | Familia consistente de formas/estados, no mezcla de controles | El sample claro no es nuestra pantalla nocturna ni UX validada |

**Conclusión comparativa:** tomar estructura y legibilidad, no imitar un skin. La referencia de Clash Royale muestra una arena compleja con masas legibles, pero nuestro 1 contra 1 necesita bastante menos información. El sample de Kenney aporta consistencia, no una razón para importar cada pieza.

## 4. Diagnóstico priorizado del proyecto

### P0 — Jerarquía del combate

`rpg_view.dart:53` limita el dock a `min(height × .48, 390)` en móvil normal. En 390×844 son 390 unidades: **46,21% de la altura total**, con tabs dentro de esa región. No es porcentaje medido por píxeles de personajes, sino cálculo de layout. Se dedica casi media pantalla a controles, ayuda y párrafos. La escena existe a todo viewport, pero su zona útil es menor.

En `campaign_menu.dart:579–590`, automático, PM, dificultad e intención aparecen juntos. Automático tiene tratamiento de botón grande; la intención se comunica en texto pequeño. **Propuesta:** priorizar amenaza + Atacar/Proteger/Llamarada; llevar automático a un control secundario compacto, mantener PM junto a habilidades y separar ayuda.

No eliminar cifras críticas bajo el pretexto de limpiar. Carga y vida deben tener representaciones distintas; la carga no es otra vida. La cuenta atrás debe seguir legible sin sonido ni color.

### P0 — Escala y composición

Los actores quedan pequeños frente al peso del dock y al cielo. No corregirlo escalando todo indiscriminadamente: eso desplaza barras y puede recortar poses. Usar `ArenaLayout` como geometría común y medir bounds de las seis siluetas y sus ataques. Conservar pies apoyados, sombras y espacio entre personajes.

### P1 — Taller y ruta no tienen su propia jerarquía

En las capturas del taller se siguen viendo vida/carga del combate. Mientras tanto, una sola tarjeta y el botón de personaje consumen la primera región útil; el resto necesita scroll. El scroll es válido, pero no debe deberse a conservar información irrelevante.

**Propuesta:** mantener mundo de fondo y tabs; al abrir taller/ruta ocultar las barras de pelea y reducir la escena a un encabezado contextual. Dividir taller en Héroe, Mejoras y Habilidades mediante secciones o subpestañas locales, sin añadir nuevas tabs globales.

### P1 — Selector largo

`character_view.dart:68` fija 280 unidades al retrato y usa Wrap para miniaturas. A 390×844 el cuarto héroe y confirmar no quedan completos en la primera vista. No es pérdida de contenido: hay scroll. Es fricción de selección.

**Propuesta:** retrato adaptativo, cuatro elecciones en cuadrícula 2×2, botón fijo al pie en SafeArea. Vista previa y confirmación siguen separadas; Atrás no muta el guardado. A texto 200%, permitir scroll con confirmación accesible, no comprimir letras.

### P1 — Todos los controles pesan demasiado

`game_controls.dart` convierte incluso TextButton en OutlinedButton. Por ello «Volver», ayudas, toggles y opciones secundarias heredan relieve y bordes fuertes. La apariencia ya no es un botón Material sin modificar; atribuir todo a «Flutter nativo» sería incorrecto.

**Propuesta:** tres niveles reales: primario con relleno cálido; secundario con superficie tranquila; terciario sin caja pesada pero con target/foco/semántica. No cambiar callbacks ni teclado.

### P1 — Identidad y microcopy

Título del juego dominante en HUD, nombre del héroe subordinado; «Mecha» contiene héroes, vida, academia y módulos; «Galería» se usa para mundo y revisión de assets. Propuesta: reservar el título grande a portada; héroe y nivel en HUD; evaluar «Taller» como etiqueta visible en lugar de «Mecha» sin cambiar IDs internos. La galería técnica debe pasar a créditos/diagnóstico, no activarse por pulsación larga oculta del retrato.

`settings.dart:231` afirma que todos los personajes son originales del proyecto; ya no corresponde al uso de Kenney. Corregir créditos en implementación, aun siendo CC0 sin atribución obligatoria: es exactitud de producto, no obligación inventada.

### P2 — Arte y acabado

Toon comparte proporciones y estilos, pero vestuario humano moderno, robot y zombis no comunican automáticamente fantasía medieval. Recomendación: aventura de exploración nocturna con ruinas y tecnología antigua; **propuesta de dirección**, no cambio de lore aprobado. No recolorear todos los personajes, ocultarlos ni sustituirlos por otro pack.

Zombi y robot se reutilizan en cuatro encuentros: mantenerlo explícito. Variar entorno, emblema, intención, armadura/energía y presentación del jefe, sin prometer cuatro modelos únicos.

## 5. Dirección recomendada y alternativas

| Dirección | Beneficio | Coste/riesgo | Decisión del investigador |
|---|---|---|---|
| Aventura nocturna Toon | Aprovecha elenco, colores y estructura; continuidad con avances | Requiere trabajar composición y cohesión del escenario | Recomendada |
| Fantasía medieval ilustrada | Identidad temática más rígida | Vestuario del pack no encaja; sustitución de arte contradice selección reciente | No recomendar ahora |
| Pixel RPG | Puede ser coherente si todo el arte cambia | Mezcla incompatible con Toon; nuevo pipeline | Descartada en este alcance |
| Interfaz mínima tipo app | Reduce ruido rápido | Pierde personalidad de juego que el usuario pidió | Solo tomar disciplina de jerarquía, no skin |

Personalidad propuesta: amable, aventurera, luminosa sobre un mundo nocturno. Tres conceptos: **luz, exploración, acción**. Evitar gótico ornamental, neón futurista en todos los controles y mezcla de piedras realistas con sprites planos.

## 6. Sistema visual propuesto

Todos los valores siguientes son objetivos de diseño a validar, no mediciones de calidad actuales.

### Color

Conservar base tinta `#091B28`, panel azul `#252F50`, oro `#FFBE62`, turquesa `#88E6E1`, texto `#F0F4F0` y secundario `#B2C8D2`. Oro: acción principal/recompensa. Turquesa: foco/protección. Coral: peligro; siempre con icono/texto. Usar una superficie sólida para leer cifras; transparencias sobre mundo necesitan medición con fondo real.[2][4]

Cálculo sRGB sobre pares opacos actuales, no auditoría de toda pantalla:

| Par | Ratio calculado |
|---|---:|
| Secundario `#B2C8D2` / panel `#252F50` | 7,55:1 |
| Texto `#F0F4F0` / panel | 11,81:1 |
| Oro / tinta | 10,67:1 |
| Borde `#56678D` / panel | 2,32:1 |
| Blanco / azul `#365674` | 7,66:1 |

Esto **no demuestra falta general de contraste textual**. El borde de 2,32:1 necesita atención solo donde sea la única señal necesaria de foco/estado, no en toda decoración.[11] Prioridad real: tamaño, saturación y distribución de peso.

### Tipografía

Una familia sans legible; candidato Nunito Sans, con licencia OFL comprobada, a incorporar localmente con aviso si se adopta.[12] No se ha instalado ni validado su rasterización. Cuerpo 14–16 unidades lógicas; microtexto 12 solo para información secundaria; acción 15–16 semibold; encabezados 20–24; portada 32–40. Evitar convertir todo a peso 900 y mayúsculas. La fuente decorativa, si existe, solo para marca/títulos, no para instrucciones.[3]

### Espacio, forma e iconos

Escala de separación 4/8/12/16/24; margen de pantalla 16; target mínimo 48×48 y separación de acciones propuesta de 8. Forma común con dos radios (8 y 16), una sombra corta y borde de énfasis solo para interactivos importantes. Android recomienda 48 dp; Flutter logical pixels se comprobarán en el target real, no se equiparan a píxeles físicos.[4][9]

Iconos: conjunto propio pequeño o pack único con licencia por archivo. No sumar estilos de contorno/relleno/3D arbitrariamente. Acompañar navegación y habilidades de texto. Identificables en gris y con foco.

## 7. Composición propuesta por pantalla

- **Portada:** héroe y farol como foco; título, frase corta y Continuar. Créditos y respaldo secundarios. No agregar monedas o promociones inexistentes.
- **Combate en preparación:** HUD compacto; enemigo identificado junto a su barra; una acción «Comenzar» y acceso secundario a equipo; ayuda desplegable.
- **Combate activo:** vida separada de segmentos de carga; PM junto a skills; intención en una banda junto al enemigo con cuenta atrás; Atacar primario, Proteger secundario, Llamarada deshabilitada/lista con texto; skills compradas en fila con desplazamiento si hace falta.
- **Victoria/derrota:** resultado breve, recompensa real y siguiente decisión. No borrar al enemigo antes de completar su pose. Reintentar no debe parecer compra.
- **Taller:** resumen pequeño del héroe; Vitalidad/Daño como compras comparables (actual → siguiente, precio, estado). Habilidades agrupadas con descripción ampliable. Motivo de bloqueo visible sin repetir párrafos.
- **Selector:** cuatro héroes comparables, portrait sin padding excesivo, 2×2 elecciones, confirmar fijo. No convertir preview en selección persistente.
- **Ruta:** progresión de tres faroles y jefe como nodos claros, encuentro seleccionado explícito, condición de bloqueo y recompensa del encargo. No diseñar un mapa 3D ni más zonas.
- **Ajustes:** filas compactas con estado textual, grupos Juego/Accesibilidad/Partida/Créditos. Acciones destructivas separadas; mantener respaldo y confirmación.
- **Carga/error/recuperación:** pequeño emblema coherente; texto accionable, reintento si procede; nunca una pantalla estética que oculte el estado del guardado.
- **Escritorio:** mundo full viewport, controles limitados a un ancho legible; usar espacio lateral para información secundaria sin cambiar orden de lectura. No estirar botones a todo el monitor.

Objetivo inicial móvil normal: dock activo alrededor de 260–300 unidades, no límite rígido. En pantallas cortas/texto grande prevalece accesibilidad: scroll contextual y acciones primarias alcanzables. No reducir targets para alcanzar una cuota de altura.

## 8. Movimiento, sonido y respuesta

Diseñar una secuencia representativa: reposo → aviso enemigo → ataque → contacto → daño/bloqueo → derrota → premio. Propuestas: presión 80–120 ms, transiciones 150–220 ms, lectura de resultado 300–500 ms sin bloquear el siguiente paso. Son rangos de prototipo, no estándares universales.

No crear terremoto de cámara, flashes globales ni partículas infinitas. Respetar movimiento reducido; mantener números/estado aunque no haya desplazamiento.[10] Separar señal de daño de la información de HP; el efecto nunca decide daño. Audio opcional, sin solapamiento ilimitado; no prometer calidad auditiva sin escucha.

## 9. Assets y producción

1. Mantener los seis Toon y su manifest/licencia. No descargar otro elenco.[6]
2. Rediseñar controles en Flutter con vocabulario único; usar UI Pack como referencia, no como formulario blanco pegado al mundo.[8]
3. Escenario: misma perspectiva de apoyo, luz y contorno que actores; tres capas (distancia, arena, primer plano). No tapar barras con columnas/faroles.
4. Retrato/HUD/combate deben consumir el mismo catálogo. Atlas solo si medición de cargas/draw calls lo justifica; no infraestructura especulativa.
5. Precomponer adornos estáticos; medir reconstrucciones y efectos costosos. No añadir blur continuo para simular acabado profesional.[5]
6. No reutilizar imágenes de referencia de Supercell ni de usuarios como assets redistribuibles. Capturas propias aquí son evidencia, no una nueva dependencia runtime.

## 10. Orden de trabajo propuesto

Se reutilizan POL-01…POL-08 del TODO existente; no se cierran por este informe.

1. **POL-03, luego POL-04 — combate legible y componentes:** HUD, dock, intención, automático secundario, ayuda, jerarquía primaria/secundaria/terciaria. Primera entrega: un encuentro completo visualmente coherente.
2. **POL-05 — selector y personajes:** grid 2×2, confirmar fijo, escala/poses y retratos, cuatro elecciones y seis actores preservados.
3. **POL-04 — taller/ruta/ajustes:** aplicar componentes, quitar información ajena al contexto, corregir créditos; carga/error/final incluidos.
4. **POL-06 + POL-02 — mundo y encuentros:** composición, luz, suelo y distinción honesta de variantes.
5. **POL-01 + POL-07 — feedback final:** anticipación, impacto, premios, sonido opt-in.
6. **POL-08 — calificación humana/física:** pruebas de comprensión, accesibilidad y rendimiento. No bloquear el trabajo visual local por falta de teléfono.

## 11. Criterios de aceptación propuestos

### Funcionales y visuales

- A 390×844, sin ayuda expandida: Atacar, Proteger, carga y amenaza visibles sin scroll durante pelea; en estado previo, Comenzar prioritario.
- En 360×640 y texto 200% no hay overflow ni acciones inaccesibles; scroll permitido y documentado.
- Selector muestra las cuatro opciones y conserva confirmar/cancelar; botón de confirmación alcanzable sin perder el preview.
- Navegar a Taller/Ruta suspende combate y no cobra ni recibe daño; no alterar reloj/guardado.
- Ninguna pose de los seis actores corta cabeza/equipo o cambia arbitrariamente la escala del cuerpo.
- Estado seleccionado/deshabilitado/foco entendible sin depender de color; al menos 48×48 para controles.
- Texto normal objetivo ≥4,5:1; señal no textual necesaria ≥3:1. Evaluar gradientes y transparencias reales, no solo tokens.[2][4][11]
- Capturas de portada, preparación, pelea, victoria, derrota, taller, selector, ruta, ajustes y recuperación en móvil/escritorio. Capturas ausentes quedan pendientes, no implícitamente aprobadas.

### Verificación técnica futura, no ejecutada por esta investigación

`dart format --output=none --set-exit-if-changed lib test`

`flutter analyze`

`flutter test`

`flutter build web`

`flutter build apk --debug`

Ampliar pruebas existentes `widget_test.dart`, `character_view_test.dart`, `campaign_widget_test.dart`, `game_controls_test.dart`, `settings_test.dart`, `toon_roster_test.dart` y `asset_regression_test.dart`. No debilitar regresiones para acomodar layout. Añadir escenarios de vista corta/200% y confirmación fija como parte del trabajo, no asumir que ya existen.

En dispositivo identificado: sesión con frame timings, memoria y respuesta táctil; objetivo inicial 60 Hz cuando hardware lo permita, sin afirmar FPS medidos ahora. Revisar performance en profile, no inferirla de release web.[5]

### Validación humana propuesta

Con cinco personas que no conozcan el juego: identificar héroe, rival, vida y próxima acción; iniciar/defender/comprar sin instrucciones del observador. Registrar errores, tiempo y dudas. Objetivo preliminar: al menos cuatro completan tareas clave sin ayuda. Es un criterio exploratorio, no muestra estadística ni prueba de retención. Si fallan, revisar jerarquía antes de agregar contenido.

## 12. Qué queda sin comprobar

No hay auditoría física de móvil, lectura con TalkBack/VoiceOver, pruebas humanas, A/B, benchmark de GPU ni medición comercial. No se capturó en esta pasada el jefe ni el final de campaña, recuperación o derrota; su tratamiento es propuesta basada en código/contratos. El análisis de fuentes sostiene principios, no garantiza calidad artística. Próximo paso sugerido: aprobar la composición propuesta y ejecutar **POL-03 + la parte de componentes de POL-04**, sin otro cambio de pack.

## Sources

[1] https://unity.com/blog/games/how-to-immerse-your-players-through-effective-ui-and-game-design
[2] https://gameaccessibilityguidelines.com/provide-high-contrast-between-text-ui-and-background
[3] https://gameaccessibilityguidelines.com/use-simple-clear-text-formatting
[4] https://developer.android.com/guide/topics/ui/accessibility/apps
[5] https://docs.flutter.dev/perf/best-practices
[6] https://kenney.nl/assets/toon-characters
[7] https://supercell.com/en/games/clashroyale
[8] https://kenney.nl/assets/ui-pack
[9] https://gameaccessibilityguidelines.com/ensure-interactive-elements-virtual-controls-are-large-and-well-spaced-particularly-on-small-or-touch-screens
[10] https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
[11] https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
[12] https://raw.githubusercontent.com/google/fonts/main/ofl/nunitosans/OFL.txt
