# TODO — Farol de Ceniza

Plan maestro del trabajo pendiente. [Especificación e investigación](docs/GAME_ROADMAP.md) · [Historial completado](TODO.archive.md) · [Diseño móvil](docs/MOBILE_RPG_LAYOUT.md).

## Cómo leer este plan

- Ampliación aprobada por el usuario: «ok has todo». Implementación parcial verificada; ver [estado real](docs/IMPLEMENTATION_STATUS.md). No se declara terminada la lista completa.
- Now/Next: alcance aceptado con trabajo o calificación pendiente. Las puertas externas de dispositivo, iOS y publicación conservan sus límites.
- La ampliación RPG está aceptada para implementación local; no incluye publicación automática ni alcance infinito.
- Se preservan T-001 y T-003 terminadas en el archivo y T-002 como pendiente prioritario. Las nuevas tareas conservan dependencias aunque la prioridad agrupe entregas.
- No backend, cuentas, anuncios, pagos, gacha, clanes ni multijugador. No commits, workers, cron ni publicación autorizados.
- Cada Checks es procedimiento futuro, no evidencia de aprobación. Tests/fixtures nuevos se crean durante la tarea; no se presume que ya existen.
- Gate común para cambios de código: `dart format --output=none --set-exit-if-changed lib test && flutter analyze && flutter test`; para entregas integradas añadir `flutter build web && flutter build apk --debug`.
- Primera salida útil: cerrar/reabrir conserva la partida. Después: decisiones tácticas, variedad, cierre y calidad; no más pantallas decorativas sin conducta.

## Now

- [x] TOON-ROSTER — Integrar los seis personajes de Toon Characters
  Scope: cuatro héroes seleccionables (Luz, Bastión, Ascua, Vigía), zombi y robot como enemigos; poses, proporciones, retratos y conservación de IDs guardados. Sin Roguelike.
  Evidence: 73 pruebas, análisis limpio, builds web y APK debug. Selector y victoria con Vigía contra zombi probados en navegador móvil; hoja de seis actores en reposo/ataque/derrota revisada. No equivale a prueba física Android.
  Touches: assets/toon/; lib/domain/content.dart; lib/presentation/; lib/data/save_gate.dart; pubspec.yaml; test/; docs/ASSETS_AND_LICENSES.md.

### Pulido profesional aprobado

Investigación solicitada: [DESIGN_RESEARCH](docs/DESIGN_RESEARCH.md), con capturas propias, fuentes y propuesta de ejecución. No se ejecutó un rediseño en esta investigación. Las siguientes recomendaciones afinan tareas existentes; sus medidas nuevas son propuestas, no aceptación del usuario ni trabajo terminado.

#### Primera entrega aprobada — HUD y controles implementados

El usuario aprobó comenzar. Entrega local: dock de campaña de 320 unidades en móvil normal, nombre del héroe prioritario, vida/carga separadas, cuenta atrás/daño destacado, ayuda plegable y controles terciarios ligeros. Galería técnica retirada del gesto oculto del HUD. Ver `docs/design-evidence/polish-final.png`. Formato, análisis, 75 pruebas y builds web/APK debug aprobados; entrada/ataques/victoria probados en navegador. POL-03/POL-04 permanecen abiertos: falta completar todas las superficies y revisión física. Próxima entrega: selector/taller.

- POL-03 + POL-04: comenzar por HUD/amenaza y tres niveles de controles; objetivo, límites y criterios en secciones 6, 7 y 11 del informe. Conservar ataque manual, defensa, oro, guardados y tabs. No cambiar de pack.
  Touches: lib/presentation/rpg_view.dart; lib/presentation/campaign_menu.dart; lib/presentation/game_controls.dart; lib/presentation/game_theme.dart; test/widget_test.dart; test/campaign_widget_test.dart; test/game_controls_test.dart.
  Acceptance: en 390×844 las acciones tácticas e intención son visibles sin ayuda expandida; automático secundario; ningún control pierde semántica/teclado ni target mínimo; 360×640 y texto 200% conservan acceso mediante scroll cuando corresponda.
  Checks: dart format --output=none --set-exit-if-changed lib test; flutter analyze; flutter test; flutter build web; flutter build apk --debug; recorrido/capturas de preparación, pelea y resultado.
  Dependencies: None para prototipo local; calificación física sigue en POL-08.
- POL-05: selector con cuatro opciones, preview y confirmación fija; no ocultar Vigía ni confundir check con selección persistida. Posterior a componentes POL-04.
- POL-04, segunda entrega: taller/ruta sin HUD de pelea innecesario, ajustes agrupados y créditos reales de Kenney; incluir carga/error/recuperación. Mantener confirmación de importación y respaldo.
- POL-06/POL-02 y POL-01/POL-07: después, mundo/variantes y respuesta audiovisual según secciones 8–10; no sustituir layout por más partículas o packs.

#### Trabajo existente (aceptación y evidencia preservadas)

Segunda entrega desarrollada en worktree `redesign/ui-pass`: selector 2×2 con confirmación fija y preview sin mutación; taller/ruta aprovechan el área antes ocupada por HUD de combate; seleccionado marcado con check; ajustes agrupados y créditos Kenney corregidos. Ver capturas `docs/design-evidence/redesign-*.png`. Verificación: formato, análisis, 78 pruebas, builds web/APK debug; selector Vigía y navegación probados en navegador. Sigue pendiente el rediseño completo de portada/carga/final/recuperación, arte de escenarios y feedback audiovisual. No se declara POL-04/POL-05 completamente cerrado. Integración local a la rama principal `master` solicitada por el usuario; publicación remota no incluida en esta solicitud.

- [ ] POL-01 — Poses y animación de combate
  Progress: poses diferenciadas de defensa, impacto y derrota conectadas al estado real; test de cinco poses distintas aprobado. Pendiente anticipación y articulación completa de brazos/piernas y revisión visual por héroe.
  Acceptance: preparación, ataque, impacto, defensa y derrota legibles; reducción de movimiento; remate visible.
  Touches: lib/presentation/hero_art.dart; lib/presentation/lantern_scene.dart; test/.
- [ ] POL-02 — Cuatro enemigos con siluetas propias
  Progress: nuevo EnemyArt integrado: mota, escarabajo blindado, depredador con cola y guardián pétreo con núcleo; prueba de render y hoja comparativa inspeccionadas sin recortes graves. Falta recorrido visual de los cuatro dentro de la arena móvil.
  Acceptance: mota, acorazado, acechador y jefe diferenciados por cuerpo/equipo, no solo escala.
  Touches: lib/presentation/enemy_art.dart; lib/presentation/lantern_scene.dart; test/.
- [ ] POL-03 — HUD y acciones comprensibles
  Progress: controles actuales conservados y pelea/protección ejercitados en navegador móvil. Sigue pendiente reorganización del HUD y explicación visual de intención/maná.
  Acceptance: vida, carga, PM e intención distinguibles; acciones prioritarias visibles en móvil y accesibles al 200%.
  Touches: lib/presentation/campaign_menu.dart; lib/presentation/rpg_view.dart; test/.
- [ ] POL-04 — Lenguaje visual propio completo
  Progress: botones/confirmaciones propios existentes; iconografía y listas Material aún presentes. No cerrado.
  Acceptance: iconos, barras, navegación y controles consistentes; retirar tratamientos Material visibles sin perder teclado/semántica.
  Touches: lib/presentation/; test/.
- [ ] POL-05 — Personalidad del arte de héroes
  Progress: expresiones distintas para centinela/invocadora/guardafaroles y poses nuevas compartidas por render. Falta revisar agarres y anatomía de cada arma.
  Acceptance: expresiones/poses distintas, manos y equipo legibles; mismo arte en selector y combate.
  Touches: lib/presentation/hero_art.dart; lib/presentation/character_view.dart; test/.
- [ ] POL-06 — Sectores e iluminación
  Progress: añadidos hongos al sector blindado, cristales al acechador y puerta al jefe. Pendiente integración fina de iluminación, escala y revisión visual por sector.
  Acceptance: sectores reconocibles por elementos propios, luz y contacto con el suelo; no solo recolor.
  Touches: lib/presentation/world_art.dart; lib/presentation/lantern_scene.dart; test/.
- [ ] POL-07 — Sonido y recompensa
  Progress: cuatro cues PCM originales nuevos (purchase/level/heal/ice), eventos de compra/habilidad/bloqueo y nivel por ataque manual conectados. Falta escucha real, fanfarria/presentación de victoria y calificación auditiva.
  Acceptance: efectos propios distintos para golpe, bloqueo, habilidad, compra/nivel/victoria; audio opcional y sin acumulación; presentación legible de recompensa.
  Touches: assets/audio/; lib/presentation/game_sound.dart; lib/main.dart; lib/presentation/campaign_menu.dart; test/.
- [ ] POL-08 — Calificación física y playtest
  Acceptance: teléfono autorizado, recorrido completo, zonas seguras, interacción y rendimiento sostenido; registrar hallazgos reales.
  Blocker: flutter devices solo detecta Linux; sin teléfono conectado. No equiparar builds con esta aceptación.
  Touches: docs/IMPLEMENTATION_STATUS.md; docs/RELEASE_CHECKLIST.md.

- [x] RPG-HEROES — Ataques visibles y tres personajes jugables
  Status: done
  Scope: selección fuera del combate, diferencias de vida/daño, arte original, animación ofensiva/enemiga, números de daño y migración schema 1→2. Un personaje activo, no equipo simultáneo.
  Evidence: 42 pruebas aprobadas, flutter analyze limpio, builds web/APK debug y flutter drive Chromium correctos. Widget verifica selección Ascua y daño real. Revisión móvil de Ascua sin cortes graves. Persistencia extremo a extremo de varias acciones rápidas requiere calificación adicional; no se declara cerrada T-002.
  Touches: lib/domain/content.dart; lib/domain/lantern_run.dart; lib/presentation/hero_art.dart; lib/presentation/lantern_scene.dart; lib/presentation/campaign_menu.dart; lib/presentation/rpg_view.dart; lib/main.dart; test/; docs/RPG_COMBAT.md.

- [ ] T-002 — Guardado local versionado y recuperación
  Status: open
  Progress: Implementado snapshot, Sembast móvil/web, backup, recuperación y propiedad; pruebas de repositorio y migración pasan; recarga real conserva victoria/oro. Pendiente matriz de almacenamiento denegado/cuota y pestañas independientes con controles de recuperación.
  Sources: docs/GAME_CONCEPT.md#arquitectura-mínima-y-conservación-de-datos; docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: serialización validada de estado completo, schema/contentVersion/revisión; repositorio Sembast móvil y Sembast Web/IndexedDB, current/backup transaccionales; cola de escrituras y dueño/revisión en dos tabs; sin ganancias offline. Dependencias instaladas y builds web/Android correctos; licencias directas revisadas en docs/ASSETS_AND_LICENSES.md.
  Acceptance: conserva oro, mejora, resistencia, carga, tramo, hitos, pausa y modo; primer inicio no se confunde con corrupción; versión futura/corrupción no borra; error de escritura visible; segunda tab no sobrescribe; flush/checkpoint acotado sin escribir por frame. No prometer persistir una acción antes de su confirmación de guardado.
  Checks: flutter test; flutter analyze; flutter build web; flutter build apk --debug; recargar/reabrir, denegar almacenamiento, simular datos corruptos/futuros y abrir dos tabs. Añadir fixtures y pruebas de repositorio todavía inexistentes.
  Touches: lib/; test/; pubspec.yaml; pubspec.lock; README.md; docs/.
  Dependencies: T-001.
  Ownership: sin asignar; no ejecutando.
  Next action: completar fallo de almacenamiento/cuota, cuarentena exportable y verificación real cross-tab, sin borrar datos.
  Recovery contract: T-002 entrega bloqueo de sobrescritura, cuarentena y restauración confirmada de backup válido; exportar/importar archivos queda en T-004-3d, menú/reset completo en T-023-9f. Aplicar política current/backup y propietario/generación/revisión de docs/GAME_ROADMAP.md; rechazar colas del propietario anterior y recargar antes de readquirir escritura.
  Time contract: reiniciar solo fracción de ataque automático e intervalo de entrada actuales; las futuras intenciones/cooldowns/protección requieren duraciones restantes persistidas en sus propias tareas.

## Next

La ampliación está aprobada. Las tareas siguientes tienen implementación parcial o comprobaciones pendientes; conservar abiertas hasta satisfacer su contrato completo.

## Trabajo aceptado y calificación pendiente

No se necesita volver a aprobar la ampliación. Se mantiene cada criterio original, con evidencia parcial y siguiente brecha. Pruebas físicas/publicación requieren sus entradas externas.

- [ ] T-004-3d — Persistencia exportable: respaldo, importación y recuperación
  Status: open
  Progress: Exportar/importar y nueva partida con confirmación implementados; falta exportar cuarentena y verificar selectores/round-trip en todas las plataformas.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: A. Persistencia.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Exportar/importar JSON versionado ≤1 MiB con previsualización y backup; conservar contenido inválido; confirmar nueva partida.
  Acceptance: Exportación y restauración reproducen estado; rechazo de sobredimensión, valores inválidos y versión futura no altera original.
  Checks: Gate común y flutter test; recorrido web exportar → importar → recargar.
  Touches: lib/; test/; pubspec.yaml; pubspec.lock; docs/
  Dependencies: T-002.
  Ownership: sin asignar; no ejecutando.

- [ ] T-005-a8 — Control de sesión y navegación sin acciones ocultas
  Status: open
  Progress: Tabs suspenden y bloquean combate; pruebas widget de suspensión/pausa aprobadas; faltan regresiones del gesto de fondo en todas las tabs.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Separar pausa manual, pérdida de actividad y menú; bloquear escena fuera de Combate y restaurar intervalos sin catch-up.
  Acceptance: Abrir Mecha/Ruta no ataca ni recibe daño; regresar no anula pausa manual; misma economía antes/después de suspensión.
  Checks: Gate común y flutter test test/widget_test.dart; flutter test test/active_combat_test.dart; recorrido real de las tres tabs.
  Touches: lib/; test/
  Dependencies: T-001, T-003.
  Ownership: sin asignar; no ejecutando.

- [ ] T-006-d5 — Atacar sin exigir machacar botones
  Status: open
  Progress: Mantener ataque y cancelación implementados; falta cerrar cobertura de pointer cancel, teclado y feedback de cooldown.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Mantener pulsado o equivalente activable, cadencia limitada, feedback de cooldown, cancelación y acceso semántico/teclado.
  Acceptance: Soltar/cancelar/cambiar tab/pausar detiene la repetición; llamarada conserva activación intencional; acción equivalente sin gesto preciso.
  Checks: Gate común y flutter test; verificar pointer cancel, teclado y pulsación retenida en navegador.
  Touches: lib/; test/
  Dependencies: T-005-a8.
  Ownership: sin asignar; no ejecutando.

- [ ] T-007-0d — Catálogo y tabla de balance de encuentros
  Status: open
  Progress: Catálogo Dart, tabla docs/BALANCE.md y migración implementados; prueba de IDs y rangos aprobada. Pendiente revisión cruzada exhaustiva con todos los desbloqueos.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: C. Enemigos.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Extraer constantes en datos Dart con IDs estables para tres enemigos y jefe; tabla de HP, daños, tiempos, premios y desbloqueos.
  Acceptance: Referencias válidas, IDs únicos, valores acotados; simulación determinista; contenido no depende de Canvas; migración de tramo actual definida.
  Checks: Gate común y flutter test; revisar tabla de balance contra catálogo y partidas heredadas.
  Touches: lib/domain/; test/; docs/
  Dependencies: T-002.
  Ownership: sin asignar; no ejecutando.

- [ ] T-008-52 — Vida real, intención enemiga y derrota recuperable
  Status: open
  Progress: Vida, intención, derrota/reintento y duración persistida implementados y testeados; falta recorrido físico/reapertura en cada transición.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Vida del héroe, ataque enemigo anunciado, victoria/derrota excluyentes, recuperación sin perder oro; UI de vida real y reintento.
  Acceptance: Enemigo inflige daño solo en encuentro activo; derrota detiene combate; reintento no regala recompensa; guardar/restaurar no duplica daño. Implementar preparación/activo/suspendido/resultado y retorno explícito al farol; menús no permiten equipar durante pelea suspendida. Persistir intención y fase con tiempo activo restante, sin reset por recarga.
  Checks: Gate común y flutter test; recorrido daño → derrota → reintento y cierre/reapertura.
  Touches: lib/; test/
  Dependencies: T-005-a8, T-007-0d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-009-53 — Proteger y conservar carga para decisiones tácticas
  Status: open
  Progress: Proteger consume una vez, cooldown/ventana persistidos y ayuda accesible implementados; pruebas de borde pasan; falta feedback explícito de bloqueo/fallo.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Proteger con ventana 1 s, cooldown 3 s activos y reducción 75%; señales accesibles; ayuda de ventana ampliada sin penalización.
  Acceptance: Bloqueo consume protección una vez; cooldown y ventana se congelan en pausa y se restauran como duraciones restantes al reabrir; llamarada no se gasta automáticamente; feedback claro de bloqueo/fallo.
  Checks: Gate común y flutter test; comparar protegido/no protegido y probar borde de ventana con reloj falso.
  Touches: lib/; test/
  Dependencies: T-008-52.
  Ownership: sin asignar; no ejecutando.

- [ ] T-010-da — Tres enemigos con conductas distintas
  Status: open
  Progress: Tres conductas y arte distintos implementados; falta playtest de dos respuestas tácticas y ajuste de coraza.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: C. Enemigos.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Mota, Acorazado con fase vulnerable y Acechador con golpe anunciado; arte diferenciado y fichas breves; no solo HP mayor.
  Acceptance: Dos respuestas tácticas observables; cambios de enemigo reinician solo estado transitorio; recompensa una vez por victoria.
  Checks: Gate común y flutter test; jugar cada variante con llamarada/protección y comprobar persistencia.
  Touches: lib/; test/; docs/
  Dependencies: T-009-53.
  Ownership: sin asignar; no ejecutando.

- [ ] T-011-d8 — XP y nivel acotados del guardafaroles
  Status: open
  Progress: XP y cinco niveles implementados y guardados; prueba de nivel máximo/round-trip aprobada. Pendiente presentación antes/después y todos los bordes de umbral.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: D. Progresión.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Cinco niveles propuestos; XP por victoria, vida base y desbloqueos claros; no puntos manuales ni curva infinita.
  Acceptance: Level-up calculado una vez, máximo definido, UI antes/después y migración sin pérdida; XP jamás se cobra de nuevo al recargar.
  Checks: Gate común y flutter test; probar múltiples umbrales, nivel máximo y guardado heredado.
  Touches: lib/; test/; docs/
  Dependencies: T-008-52.
  Ownership: sin asignar; no ejecutando.

- [ ] T-012-57 — Módulos del farol y dos configuraciones viables
  Status: open
  Progress: Cuatro módulos/two slots implementados; bloqueo en pelea y persistencia probados; falta comparación de dos builds y comprobación de estrategia dominante.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: D. Progresión.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Cuatro módulos por hitos; dos ranuras sin duplicados; comparación y cambio gratis solo fuera de encuentro.
  Acceptance: Se guardan selección/desbloqueos; dos builds sirven a enemigos distintos; no sumar bonificación dos veces; sin rarezas ni inventario aleatorio.
  Checks: Gate común y flutter test; recorrido equipar → combatir → cambiar → recargar y comparación de dos builds.
  Touches: lib/; test/; docs/
  Dependencies: T-010-da, T-011-d8.
  Ownership: sin asignar; no ejecutando.

- [ ] T-013-20 — Ruta seleccionable y restauración persistente
  Status: open
  Progress: Selección/bloqueo de encuentros y faroles implementados; falta regresión de todos los bordes de transición y recarga.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: E. Ruta.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Tres sectores con encuentros visibles, requisitos y reintentos; progreso existente conservado; restauración cambia detalles del escenario.
  Acceptance: Encuentros bloqueados no se inician; repetir no borra faroles ni hitos; selección y transición no entregan oro.
  Checks: Gate común y flutter test; recorrido de los tres sectores y recarga en transición.
  Touches: lib/; test/; docs/
  Dependencies: T-010-da.
  Ownership: sin asignar; no ejecutando.

- [ ] T-014-2d — Jefe Guardián del Umbral y cierre de campaña
  Status: open
  Progress: Jefe, segunda fase y cierre implementados; campaña completa pasa simulación; falta recorrido end-to-end real del jefe y recompensa final.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: C. Enemigos.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Jefe de dos fases reutilizando intención y protección; puerta final; preservar faroles ya ganados y migrar cierre anterior sin penalizar.
  Acceptance: Victoria final requiere encuentro nuevo, nunca retiro de progreso legado; dos fases legibles; derrota/reintento funcional; recompensa final única.
  Checks: Gate común y flutter test; recorrido jefe → derrota/reintento → victoria → recarga.
  Touches: lib/; test/; docs/
  Dependencies: T-012-57, T-013-20.
  Ownership: sin asignar; no ejecutando.

- [ ] T-015-72 — Encargos finitos y recompensa por restaurar
  Status: open
  Progress: Tres encargos y registro de cobro implementados; doble cobro probado en dominio; falta matriz de importación/backup.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: E. Ruta.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Tres encargos: primera criatura, primera llamarada y ruta restaurada; cobro explícito, finito e idempotente.
  Acceptance: Navegar no cobra; objetivo alcanzado explica premio; saldo y cobro se persisten juntos. Idempotencia dentro del estado restaurado; importar una copia anterior reemplaza toda la partida, no fusiona saldos ni ofrece garantía antirrollback.
  Checks: Gate común y flutter test; probar reclamar dos veces, guardar antes/después y restaurar backup.
  Touches: lib/; test/; docs/
  Dependencies: T-013-20, T-014-2d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-016-9e — Tutorial contextual y objetivo visible
  Status: open
  Progress: Ayuda inicial omitible persistida y guía en ajustes implementadas; falta guía contextual progresiva completa y comprensión observada.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Guía omitible y repetible de ataque, carga, protección, mejora y guardado; objetivo próximo visible sin tapar pelea.
  Acceptance: Partida nueva permite jugar de inmediato; tutorial no concede oro ni altera daño; veterano puede omitir; lector identifica próximo paso.
  Checks: Gate común y flutter test; recorrido nuevo/omitido/retomado y revisión móvil al 200%.
  Touches: lib/; test/; docs/
  Dependencies: T-009-53, T-013-20.
  Ownership: sin asignar; no ejecutando.

- [ ] T-017-a2 — Ajustes persistentes y accesibilidad completa
  Status: open
  Progress: Ajustes persistidos, ayuda de protección y reducción de movimiento; falta foco/lector/Back y matriz real de accesibilidad.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Ajustes de movimiento, vibración opt-in, audio, repetición accesible y ventana de protección; foco, contraste, labels y navegación Back.
  Acceptance: Ajustes sobreviven reinicio; reducción de movimiento no cambia simulación; sin barreras solo de color/sonido; todas las acciones accesibles.
  Checks: Gate común y flutter test; teclado/lector cuando disponible, texto 200%, insets y restauración de preferencias.
  Touches: lib/; test/; docs/
  Dependencies: T-006-d5, T-009-53.
  Ownership: sin asignar; no ejecutando.

- [ ] T-018-55 — Arte, animación de combate y HUD de amenazas
  Status: open
  Progress: Arte diferenciado, escudo, escala y geometría compartida; captura móvil inspeccionada; falta feedback detallado daño/victoria y matriz final de animaciones.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Diferenciar tres enemigos/jefe; impacto, daño, victoria, protección y restauración; geometría HUD compartida con escena; lista de procedencia/licencias.
  Acceptance: Personajes no se deforman; barras ancladas; efectos acotados, nada tapa controles; sin flicker rápido; licencias por asset.
  Checks: Gate común y flutter test; capturas reales estrecha/escritorio y prueba de reducción de movimiento.
  Touches: lib/presentation/; test/; assets/; docs/; pubspec.yaml
  Dependencies: T-010-da, T-014-2d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-019-aa — Audio y feedback opcionales sin dependencia de sonido
  Status: open
  Progress: Cuatro WAV originales, canal único y sonido opcional implementados; falta bloqueo/farol sonoro, volumen, mute inmediato y prueba auditiva Android.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Efectos de ataque, impacto, cobro, bloqueo y farol; audio local original/licenciado, volumen y mute; no servicios pagados.
  Acceptance: Mute real y persistente; no solapamientos ilimitados; amenazas comprensibles sin audio; registro de licencia y tamaño.
  Checks: Gate común y flutter test; prueba manual audio/mute/interrupción en Android y navegador.
  Touches: lib/; test/; assets/; pubspec.yaml; pubspec.lock; docs/
  Dependencies: T-017-a2, T-018-55.
  Ownership: sin asignar; no ejecutando.

- [ ] T-020-32 — Balance y prueba de diversión con jugadores
  Status: open
  Progress: Simulación de campaña completa con tiempo activo, protección/mejoras pasa; no hay playtest humano ni comparación completa de modos/builds.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Simulación y recorrido de manual, asistido y automático; comparar módulos, tiempos de mejora y cierre; sesión observada sin telemetría remota.
  Acceptance: Sin bloqueo económico; dos decisiones comprendidas; primera meta alcanzada sin intervención; registrar problemas reales y ajustar, no prometer retención.
  Checks: Gate común y flutter test; simulación con reloj falso y hoja de playtest con tiempos/observaciones reales.
  Touches: lib/domain/; test/; docs/
  Dependencies: T-015-72, T-016-9e, T-019-aa, T-023-9f.
  Ownership: sin asignar; no ejecutando.

- [ ] T-021-2c — Regresión integral, migraciones y errores de almacenamiento
  Status: open
  Progress: 35 pruebas unit/widget pasan y flutter drive integration pasa en Chromium; falta matriz completa de disco/cuota/cross-tab y recorrido integral del final.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Integración partida nueva → nivel → derrota → jefe → cierre → reinicio; disco/cuota, dos tabs, versiones futuras y migraciones.
  Acceptance: Sin pérdida silenciosa, duplicación, softlock ni dependencia del framerate; datos previos conservados y recuperación comprobada.
  Checks: Gate común y flutter test; CHROME_EXECUTABLE=/usr/sbin/chromium flutter drive --driver=test_driver/integration_test.dart --target=integration_test/playthrough_test.dart -d web-server --browser-name=chrome --headless --web-port=8181; flutter build web; flutter build apk --debug. Runner requiere chromedriver en puerto 4444; flutter test -d web-server no soporta integración.
  Touches: test/; integration_test/; lib/; pubspec.yaml; docs/
  Dependencies: T-004-3d, T-015-72, T-017-a2, T-023-9f.
  Ownership: sin asignar; no ejecutando.

- [ ] T-022-4f — Calificación Android real y rendimiento
  Status: open
  Progress: APK profile compilado. Falta dispositivo Android: flutter devices solo Linux; no FPS/memoria/calor físicos medidos.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Build profile, sesión 10 min en dispositivo identificado, memoria, frames, calor, gestos, llamadas y reinicio de proceso; informe de defectos.
  Acceptance: Recorrido completo sin errores críticos; medir objetivo de fluidez y memoria estable, registrar hardware/resultados, corregir hallazgos; no sustituir por web.
  Checks: Gate común y flutter build apk --profile; flutter devices; flutter run --profile -d <DEVICE_ID>. DEVICE_ID se obtiene del equipo autorizado, no es comando listo sin dispositivo.
  Touches: lib/; test/; android/; docs/
  Dependencies: T-020-32, T-021-2c.
  Ownership: sin asignar; no ejecutando.

- [ ] T-023-9f — Cierre local: menú inicial, final y nueva partida segura
  Status: open
  Progress: Menú Continuar, final, práctica, créditos y nueva partida respaldada implementados; falta recorrido confirmado de reset/recuperación y teclado.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: E. Ruta.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Continuar/partida nueva/créditos, cierre rejugable, confirmación y backup antes de reset, resumen de contenido terminado.
  Acceptance: Continuar restaura estado; no reset accidental; sin promesas de contenido inexistente; cada opción funciona con teclado/tacto.
  Checks: Gate común y flutter test; recorrer continuar → final → práctica → nueva partida confirmada y recuperar backup.
  Touches: lib/; test/; docs/
  Dependencies: T-004-3d, T-014-2d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-024-e3 — Paquete y checklist de publicación opcional
  Status: open
  Progress: Checklist preparado en docs/RELEASE_CHECKLIST.md; marca/identificador/firma/privacidad/capturas finales pendientes; no publicación autorizada.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Preparar revisión de nombre, icono, identificador definitivo, licencias, privacidad/datos, capturas reales, firma/versionado y ficha; no publicar.
  Acceptance: Checklist distingue cumplido/pendiente; no claves en repo ni claims falsos; autoridad explícita para cuenta, firma, pagos y publicación.
  Checks: Gate común y flutter build appbundle --release solo después de firma autorizada; revisión de permisos, licencias y ficha; no ejecutar publicación en esta tarea.
  Touches: android/; ios/; web/; pubspec.yaml; docs/; README.md
  Dependencies: T-022-4f, T-023-9f.
  Ownership: sin asignar; no ejecutando.

- [ ] T-025-45 — Calificación iOS separada
  Status: open
  Progress: Bloqueo externo: Linux sin macOS/Xcode ni iPhone. No compilado ni probado iOS.
  Readiness: Accepted; cierre pendiente de criterios completos. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Revisar deployment target, layout, guardado/ciclo de vida, audio y pruebas reales iOS; no bloquea Android ni incluye publicación.
  Acceptance: Build y recorrido real registrados en macOS/Xcode y dispositivo; no inferir paridad desde Android.
  Checks: Gate común y flutter build ios --no-codesign en macOS; flutter devices; recorrido en dispositivo autorizado. Pendiente acceso a entorno iOS.
  Touches: ios/; lib/; test/; docs/
  Dependencies: T-021-2c, T-023-9f.
  Ownership: sin asignar; no ejecutando.

## Opciones posteriores, no comprometidas

- Progreso offline limitado: solo evaluar después de probar la versión ampliada; no conceder victorias ni derrotar jefe fuera de sesión. Hace falta confirmar si aporta valor a quien pidió interacción. No forma parte de la primera versión.
- Más rutas, héroes jugables, cosméticos, traducciones u otras plataformas: no hay compromiso ni tareas ejecutables; revisar alcance y coste cuando el juego base esté validado.
- Nube, cuentas, anuncios, compras, gacha, clanes y multijugador: excluidos; no crear infraestructura anticipada.

## Cierre y control de cambios

La primera versión local se considera terminada solo con los criterios de `docs/GAME_ROADMAP.md#criterios-de-juego-terminado`, no por cerrar una lista de código. Cada ampliación cambia su propio contrato y sus migraciones, preservando lo ya logrado. Publicación e iOS son puertas separadas, no condiciones para llamar funcional al prototipo local Android.

No se asignan fechas aún: primero medir la entrega de persistencia y el combate ampliado. Toda función no listada requiere incorporarse de forma explícita; «absolutamente todo» no autoriza scope infinito.
