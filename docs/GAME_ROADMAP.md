# Farol de Ceniza — plan de juego completo y alcanzable

## Autoridad y alcance

Status: Accepted

El usuario autorizó implementar el plan con «ok has todo». Estado real y límites: `IMPLEMENTATION_STATUS.md`. La publicación, cuentas, claves y pagos siguen requiriendo autoridad separada; pruebas físicas e iOS dependen de equipo disponible. Las descripciones de ausencia siguientes son la línea base de investigación, no el estado actual.

El usuario pidió investigar y documentar en TODO.md todo el trabajo para que el juego funcione mejor, sea más RPG y tenga variedad. Esta entrega es planificación y documentación; no implementa sistemas ni inicia ejecución autónoma. Mantiene el proyecto Flutter + Flame + Dart y la identidad del guardafaroles. Las ampliaciones y sus cifras son decisiones propuestas del diseñador, no elecciones previas del usuario. Guardado y preservación del prototipo actual sí son alcance ya aceptado.

«Todo» significa el trabajo necesario para una primera versión local terminada y su validación, no todas las funcionalidades posibles de un RPG. El juego ya arranca y permite jugar; lo que falta es continuidad, decisiones más profundas, contenido y calificación de calidad. Ninguna cantidad de funcionalidades garantiza diversión o éxito comercial.

## Estado observado

Inspeccionados: `lib/domain/lantern_run.dart`, `lib/main.dart`, `lib/presentation/rpg_view.dart`, `lib/presentation/lantern_scene.dart`, `lib/presentation/characters.dart`, `pubspec.yaml` y las tres pruebas actuales.

- Hay combate manual, llamarada tras cuatro ataques, automático optativo, oro, cinco compras de mecha y tres hitos. Las recompensas y reglas están separadas del render.
- Hay personajes vectoriales originales, escena a todo el viewport, barras contextuales y tres tabs inferiores. No es necesario rehacerlo desde cero.
- No hay serialización, almacenamiento, recuperación ni guardado al salir; recargar pierde progreso.
- El enemigo no ataca; el héroe no tiene vida. Pulsar más rápido, hasta el límite, casi siempre es la única decisión de combate.
- Los tres tramos reutilizan enemigo y entorno; solo cambia resistencia. Al completar la ruta siguen los combates sin una meta nueva; al agotar mejoras el oro carece de un uso posterior.
- No hay equipo, niveles, jefe, exploración, encargos, tutorial guiado, ajustes persistentes, audio, exportación ni importación.
- Se necesita verificar el gesto de escena cuando está abierta otra tab: hoy sigue conectado a atacar. No asumir que es un bug ya probado; debe fijarse el comportamiento y cubrirse.
- Las fórmulas de HUD y escala se calculan tanto en vista como en escena: riesgo de desalineación en futuras ampliaciones, no prueba de fallo actual.
- Base reejecutada en esta investigación: `flutter analyze` sin problemas y `flutter test` con 14 pruebas aprobadas. Esas pruebas no cubren sistemas futuros ni certifican dispositivo físico.
- La carpeta no es un repositorio Git; no se creó uno ni se hicieron commits.

## Investigación aplicada

El postmortem de War Clicks describe cómo evolucionó desde un prototipo y subraya decisiones de optimización y balance en vez de basar la experiencia solo en hacer clic durante más tiempo.[5] Aplicación propuesta: ampliar una sola ruta con tácticas, no añadir diez monedas o una tienda antes de validar el combate.

El artículo sobre elecciones interesantes destaca la reacción del mundo a las acciones y las decisiones entre corto y largo plazo.[6] Aplicación propuesta: que guardar carga, protegerse, elegir un módulo y completar un encargo tengan consecuencias visibles. No trasladamos su narrativa ni sus sistemas.

Android advierte que sumar funciones no debe perjudicar con menús saturados, contenido obsoleto o errores.[7] Aplicación propuesta: una ruta terminable, tres variantes de enemigo y un jefe; no mundo abierto, campaña interminable ni clanes.

Game Accessibility Guidelines identifica la pulsación rápida repetida como barrera y recomienda simplificarla o evitarla.[12] Aplicación propuesta: mantener ataque directo pero añadir mantener pulsado/opción equivalente; las decisiones vienen de habilidades y amenazas, no de exigir velocidad física.

Para las tabs conservamos navegación separada de acciones y etiquetas persistentes, conforme a la guía de Apple.[1] Los avisos y barras no dependerán solo del color, siguiendo la guía de accesibilidad de Microsoft.[2] Posición y controles seguros mantienen los criterios documentados en `MOBILE_RPG_LAYOUT.md`.

`shared_preferences` advierte que no debe utilizarse para datos críticos por sus garantías de persistencia.[10] Para el guardado de progreso seleccionamos como decisión técnica del plan un repositorio transaccional con Sembast en móvil y Sembast Web sobre IndexedDB; sus docs exponen transacciones y soporte web.[8][9] No se instalaron paquetes ni se demostró todavía su compatibilidad real con este proyecto. T-002 debe resolver y fijar dependencias compatibles, verificar licencias y probar los adaptadores antes de declararse terminado; si fallan requisitos de plataforma, replanificar esa tarea sin descartar datos.

La documentación web señala que el almacenamiento se separa por origen y puede estar sujeto a cuotas y eliminación.[11] Aplicación: error visible, exportación/importación, puerto de desarrollo estable y pruebas de concurrencia; no prometer conservación perpetua ni recuperación al desinstalar.

## Definición del producto propuesto

Un RPG incremental de sesiones cortas en el que exploras una galería, peleas activamente contra hollín y restauras tres faroles hasta abrir el camino al exterior. Se puede terminar y luego repetir encuentros elegidos. El automático es una ayuda voluntaria; nunca el sustituto obligado de jugar.

### Límites de la primera versión ampliada

- Un héroe, una ruta dividida en tres sectores y una única composición de escenario que cambia al restaurarse.
- Tres enemigos normales con conductas diferentes y un jefe final; no son cuatro clases de personajes jugables.
- Una moneda económica, oro. La carga de habilidad y la vida son recursos de combate, no monedas.
- Nivel del héroe con límite propuesto de cinco, sin puntos de atributo manuales. XP proviene de victorias y no se gasta.
- Dos ranuras de módulo del farol y cuatro módulos deterministas que se obtienen por hitos; sin rarezas, azar, mochila ilimitada ni mercado.
- Tres encargos finitos y un cierre narrativo breve; no tareas diarias ni recompensas por entrar a una hora.
- Sin backend, cuentas, anuncios, pagos, gacha, clanes, multijugador ni tablas competitivas.

### Bucle de sesión

Elegir encuentro disponible → reconocer amenaza → atacar/protegerse/usar carga → cobrar victoria única → decidir mejora o configuración → cumplir un hito y restaurar el escenario → guardar → salir sin perder progreso.

Objetivo de diseño, pendiente de medir: entender y realizar una acción significativa en el primer minuto; una primera victoria y una mejora tempranas; una ruta con variedad real sin exigir varias sesiones para descubrir el jefe. La duración final se fija con pruebas, no con una promesa de horas de contenido.

## Sistemas propuestos y reglas de referencia

### A. Persistencia y control de sesión — prioridad inmediata

Conservar el ID T-002. Dominio serializable con `schemaVersion`, `contentVersion` y revisión monotónica del guardado; snapshots de estado completo. Persistir oro, mejoras, resistencia enemiga, progreso, carga, pausa manual y preferencia de automático. Reiniciar intervalos transitorios al restaurar, sin convertir ausencia en golpes.

Adaptadores Sembast/archivo en móvil y Sembast Web/IndexedDB, con imports condicionales. Seleccionar almacenamiento en el arranque, no desde el dominio. Primera apertura sin dato permite partida nueva; dato inválido o versión futura no.

Guardar current y backup validado en una transacción, con cola de escrituras serializada. Guardar acciones relevantes y checkpoint periódico limitado; no prometer que un cierre forzado puede salvar lo que el sistema no alcanzó a escribir. Mostrar estado de escritura/error y conservar original. Migrar en memoria, validar y solo entonces escribir.

Frontera de entrega: T-002 incluye recuperación mínima dentro de la app: bloquear sobrescritura de datos ilegibles/futuros, conservarlos en cuarentena y ofrecer restaurar un backup válido mediante confirmación. Si no hay copia válida, mostrar error conservando datos, sin iniciar otra partida silenciosamente. T-004 añade exportación/importación de archivos y exportación de la cuarentena. El menú completo y nueva partida confirmada pertenecen a T-023; hasta entonces no ofrecer reset destructivo.

Política de copias: cada escritura normal valida primero el current existente; si es válido, pasa a backup en la misma transacción que instala el nuevo current. Si current no existe, la primera escritura no inventa un backup. Si current es inválido/futuro, se bloquean escrituras normales y nunca se rota esa entrada encima del backup válido. Si current es válido y backup no, conservar la copia inválida en cuarentena y permitir continuar desde current. Restaurar backup requiere confirmar el posible retroceso; preservar current en cuarentena, instalar la copia validada con revisión nueva y conservar el backup hasta la siguiente escritura válida. No sustituir una copia recuperable con un dato inválido.

En web: una sesión escritora por partida mediante propietario/revisión y expiración acotada. Una segunda pestaña se vuelve solo lectura e informa qué ocurre; no sobrescribir progreso obsoleto. Transacciones idempotentes: no entregar recompensa/haptic dentro de callback que pueda repetirse.[9]

Cada escritura comprueba dentro de la transacción propietario, generación de concesión y revisión esperada; cualquier snapshot encolado con generación antigua se rechaza aunque su pestaña recupere actividad. Heartbeat propuesto cada cinco segundos y expiración a treinta segundos sin renovación. La expiración solo permite solicitar una concesión nueva, no guardar estado viejo: releer current, validarlo, descartar cola anterior y adoptar ese estado antes de habilitar input. Ante salto de reloj o conflicto, pasar a solo lectura y renovar explícitamente; un token de generación evita que dos propietarios escriban aunque el reloj expire prematuramente. Los tiempos son elección técnica revisable en pruebas, no garantía de ejecución en background.

Temporizadores por tipo: T-002 reinicia solo intervalos de entrada y fracción del pulso automático del prototipo; no produce ataques ausentes. Al añadir combate mutuo, T-008/T-009 persisten los milisegundos activos restantes de intención enemiga, cooldown y protección, junto con fase y dueño del encuentro. Reabrir continúa esos valores sin avance offline ni recuperación gratuita. No persistir timestamps monotónicos del proceso; serializar duraciones restantes acotadas y normalizar una única vez al guardar.

Exportar un archivo versionado; importar con límite de tamaño propuesto de 1 MiB, validación estructural y previsualización. Respaldar antes de reemplazar. Esto no es nube, cifrado antitrampas ni sincronización entre dispositivos.

### B. Combate con decisión

Esta ampliación cambia el límite inicial de héroe invulnerable; está propuesta, no implementada.

- Vida inicial propuesta 20; el enemigo solo golpea durante un encuentro activo. Pausa, segundo plano y menús no deben infligir daño oculto.
- Ataque base y llamarada permanecen. La carga pertenece al jugador y no la consume el automático.
- Acción Proteger: ventana propuesta de un segundo y recarga de tres segundos activos; reduce el siguiente golpe anunciado en 75%. No acumula cargas ni exige precisión de milisegundos. Alternativa accesible amplía la ventana sin penalización económica.
- Antes de un ataque enemigo, icono, texto y señal visual anuncian intención. No depender de sonido ni color.
- Derrota: detener encuentro, conservar oro/mejoras e hitos, ofrecer reintento a vida completa o volver al farol. Reiniciar solo el enemigo del encuentro; sin pérdida de recursos, energía de pago o espera obligatoria.
- Cambiar de Combate a otro menú suspende el encuentro; volver continúa sin saltos de reloj. Pausa manual tiene precedencia y no se desactiva al cerrar un menú. No atacar tocando el fondo desde Mecha/Ruta.
- Estados de encuentro introducidos en T-008: preparación, activo, suspendido y resultado. Abrir una tab solo suspende: no convierte una pelea en preparación ni habilita equipamiento. Desde preparación se pueden cambiar módulos; victoria/derrota conduce a resultado y una acción explícita lleva al farol/preparación. Abandonar requiere confirmación, no otorga recompensa, conserva oro/hitos y reinicia solo el enemigo y vida del encuentro. T-013 añade la selección visual de ruta sobre este contrato; T-012 lo reutiliza, por lo que no necesita esperar al mapa para ofrecer un lugar donde equipar.
- Entrada opcional de mantener pulsado repite ataques a cadencia limitada, se cancela con pointer cancel, cambio de tab, pausa y pérdida de actividad. Teclado y lector de pantalla mantienen botones equivalentes. Nunca recompensar en función del framerate.

### C. Enemigos y jefe

- Mota: referencia sencilla para aprender ataque y carga.
- Acorazado: protege durante una fase anunciada y deja una ventana de vulnerabilidad; no mera multiplicación de HP.
- Acechador: ataque anunciado más fuerte; favorece Proteger, no pulsar más rápido.
- Guardián del Umbral: dos fases compuestas a partir de estas conductas, no motor de jefe separado; primer cierre de ruta requiere derrotarlo.

Nombres y arte pendientes de revisión creativa. Configuración por datos Dart con IDs estables y tests de referencias; sin editor, carga remota ni sistema de mods. Valores iniciales en tabla de balance antes de implementar el catálogo, ajustables tras simulación.

### D. Progresión y configuraciones

Conservar compras de mecha y migrar progreso existente. Añadir XP/nivel solo si tiene recompensa clara: pequeño aumento de vida base y desbloqueo de módulos, no otro árbol. No debilitar a quien ya completó un tramo.

Cuatro módulos propuestos: Brasa (más daño base), Cristal (más fuerza de llamarada), Guarda (mejor protección) y Pabilo (carga más fácil). Dos ranuras, sin duplicados. Comparar antes/después y permitir cambiar gratis fuera del encuentro. No vender módulos; el oro sigue destinado a mejoras. Probar que dos configuraciones distintas son viables y ninguna es la mejor en todos los encuentros.

No añadir economía infinita. Poner límites documentados a mejoras, nivel, oro y resultados acumulados; evitar overflow y ticks de recuperación ilimitados. Al alcanzar todo, explicar que es contenido terminado, no fingir otro desbloqueo.

### E. Ruta, restauración y propósito

Tres sectores conectados con encuentros visibles y bloqueos explicados. Elegir encuentro ya desbloqueado para practicar o reunir oro; no mapa navegable ni pathfinding. No reiniciar sectores restaurados al repetirlos.

Encargos finitos: disipar una primera criatura, usar una llamarada y restaurar la ruta. Recompensas y registro de cobro se guardan juntos; reabrir, repetir transacción o importar el mismo estado no vuelve a conceder un cobro ya presente en ese estado. Sin cobros ocultos al navegar tabs. Importar/restaurar una copia antigua reemplaza toda la partida, incluidos oro y cobros: es un rollback explícito con previsualización, no una fusión. Un encargo pendiente en esa copia podrá cobrarse de nuevo dentro de esa línea de progreso, pero no sumarse al saldo posterior descartado. Sin servidor no se promete impedir manipulación ni retrocesos elegidos por el usuario.

Tras el jefe: escena restaurada, breve texto de cierre y resumen de hitos; continuar practicando o volver a la ruta. Nueva partida solo desde ajustes con confirmación y respaldo. El final tiene su propia prueba end-to-end.

### F. Presentación, acceso y aprendizaje

Mantener escena completa y tabs inferiores; añadir solo los controles/superficies necesarios. Vida real del héroe se mostrará cuando exista daño entrante, sin confundirla con carga. Identificar enemigo e intención sobre él, feedback breve de daño/cobro, animaciones acotadas y reducción de movimiento.

Ajustes accesibles desde cabecera o Ruta: audio, vibración opt-in, reducción de movimiento, controles sin pulsación repetida y tamaño legible. No obligar a tutorial: guía contextual repetible que muestre atacar, cargar, protegerse, mejorar y guardar; progreso tutorial persistido por separado de recompensas.

Arte propio o con licencia comprobada por archivo, hoja de estilo y avisos. Audio opcional de ataque, impacto, recompensa y farol; nunca necesario para entender una amenaza. No comprar assets ni generar audio con servicios de pago sin permiso.

### G. Calidad y entrega

Formato, análisis, pruebas de dominio, widgets e integración por entrega; builds web y Android. Fixture de reloj inyectado y RNG inyectable si finalmente se utiliza azar (la propuesta evita loot aleatorio).

Pruebas de partida nueva → mejora → encuentro → derrota/reintento → jefe → cierre → reinicio/carga. Probar corrupción, migraciones, versiones futuras, error de disco/cuota, dos tabs, pointer cancel, toque rápido, input retenido, pausas y cambios de reloj.

Matriz móvil: pantalla estrecha, texto al 200%, insets, cambio de orientación y suspensión; probar acciones con teclado/lector cuando existan las herramientas. Capturas no prueban rendimiento ni tacto físico.

Objetivos de laboratorio propuestos, no mediciones: sesión perfilada de diez minutos sin crecimiento continuo de memoria y fluidez estable al objetivo de 60 FPS en el dispositivo de referencia que se registre; aceptar 30 FPS como modo de ahorro si se decide e identifica. Medir con build profile, no inferir FPS de un debug test. Registrar memoria, frames lentos, calentamiento y suspensión; no inventar límites absolutos de RAM sin equipo de referencia.

Android local es la primera plataforma a calificar. iOS tiene tarea propia con requisito macOS/Xcode y dispositivo; no bloquea la versión Android. Store/firmas/privacidad tienen checklist separado y requieren autoridad para cuentas, claves, pagos y publicación. No ejecutar esos trámites por crear el TODO.

El menú inicial, el final y el reset seguro de T-023 se integran antes de la regresión integral T-021 y del balance de cierre T-020. La calificación Android T-022 corresponde al conjunto resultante, no a una versión anterior sin esos flujos. Cualquier corrección posterior que afecte guardado, navegación o combate invalida y obliga a repetir las comprobaciones afectadas antes de empaquetar.

## Alternativas y control de alcance

Rechazados para esta versión: colección de héroes y gacha (arte y economía excesivos); mundo abierto (mapas y navegación); inventario aleatorio/crafting complejo (demasiadas pantallas); mazmorras procedurales (dificultan balance antes de tener combate variado). La opción elegida reutiliza el escenario y añade conductas, decisiones y cierre.

Offline solo como evaluación posterior propuesta: primero validar si aporta algo a quien pidió jugar activamente. Si se aprueba, descanso en faroles con beneficio limitado, sin victorias ni jefes automáticos, reloj de pared inyectado y pruebas de doble cobro/saltos. No forma parte de la definición de primera versión ampliada.

## Criterios de juego terminado

1. Se entiende la meta y se puede terminar la ruta y el jefe sin pagar ni crear cuenta.
2. Existen decisiones de protección/habilidad/configuración, no solo repetir ataques.
3. Las tres variantes exigen al menos dos respuestas distintas observables; el balance se prueba jugando, no contando enemigos.
4. Guardado, importación y migración conservan datos y errores no borran partidas.
5. Vida, carga, recompensa, derrota y cierre son legibles y no se duplican al reanudar.
6. Controles de combate accesibles sin velocidad de tapping; tabs y texto ampliado siguen utilizables.
7. Audio y vibración opcionales, licencias registradas, sin assets comerciales copiados.
8. Gates automatizados y recorrido real Android pasan; incidencias críticas de pérdida de datos/bloqueo resueltas.
9. La prueba con jugadores demuestra que comprenden dos decisiones y alcanzan un hito sin intervención; esto es criterio propuesto a medir, no evidencia existente.
10. Documentación refleja capacidades reales y limita plataformas/condiciones no probadas.

## Orden, permisos y siguientes pasos

Toda tarea vive en `../TODO.md`; este documento es la especificación, no un segundo backlog. T-001/T-003 siguen terminadas en el archivo histórico. T-002 conserva identidad y prioridad. El resto se propone por fases y queda fuera de ejecución hasta aprobar la ampliación: guardado → control de sesión/accesibilidad → núcleo de combate → variedad y progresión → contenido/final → pulido y balance → calificación física → publicación opcional.

La petición actual no autoriza implementar la ampliación ni modificar código, instalar paquetes, lanzar workers, crear cron, hacer commits o publicar. No se promete fecha de entrega sin medir el primer lote. El próximo resultado técnico recomendado sigue siendo T-002: cerrar y reabrir sin perder partida.

## Sources

[1] https://developer.apple.com/design/human-interface-guidelines/tab-bars
[2] https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/103
[5] https://www.gamedeveloper.com/business/from-a-prototype-to-one-of-the-biggest-idle-games-in-3-years-postmortem
[6] https://www.gamedeveloper.com/design/crafting-meaningful-choices
[7] https://developer.android.com/quality/core-value
[8] https://pub.dev/packages/sembast
[9] https://pub.dev/packages/sembast_web
[10] https://pub.dev/packages/shared_preferences
[11] https://developer.mozilla.org/en-US/docs/Web/API/Storage_API/Storage_quotas_and_eviction_criteria
[12] https://gameaccessibilityguidelines.com/avoid-repeated-inputs-button-mashing-quick-time-events
