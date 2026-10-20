# Estado de entrega de la ampliación

## Implementado y ejercitado

- Snapshot validado, guardado transaccional local, backup, recuperación y exclusión por propietario/revisión.
- Adaptadores móvil y web; migración de progreso previo a campaña; identidad web por pestaña para recargar.
- Catálogo de Mota, Acorazado, Acechador y Guardián; vida entrante, intención, protección, derrota/reintento y dos fases del jefe.
- XP/nivel, módulos con dos ranuras, ruta seleccionable y tres encargos de cobro único.
- Menú inicial, continuidad, final, nueva partida confirmada con respaldo, ajustes y ayuda de juego.
- Mantener ataque, pausa al cambiar tab y cancelación de repetición; arte diferenciado y efectos sonoros locales opcionales.
- Exportación/importación con previsualización y validación; requiere ampliar verificación de selectores nativos y errores.

## Evidencia ejecutada

- `flutter analyze`: sin problemas.
- `flutter test`: 35 pruebas aprobadas en la última suite; incluye campaña, balance de ruta completa con tiempo activo, guardado, migración, validación, corrupción/backup, propiedad, importación, ajustes y cancelación de ataque retenido.
- `flutter build web`, `flutter build apk --debug` y `flutter build apk --profile`: correctos.
- `flutter test integration_test -d web-server`: NO compatible con ese runner; no se contabiliza como aprobado.
- Alternativa ejecutada: `CHROME_EXECUTABLE=/usr/sbin/chromium flutter drive --driver=test_driver/integration_test.dart --target=integration_test/playthrough_test.dart -d web-server --browser-name=chrome --headless --web-port=8181`: All tests passed.
- Navegador real: ataque y habilidad, recompensa de 2 oro, recarga conservó oro/XP/estado de victoria. Menú y tabs ejercitados.

## No terminado / límites

- No se ha calificado Android físico ni rendimiento diez minutos: no hay dispositivo conectado. Build profile no sustituye esa prueba.
- No se ha compilado iOS: entorno Linux sin macOS/Xcode.
- No hay playtest humano: simulación no prueba diversión, comprensión ni retención.
- Publicación, firma de distribución, marca definitiva, ficha y privacidad requieren revisión y autorización separadas; no se ha publicado.
- Aún falta cerrar regresión exhaustiva de fallo de disco/cuota, importar/exportar en plataformas nativas y dos pestañas reales independientes. Pruebas de repositorio en memoria no bastan para calificar todo ello.
- Ayuda inicial omitible con preferencia persistida y texto accesible en ajustes; no es aún tutorial contextual por pasos. No se declara esa tarea terminada.
- Audio usa sonidos originales sintetizados; falta calificación auditiva en dispositivo y señal de fallo de audio.
- Geometría de escala/origen compartida en `arena_layout.dart`; posiciones de barras dependen de la misma transformación. Falta la matriz final de capturas de todas las variantes.
- La versión actual puede requerir esperar la expiración de la concesión tras cerrar abruptamente una pestaña. No borrar almacenamiento para solventarlo.

Este registro distingue avance de cierre: ninguna tarea se marca completa solo por haber añadido controles o por una compilación correcta.
