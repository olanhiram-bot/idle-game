# TODO — Farol de Ceniza

Plan maestro del trabajo pendiente. [Especificación e investigación](docs/GAME_ROADMAP.md) · [Historial completado](TODO.archive.md) · [Diseño móvil](docs/MOBILE_RPG_LAYOUT.md).

## Cómo leer este plan

- Esta entrega documenta, no implementa. Nada está ejecutándose por crear esta lista.
- Now: alcance ya aceptado. Next: sucesores aceptados cuando existan. Needs decision: ampliaciones propuestas por el diseñador y puertas externas; no elegibles para ejecución automática.
- La ampliación RPG descrita es una recomendación finita para aprobación, no una promesa de todas las funciones de un RPG comercial.
- Se preservan T-001 y T-003 terminadas en el archivo y T-002 como pendiente prioritario. Las nuevas tareas conservan dependencias aunque la prioridad agrupe entregas.
- No backend, cuentas, anuncios, pagos, gacha, clanes ni multijugador. No commits, workers, cron ni publicación autorizados.
- Cada Checks es procedimiento futuro, no evidencia de aprobación. Tests/fixtures nuevos se crean durante la tarea; no se presume que ya existen.
- Gate común para cambios de código: `dart format --output=none --set-exit-if-changed lib test && flutter analyze && flutter test`; para entregas integradas añadir `flutter build web && flutter build apk --debug`.
- Primera salida útil: cerrar/reabrir conserva la partida. Después: decisiones tácticas, variedad, cierre y calidad; no más pantallas decorativas sin conducta.

## Now

- [ ] T-002 — Guardado local versionado y recuperación
  Status: open
  Sources: docs/GAME_CONCEPT.md#arquitectura-mínima-y-conservación-de-datos; docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: serialización validada de estado completo, schema/contentVersion/revisión; repositorio Sembast móvil y Sembast Web/IndexedDB, current/backup transaccionales; cola de escrituras y dueño/revisión en dos tabs; sin ganancias offline. Decisión técnica del plan, paquetes aún sin instalar; revisar compatibilidad/licencias antes de fijarlos.
  Acceptance: conserva oro, mejora, resistencia, carga, tramo, hitos, pausa y modo; primer inicio no se confunde con corrupción; versión futura/corrupción no borra; error de escritura visible; segunda tab no sobrescribe; flush/checkpoint acotado sin escribir por frame. No prometer persistir una acción antes de su confirmación de guardado.
  Checks: flutter test; flutter analyze; flutter build web; flutter build apk --debug; recargar/reabrir, denegar almacenamiento, simular datos corruptos/futuros y abrir dos tabs. Añadir fixtures y pruebas de repositorio todavía inexistentes.
  Touches: lib/; test/; pubspec.yaml; pubspec.lock; README.md; docs/.
  Dependencies: T-001.
  Ownership: sin asignar; no ejecutando.
  Next action: añadir test de round-trip y rechazo de snapshot inválido, después adaptadores con transacción y errores visibles.

## Next

No hay ampliaciones nuevas aprobadas para ejecución. La siguiente fase propuesta se detalla debajo, no se activa por estar documentada.

## Needs decision

Las tareas siguientes requieren aprobación del alcance ampliado. Los números, nombres, nivel máximo y módulos son decisiones propuestas del diseñador. La calificación física/publicación además conserva sus puertas externas.

- [ ] T-004-3d — Persistencia exportable: respaldo, importación y recuperación
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: A. Persistencia.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Exportar/importar JSON versionado ≤1 MiB con previsualización y backup; conservar contenido inválido; confirmar nueva partida.
  Acceptance: Exportación y restauración reproducen estado; rechazo de sobredimensión, valores inválidos y versión futura no altera original.
  Checks: Gate común y flutter test; recorrido web exportar → importar → recargar.
  Touches: lib/; test/; pubspec.yaml; pubspec.lock; docs/
  Dependencies: T-002.
  Ownership: sin asignar; no ejecutando.

- [ ] T-005-a8 — Control de sesión y navegación sin acciones ocultas
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Separar pausa manual, pérdida de actividad y menú; bloquear escena fuera de Combate y restaurar intervalos sin catch-up.
  Acceptance: Abrir Mecha/Ruta no ataca ni recibe daño; regresar no anula pausa manual; misma economía antes/después de suspensión.
  Checks: Gate común y flutter test test/widget_test.dart; flutter test test/active_combat_test.dart; recorrido real de las tres tabs.
  Touches: lib/; test/
  Dependencies: T-001, T-003.
  Ownership: sin asignar; no ejecutando.

- [ ] T-006-d5 — Atacar sin exigir machacar botones
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Mantener pulsado o equivalente activable, cadencia limitada, feedback de cooldown, cancelación y acceso semántico/teclado.
  Acceptance: Soltar/cancelar/cambiar tab/pausar detiene la repetición; llamarada conserva activación intencional; acción equivalente sin gesto preciso.
  Checks: Gate común y flutter test; verificar pointer cancel, teclado y pulsación retenida en navegador.
  Touches: lib/; test/
  Dependencies: T-005-a8.
  Ownership: sin asignar; no ejecutando.

- [ ] T-007-0d — Catálogo y tabla de balance de encuentros
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: C. Enemigos.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Extraer constantes en datos Dart con IDs estables para tres enemigos y jefe; tabla de HP, daños, tiempos, premios y desbloqueos.
  Acceptance: Referencias válidas, IDs únicos, valores acotados; simulación determinista; contenido no depende de Canvas; migración de tramo actual definida.
  Checks: Gate común y flutter test; revisar tabla de balance contra catálogo y partidas heredadas.
  Touches: lib/domain/; test/; docs/
  Dependencies: T-002.
  Ownership: sin asignar; no ejecutando.

- [ ] T-008-52 — Vida real, intención enemiga y derrota recuperable
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Vida del héroe, ataque enemigo anunciado, victoria/derrota excluyentes, recuperación sin perder oro; UI de vida real y reintento.
  Acceptance: Enemigo inflige daño solo en encuentro activo; derrota detiene combate; reintento no regala recompensa; guardar/restaurar no duplica daño.
  Checks: Gate común y flutter test; recorrido daño → derrota → reintento y cierre/reapertura.
  Touches: lib/; test/
  Dependencies: T-005-a8, T-007-0d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-009-53 — Proteger y conservar carga para decisiones tácticas
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: B. Combate.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Proteger con ventana 1 s, cooldown 3 s activos y reducción 75%; señales accesibles; ayuda de ventana ampliada sin penalización.
  Acceptance: Bloqueo consume protección una vez; cooldown se congela en pausa; llamarada no se gasta automáticamente; feedback claro de bloqueo/fallo.
  Checks: Gate común y flutter test; comparar protegido/no protegido y probar borde de ventana con reloj falso.
  Touches: lib/; test/
  Dependencies: T-008-52.
  Ownership: sin asignar; no ejecutando.

- [ ] T-010-da — Tres enemigos con conductas distintas
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: C. Enemigos.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Mota, Acorazado con fase vulnerable y Acechador con golpe anunciado; arte diferenciado y fichas breves; no solo HP mayor.
  Acceptance: Dos respuestas tácticas observables; cambios de enemigo reinician solo estado transitorio; recompensa una vez por victoria.
  Checks: Gate común y flutter test; jugar cada variante con llamarada/protección y comprobar persistencia.
  Touches: lib/; test/; docs/
  Dependencies: T-009-53.
  Ownership: sin asignar; no ejecutando.

- [ ] T-011-d8 — XP y nivel acotados del guardafaroles
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: D. Progresión.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Cinco niveles propuestos; XP por victoria, vida base y desbloqueos claros; no puntos manuales ni curva infinita.
  Acceptance: Level-up calculado una vez, máximo definido, UI antes/después y migración sin pérdida; XP jamás se cobra de nuevo al recargar.
  Checks: Gate común y flutter test; probar múltiples umbrales, nivel máximo y guardado heredado.
  Touches: lib/; test/; docs/
  Dependencies: T-008-52.
  Ownership: sin asignar; no ejecutando.

- [ ] T-012-57 — Módulos del farol y dos configuraciones viables
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: D. Progresión.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Cuatro módulos por hitos; dos ranuras sin duplicados; comparación y cambio gratis solo fuera de encuentro.
  Acceptance: Se guardan selección/desbloqueos; dos builds sirven a enemigos distintos; no sumar bonificación dos veces; sin rarezas ni inventario aleatorio.
  Checks: Gate común y flutter test; recorrido equipar → combatir → cambiar → recargar y comparación de dos builds.
  Touches: lib/; test/; docs/
  Dependencies: T-010-da, T-011-d8.
  Ownership: sin asignar; no ejecutando.

- [ ] T-013-20 — Ruta seleccionable y restauración persistente
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: E. Ruta.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Tres sectores con encuentros visibles, requisitos y reintentos; progreso existente conservado; restauración cambia detalles del escenario.
  Acceptance: Encuentros bloqueados no se inician; repetir no borra faroles ni hitos; selección y transición no entregan oro.
  Checks: Gate común y flutter test; recorrido de los tres sectores y recarga en transición.
  Touches: lib/; test/; docs/
  Dependencies: T-010-da.
  Ownership: sin asignar; no ejecutando.

- [ ] T-014-2d — Jefe Guardián del Umbral y cierre de campaña
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: C. Enemigos.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Jefe de dos fases reutilizando intención y protección; puerta final; preservar faroles ya ganados y migrar cierre anterior sin penalizar.
  Acceptance: Victoria final requiere encuentro nuevo, nunca retiro de progreso legado; dos fases legibles; derrota/reintento funcional; recompensa final única.
  Checks: Gate común y flutter test; recorrido jefe → derrota/reintento → victoria → recarga.
  Touches: lib/; test/; docs/
  Dependencies: T-012-57, T-013-20.
  Ownership: sin asignar; no ejecutando.

- [ ] T-015-72 — Encargos finitos y recompensa por restaurar
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: E. Ruta.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Tres encargos: primera criatura, primera llamarada y ruta restaurada; cobro explícito, finito e idempotente.
  Acceptance: Navegar no cobra; objetivo alcanzado explica premio; reiniciar/importar no repite cobro ya persistido.
  Checks: Gate común y flutter test; probar reclamar dos veces, guardar antes/después y restaurar backup.
  Touches: lib/; test/; docs/
  Dependencies: T-013-20, T-014-2d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-016-9e — Tutorial contextual y objetivo visible
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Guía omitible y repetible de ataque, carga, protección, mejora y guardado; objetivo próximo visible sin tapar pelea.
  Acceptance: Partida nueva permite jugar de inmediato; tutorial no concede oro ni altera daño; veterano puede omitir; lector identifica próximo paso.
  Checks: Gate común y flutter test; recorrido nuevo/omitido/retomado y revisión móvil al 200%.
  Touches: lib/; test/; docs/
  Dependencies: T-009-53, T-013-20.
  Ownership: sin asignar; no ejecutando.

- [ ] T-017-a2 — Ajustes persistentes y accesibilidad completa
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Ajustes de movimiento, vibración opt-in, audio, repetición accesible y ventana de protección; foco, contraste, labels y navegación Back.
  Acceptance: Ajustes sobreviven reinicio; reducción de movimiento no cambia simulación; sin barreras solo de color/sonido; todas las acciones accesibles.
  Checks: Gate común y flutter test; teclado/lector cuando disponible, texto 200%, insets y restauración de preferencias.
  Touches: lib/; test/; docs/
  Dependencies: T-006-d5, T-009-53.
  Ownership: sin asignar; no ejecutando.

- [ ] T-018-55 — Arte, animación de combate y HUD de amenazas
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Diferenciar tres enemigos/jefe; impacto, daño, victoria, protección y restauración; geometría HUD compartida con escena; lista de procedencia/licencias.
  Acceptance: Personajes no se deforman; barras ancladas; efectos acotados, nada tapa controles; sin flicker rápido; licencias por asset.
  Checks: Gate común y flutter test; capturas reales estrecha/escritorio y prueba de reducción de movimiento.
  Touches: lib/presentation/; test/; assets/; docs/; pubspec.yaml
  Dependencies: T-010-da, T-014-2d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-019-aa — Audio y feedback opcionales sin dependencia de sonido
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: F. Presentación.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Efectos de ataque, impacto, cobro, bloqueo y farol; audio local original/licenciado, volumen y mute; no servicios pagados.
  Acceptance: Mute real y persistente; no solapamientos ilimitados; amenazas comprensibles sin audio; registro de licencia y tamaño.
  Checks: Gate común y flutter test; prueba manual audio/mute/interrupción en Android y navegador.
  Touches: lib/; test/; assets/; pubspec.yaml; pubspec.lock; docs/
  Dependencies: T-017-a2, T-018-55.
  Ownership: sin asignar; no ejecutando.

- [ ] T-020-32 — Balance y prueba de diversión con jugadores
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Simulación y recorrido de manual, asistido y automático; comparar módulos, tiempos de mejora y cierre; sesión observada sin telemetría remota.
  Acceptance: Sin bloqueo económico; dos decisiones comprendidas; primera meta alcanzada sin intervención; registrar problemas reales y ajustar, no prometer retención.
  Checks: Gate común y flutter test; simulación con reloj falso y hoja de playtest con tiempos/observaciones reales.
  Touches: lib/domain/; test/; docs/
  Dependencies: T-015-72, T-016-9e, T-019-aa.
  Ownership: sin asignar; no ejecutando.

- [ ] T-021-2c — Regresión integral, migraciones y errores de almacenamiento
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Integración partida nueva → nivel → derrota → jefe → cierre → reinicio; disco/cuota, dos tabs, versiones futuras y migraciones.
  Acceptance: Sin pérdida silenciosa, duplicación, softlock ni dependencia del framerate; datos previos conservados y recuperación comprobada.
  Checks: Gate común y flutter test; flutter test integration_test; flutter build web; flutter build apk --debug. Crear fixtures/integration_test aún inexistentes.
  Touches: test/; integration_test/; lib/; pubspec.yaml; docs/
  Dependencies: T-004-3d, T-015-72, T-017-a2.
  Ownership: sin asignar; no ejecutando.

- [ ] T-022-4f — Calificación Android real y rendimiento
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Build profile, sesión 10 min en dispositivo identificado, memoria, frames, calor, gestos, llamadas y reinicio de proceso; informe de defectos.
  Acceptance: Recorrido completo sin errores críticos; medir objetivo de fluidez y memoria estable, registrar hardware/resultados, corregir hallazgos; no sustituir por web.
  Checks: Gate común y flutter build apk --profile; flutter devices; flutter run --profile -d <DEVICE_ID>. DEVICE_ID se obtiene del equipo autorizado, no es comando listo sin dispositivo.
  Touches: lib/; test/; android/; docs/
  Dependencies: T-020-32, T-021-2c.
  Ownership: sin asignar; no ejecutando.

- [ ] T-023-9f — Cierre local: menú inicial, final y nueva partida segura
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: E. Ruta.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Continuar/partida nueva/créditos, cierre rejugable, confirmación y backup antes de reset, resumen de contenido terminado.
  Acceptance: Continuar restaura estado; no reset accidental; sin promesas de contenido inexistente; cada opción funciona con teclado/tacto.
  Checks: Gate común y flutter test; recorrer continuar → final → práctica → nueva partida confirmada y recuperar backup.
  Touches: lib/; test/; docs/
  Dependencies: T-004-3d, T-014-2d.
  Ownership: sin asignar; no ejecutando.

- [ ] T-024-e3 — Paquete y checklist de publicación opcional
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: G. Calidad.
  Sources: docs/GAME_ROADMAP.md#sistemas-propuestos-y-reglas-de-referencia
  Scope: Preparar revisión de nombre, icono, identificador definitivo, licencias, privacidad/datos, capturas reales, firma/versionado y ficha; no publicar.
  Acceptance: Checklist distingue cumplido/pendiente; no claves en repo ni claims falsos; autoridad explícita para cuenta, firma, pagos y publicación.
  Checks: Gate común y flutter build appbundle --release solo después de firma autorizada; revisión de permisos, licencias y ficha; no ejecutar publicación en esta tarea.
  Touches: android/; ios/; web/; pubspec.yaml; docs/; README.md
  Dependencies: T-022-4f, T-023-9f.
  Ownership: sin asignar; no ejecutando.

- [ ] T-025-45 — Calificación iOS separada
  Status: open
  Readiness: Proposed; aprobación del alcance ampliado pendiente. Área: G. Calidad.
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
