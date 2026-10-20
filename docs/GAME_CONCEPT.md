# Farol de Ceniza — concepto propuesto

Status: Accepted

Estado documental: la actualización interactiva y el HUD RPG describen el prototipo actual. El texto inicial conservado más abajo es histórico, no una afirmación de que la escena siga vacía ni de que falte aprobar el inicio ya autorizado. [Roadmap ampliado](GAME_ROADMAP.md) contiene nuevas propuestas para revisión; [TODO](../TODO.md) es la única cola de trabajo. No modifica por sí mismo el alcance aceptado.

## Actualización vigente: interacción del jugador

El usuario aprobó comenzar y luego pidió personajes e interacción, no un juego que se juegue solo. Esta corrección sustituye las reglas automáticas iniciales del documento; el resto del alcance pequeño se conserva. Nombre provisional.

- Inicio en modo manual: atacar mediante botón o toque en la escena. Cadencia máxima manual: un ataque cada 350 ms.
- Cada ataque manual aceptado carga un punto de llamarada, hasta cuatro. El jugador la libera con otro botón para causar triple daño y consumir la carga; no se dispara sola.
- Automático optativo: un ataque por segundo, sin cargar la llamarada. Se puede volver a manual sin recuperar tiempo pendiente.
- Ataques y llamarada no funcionan con pausa o app inactiva. Se conservan oro, mejoras, tres tramos y ausencia de progreso offline.
- Arte vectorial original del guardafaroles y criatura de hollín, generado directamente con Canvas en `lib/presentation/characters.dart`.
- Implementado: combate manual/automático optativo, habilidad, economía, ruta, pausa y personajes. Pendiente: guardado versionado, recuperación y pruebas físicas. Recargar reinicia.

El texto siguiente conserva el planteamiento inicial y sus hipótesis; donde contradiga esta actualización, prevalece esta sección.

Nombre de trabajo, no marca verificada. Documento de diseño, no funcionalidad implementada ni aprobación para ejecutar desarrollo autónomo.

## Encargo y evidencia local

El usuario pide un concepto original y alcanzable, aplicable al proyecto y consistente con el estilo conversado. Flutter + Flame + Dart y el enfoque idle móvil son el punto de partida acordado. Fantasía, héroe y mazmorras fueron una propuesta previa, no una temática elegida expresamente: aquí se desarrollan como propuesta creativa revisable.

La inspección de `lib/main.dart`, `pubspec.yaml` y `README.md` muestra una pantalla Flutter con una escena Flame vacía. No hay combate, economía, guardado ni progreso offline. Flame está declarado como dependencia. Este documento no cambia ese estado.

Tamaño: concepto de un proyecto pequeño, con un primer prototipo acotado. Todos los nombres, cifras, reglas y opciones visuales que siguen son decisiones propuestas del diseñador; no requisitos previamente aceptados por el usuario. Los objetivos temporales son hipótesis de diseño, no resultados medidos.

## Premisa

Eres el último guardafaroles de una comarca cubierta por una ceniza que apaga los caminos. Viajas a pie por una antigua galería, acompañado únicamente por tu farol. Las criaturas de hollín no custodian tesoros: se alimentan de la luz que antes conectaba los pueblos.

Tu tarea no es conquistar un reino, sino volver a encender una ruta. Cada tramo restaurado deja una señal visible de tu avance: un farol se prende, aparece un detalle del paisaje y la oscuridad retrocede.

Pitch: un idle de fantasía cálida en el que un pequeño guardián pelea solo y tú conviertes sus recompensas en una luz cada vez más fuerte.

## Identidad y originalidad propuesta

- Fantasía de oficio: guardafaroles en lugar de rey, elegido o comandante de un ejército.
- El arma es una pértiga con farol; el ataque es un pulso de luz, no una colección de armas.
- El avance restaura el mismo escenario, en vez de exigir producir mapas continuamente.
- El contraste emocional es ceniza fría frente a luz cálida; no terror ni violencia explícita.
- La primera meta es una ruta terminada, no una lista interminable de tareas.

La originalidad se busca en esta combinación y en su ejecución. No se afirma que nadie haya utilizado antes faroles, ceniza, restauración o combate idle. No copiar nombres, personajes, UI, datos, arte, audio ni assets de Path of Kings, Melvor u otras referencias. El nombre requiere búsqueda de marca antes de comercializar.

## Bucle principal

1. El guardián pulsa su farol automáticamente contra una criatura.
2. La resistencia de la criatura baja con cada pulso.
3. Al disiparla, recibes oro y avanza la restauración del tramo actual.
4. Gastas oro en reforzar la mecha: la siguiente criatura se disipa más rápido.
5. Tras suficientes victorias, un farol del camino se enciende y se abre el siguiente tramo.
6. Al completar la galería, aparece un cierre breve. Puedes seguir reuniendo oro sin contenido nuevo prometido.

No se exige tocar repetidamente para atacar. El jugador decide cuándo mejorar y ve inmediatamente su efecto.

## Primer prototipo jugable: contrato propuesto

### Contenido cerrado

- Un héroe: el guardafaroles, sin selección de clase ni personalización.
- Un enemigo: una mota de hollín; se reutiliza con distinta resistencia.
- Un escenario: la Galería Apagada, una composición lateral fija.
- Una moneda: oro, sin monedas premium.
- Una mejora: mecha del farol, que aumenta el daño del pulso.
- Una ruta con tres tramos, representados por tres faroles del escenario; no son tres mapas.
- Guardado local versionado.

### Reglas iniciales para implementar y luego ajustar

- Un pulso por segundo de simulación; daño inicial de 1.
- La resistencia del enemigo es 4 en el primer tramo, 6 en el segundo y 8 en el tercero.
- Cada victoria otorga 2 de oro. El héroe empieza sin oro.
- Cada tramo requiere 5 victorias. El contador de tramo se reinicia al avanzar.
- La mejora cuesta 6 de oro inicialmente; cada compra aumenta el daño en 1 y el siguiente precio en 4 de oro.
- Máximo de 5 compras de mejora en este prototipo. Mostrar «Mecha al máximo» al alcanzarlo.
- El daño sobrante de un pulso no alcanza al enemigo siguiente. La aparición del nuevo enemigo es inmediata.
- Al cerrar un tramo, su farol queda encendido. Al cerrar el tercero se muestra «La ruta vuelve a brillar» una sola vez; luego se mantiene el último tramo como combate repetible, sin nuevos hitos.
- No hay daño al héroe, muerte, derrota ni penalizaciones en esta versión. El pulso disipa criaturas y ellas bloquean el camino. El combate mutuo queda fuera para no añadir recuperación y balance de supervivencia al primer ciclo.
- Un botón permite pausar y reanudar. Pausa detiene pulsos, recompensas y avance.
- En esta versión no hay ganancias al cerrar o dejar la app en segundo plano. Al volver, se retoma el estado guardado, sin recuperar tiempo ausente.
- Partidas nuevas reinician el intervalo de ataque; la fracción de segundo de un pulso en curso no se persiste. La resistencia actual sí se guarda.

Estas cifras no han sido validadas jugando. Antes de ampliar contenido se comprueba si comprar una mejora resulta claro y satisfactorio, y si completar la ruta se siente breve pero significativo. Ajustar constantes es válido; añadir sistemas para esconder un ciclo aburrido no lo es.

### Definición de terminado del prototipo

- Desde una partida nueva se ve el primer combate sin tutorial obligatorio.
- Una victoria suma el oro correcto una sola vez.
- Comprar descuenta el coste, aumenta el daño y actualiza el siguiente precio; no permite gastar sin saldo.
- Un farol se enciende únicamente al completar su tramo; el cierre de ruta no se duplica al recargar.
- La pausa no genera progreso, aunque se deje abierta la ventana.
- Recargar conserva oro, daño, compras, resistencia, tramo, victorias, faroles y cierre; también conserva pausa explícita del jugador.
- El ciclo puede completarse sin pagar, registrarse, ver anuncios ni pulsar repetidamente.
- Se puede recorrer la interfaz en un ancho móvil estrecho sin desbordamientos y con texto ampliado.

## Dirección visual y táctil

Propuesta, todavía sin arte aprobado:

- Vista vertical móvil. Escena lateral en la parte superior y controles debajo.
- Siluetas 2D sencillas con bordes definidos; ilustración estilizada de baja complejidad, no pixel art detallado obligatorio.
- Fondo azul pizarra, piedra gris, hollín violeta apagado y luz ámbar. El brillo no sustituye al contraste del texto.
- Guardián pequeño con capa corta y farol grande; enemigo como nube compacta con ojos. Se puede prototipar con geometría propia.
- Animaciones limitadas: reposo, pulso, impacto y disipación. Un destello suave al comprar y un cambio persistente al encender un farol.
- Sin cámara móvil, mapas navegables ni físicas necesarias.
- Oro y progreso textual siempre visibles: «Tramo 1 de 3» y «Victorias 2 de 5», por ejemplo.
- Botón principal «Reforzar mecha», con coste y daño actual/siguiente. Si no alcanza el oro, indicar cuánto falta.
- Botones de al menos 48 píxeles lógicos, etiquetas semánticas y sin depender solo de color.
- Respetar reducción de movimiento. No usar flashes rápidos. La vibración será opcional, breve y solo para compra/hito en plataformas compatibles.
- Sonido no obligatorio para comprender ni completar el juego; producción de audio fuera del primer prototipo.

## Una sesión imaginada

Abres la galería. El farol del guardián pulsa solo y la primera mota se disipa. El oro aumenta y ves cuánto falta para reforzar la mecha. Compras la mejora; los siguientes enemigos resisten menos pulsos. Cuando se enciende el primer farol del camino, aparecen piedras y raíces que antes no se distinguían. La pantalla conserva su estructura, pero el lugar empieza a sentirse recuperado.

Este ejemplo describe la experiencia deseada, no una demostración existente.

## Arquitectura mínima y conservación de datos

- Dart puro: estado, reglas de combate, compra e hitos, sin importar Flutter ni Flame.
- Flutter: HUD, botones, confirmaciones y estados de carga/recuperación.
- Flame: renderizado y animación a partir del estado; no decide recompensas.
- Reloj monotónico inyectable para simulación activa y pruebas. Segundo plano y pausa no acumulan tiempo pendiente. Un retraso prolongado de renderizado se limita de forma explícita para evitar recuperación ilimitada; el límite y las transiciones se prueban antes de implementar.
- Guardar tras compra, victoria e hito; persistir estado consistente, no eventos que puedan cobrarse dos veces. No escribir a disco por frame.
- Guardado con versión de esquema, validación, copia recuperable y migraciones. Si el archivo está corrupto o tiene versión futura, conservarlo y ofrecer recuperación; nunca sustituirlo silenciosamente por una partida vacía.
- Elegir almacenamiento compatible con Android y web al implementar; no se añade dependencia por este documento.
- La economía local puede manipularse. No se ofrece seguridad competitiva.

## Fuera del primer prototipo

Progreso offline, jefes, inventario, equipo aleatorio, habilidades, clases, misiones diarias, prestigio, múltiples mapas, narrativa extensa y personalización. También quedan fuera backend, cuentas, anuncios, compras, gacha, clanes y multijugador.

Una posible ampliación, solo tras validar y aprobar el prototipo: un resumen de progreso offline limitado y un guardián de hollín al final de una nueva ruta. No está comprometida ni programada.

## Enfoques considerados

- Mazmorra RPG tradicional con equipo y jefe: reconocible, pero exige más contenido, balance e interfaz antes de validar el bucle. Se descarta para la primera entrega.
- Idle de construcción de un pueblo: encaja con restauración, pero multiplica edificios y economías. Se descarta para el prototipo.
- Guardafaroles con una ruta restaurable: elegido como propuesta porque permite dar identidad al juego reutilizando un escenario y un enemigo.

## Secuencia sugerida, sin ejecución autorizada

1. Combate vertical mínimo: lógica Dart determinista, héroe y enemigo geométricos en Flame, resistencia y oro en Flutter. Comprobar recompensa única y cadencia independiente del renderizado.
2. Mejora y restauración: implementar compra, límites, tres tramos y cierre; probar saldo insuficiente, daño sobrante y transiciones sin recompensas dobles.
3. Continuidad: guardado, recuperación, pausa y ciclo de vida. Probar reinicio, corrupción, versión futura, segundo plano y cambios de reloj sin otorgar oro ausente.
4. Validación: recorrer la ruta, ajustar economía y accesibilidad; verificar web y build Android. Pruebas físicas pendientes hasta disponer de dispositivo. iOS requiere macOS y Xcode.

Verificación técnica propuesta para esas futuras entregas: `dart format --output=none --set-exit-if-changed lib test`, `flutter analyze`, `flutter test`, `flutter build web` y `flutter build apk --debug`. Las pruebas de nuevas mecánicas todavía no existen; estos comandos no certifican este concepto ni su diversión.

## Decisión pendiente

Validar con el usuario la identidad de guardafaroles, el nombre provisional y el alcance antes de convertir esta propuesta en backlog de implementación. No hay tareas ejecutables, workers, cron ni autorización de desarrollo derivados de este documento. El siguiente paso recomendado, si se aprueba, es el combate vertical mínimo, no ampliar el diseño.
