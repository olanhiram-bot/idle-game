# Balance inicial de campaña

Valores implementados en `lib/domain/content.dart`; son punto de partida, no balance validado con jugadores.

| ID | Vida | Daño | Periodo activo | Conducta |
|---|---:|---:|---:|---|
| mota | 8 | 4 | 3500 ms | Golpe anunciado |
| acorazado | 16 | 5 | 4500 ms | Reduce daño base a mitad redondeada arriba cuando faltan más de 1400 ms para golpear |
| acechador | 20 | 8 | 3000 ms | Golpe más fuerte anunciado |
| umbral | 48 | 8 | 4000 ms | A media vida, periodo 2500 ms y daño +2 |

Cada victoria: 2 oro y 2 XP. Cinco victorias por sector encienden un farol; jefe desbloqueado con tres sectores completados. Nivel = min(5, 1 + XP ~/ 10); vida máxima = 20 + 4 por nivel adicional.

Mecha: cinco compras, coste 6 + 4 por compra previa, +1 daño. Brasa añade 1 daño, Cristal cambia llamarada de ×3 a ×4, Guarda elimina daño protegido, Pabilo baja requisito de carga a tres. Dos ranuras sin duplicados; cambios fuera de pelea. Proteger tiene ventana 1000 ms (1800 con ayuda), cooldown 3000 ms y reduce 75%, redondeando daño recibido hacia arriba; se consume al bloquear.

Prueba ejecutada: `flutter test test/balance_test.dart` recorre todos los sectores y jefe con tiempo activo, mejoras y protección. Es una estrategia automatizada, no playtest humano ni prueba de que dos builds estén igualmente equilibradas.
