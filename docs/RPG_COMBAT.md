# Combate y personajes jugables

Tres personajes gratuitos, un héroe activo por encuentro (no un equipo simultáneo): Luz, guardafaroles equilibrada (20 vida/1 daño); Bastión, centinela de espada y escudo (28/1); Ascua, invocadora ofensiva (16/2). Selección en Mecha fuera del combate, sin compras ni gacha. Nivel y mejoras son compartidos; cambiar personaje reinicia carga y recupera su vida fuera del encuentro.

Atacar aplica daño real con intervalo de 350 ms; mantener repite. Cada ataque manual carga Llamarada; esta consume carga e ignora coraza. Proteger tiene ventana y cooldown; el enemigo anuncia ataque, inflige daño y puede derrotarte. Oro, XP, niveles, módulos y sectores siguen el sistema existente. No se añadieron probabilidades aleatorias ni estadísticas ficticias.

La escena muestra desplazamiento de ataque, arco/proyectil, números del daño aplicado, reacción y ataque enemigo. El golpe final conserva su animación tras la victoria. Los personajes tienen ilustraciones originales distintas. Reducir movimiento suprime desplazamientos/efectos, el resultado permanece en el panel de texto.

Guardado schemaVersion 2 conserva héroe. Versiones 1 migran en memoria al personaje Luz sin borrar progreso; versiones futuras/personajes inválidos se rechazan. La próxima escritura conserva respaldo según el repositorio existente.

Verificación: pruebas de dominio de selección/estadísticas/migración, feedback/animación final y bloqueo; widget selecciona Ascua, comienza y comprueba 2 puntos de daño. No implica balance humano validado ni prueba física.

## Progresión y academia

Combate RPG en tiempo real con comandos, no turnos estrictos: ataque básico, defensa, habilidad cargada y reserva limitada de maná. Cada encuentro comienza con 6 PM; habilidades compradas consumen 2 PM y comparten recuperación de 1 segundo de tiempo activo. Sin regeneración offline.

En Mecha se aprende y mejora hasta rango 3: Golpe poderoso (6/12/18 oro, daño base +3 por rango e ignora coraza), Curación (8/16/24 oro, +6 vida por rango sin superar máximo), Sello de hielo (10/20/30 oro, retrasa siguiente golpe 1 segundo por rango, restante máximo 5 segundos). Compras permanentes compartidas entre héroes, solo fuera de pelea. Falta oro/rango máximo/habilidad no aprendida/maná insuficiente no consume recursos.

Ruta permite seleccionar cualquier enemigo desbloqueado sin iniciar pelea oculta: volver a Combate y comenzar. Mantiene desbloqueo de sectores por cinco victorias. Cada victoria global eleva siguiente rango: +2 vida y +1 daño cada ocho rangos, hasta rango 100 (101 dificultades). Daño base recibido = mitad del catálogo redondeada arriba (Mota: 2 en vez de 4), para un inicio menos punitivo. El rango queda fijado al comenzar: victoria no cambia el máximo del enemigo recién vencido, derrota/reintento/abandono no elevan rango. Cambiar a enemigos anteriores no reinicia dificultad. Es una progresión acotada, no crecimiento infinito ni promesa de balance indefinido.

Campos aditivos del guardado v2: rango fijado, rangos de habilidades, maná y recuperación restante. Guardados sin estos campos conservan combate previo a rango 0 y academia vacía. Pruebas cubren compra/uso/recursos/migración y UI. Navegador real: victoria paga 2 oro, encargo paga 6, aprender Golpe cuesta 6 y deja 2; siguiente Mota sube de 8 a 10 vida, Golpe reduce a 6 y deja 4 PM.

## Inicio accesible y galería

### Vitalidad permanente

Mecha muestra Vitalidad antes de la academia: +5 vida máxima por compra para todos los héroes, diez compras, coste 4 + 4 por compra previa. La primera cuesta dos victorias normales; compite con daño y habilidades como uso del oro. Solo fuera de combate, informa antes/después y saldo faltante. Comprar recupera vida al nuevo máximo; no cambia dificultad ni da oro. Selector, HUD, curación y siguiente encuentro usan el mismo máximo: vida base +4 por nivel adicional +5 por Vitalidad. Campo aditivo `vitality` (0..10) en snapshot v2; ausencia en guardados previos equivale a cero, datos inválidos se rechazan sin borrar. Pruebas verifican victoria→oro→compra→guardado→siguiente pelea, falta de saldo, límite y cambio de héroe.

Cada encuentro restaura vida y PM. Volver al farol también recupera vida/PM y limpia recuperación; no entrega oro ni cambia dificultad. La vida base sigue diferenciando héroes; el ajuste es la relación daño/resistencia, no igualar visualmente barras o dar invulnerabilidad. Test determinista: los tres héroes completan cinco Mota iniciales atacando una vez por segundo y usando Llamarada, sin compras ni protección, con más de media vida restante. No prueba todos los rangos ni sustituye playtest.

Mecha → Elegir personaje abre una pantalla independiente: retrato grande, miniaturas, rol, estadísticas actuales, previsualización y botón explícito Jugar con nombre. Atrás cancela sin cambiar. Restricción en combate conservada. Bastión/Ascua tienen capas, ornamentos, armadura, reflejos y rasgos faciales adicionales en el mismo renderer de combate.
