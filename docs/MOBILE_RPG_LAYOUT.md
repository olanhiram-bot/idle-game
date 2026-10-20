# Distribución móvil RPG

## Investigación y decisión

No hay una distribución universalmente mejor para todos los RPG. Esta implementación elige una composición para nuestro combate lateral, móvil y de un solo héroe; no afirma mejoras de retención ni ergonomía medidas.

Apple recomienda usar tabs para navegar entre secciones, no para ejecutar acciones, mantenerlas visibles e incluir etiquetas.[1] Por eso Combate, Mecha y Ruta cambian el panel inferior; Atacar y Llamarada son botones dentro de Combate, no tabs que disparan ataques.

Game-Ace recomienda ubicar las acciones frecuentes en la zona inferior accesible al pulgar, respetar insets reales y mantener blancos táctiles de 44 pt en iOS o 48 dp en Android.[3] Aplicamos controles de al menos 48 unidades lógicas y SafeArea al HUD y al panel, sin restringir el fondo del juego.

La guía de HUD consultada recomienda agrupar información relacionada, anclar con áreas seguras, conservar contraste propio y evitar que la interfaz tape la acción.[4] Colocamos vida del enemigo y carga del farol sobre sus respectivos personajes, con texto y número; recursos y pausa arriba. La posición sobre personajes es una decisión propia para este combate, no una regla universal de RPG.

Microsoft recomienda que la información esencial no dependa solo del color y acompañar estados con texto, formas u otros indicadores.[2] Las barras incluyen nombre y cifra, las tabs icono y etiqueta, y la habilidad su carga o estado lista.

## Contrato implementado

- Flame ocupa todo el viewport como fondo, sin tarjeta, márgenes de página ni scroll de la escena.
- Escala uniforme de personajes, sin deformarlos según el aspect ratio.
- Cabecera compacta: título, tramo, oro, pausa; el combate sigue visible al cambiar tab.
- Panel inferior persistente: Combate, Mecha, Ruta. Solo el contenido del panel puede desplazarse si hay texto ampliado o pantalla baja.
- Botones de ataque y habilidad visibles al abrir Combate en móvil normal. Con texto ampliado se adaptan en columna cuando hace falta.
- Barra roja: vida/resistencia real del enemigo. Barra ámbar: carga real de habilidad del héroe. No se inventa vida del héroe: todavía no recibe daño. Añadir supervivencia requiere diseñar y probar combate mutuo, no dibujar una barra de vida ficticia.
- Se preservan compra, daño, recompensas, pausa, suspensión y automático optativo. No se agregan inventario, cuentas ni nuevas economías.
- Verificación: widgets en 390x844, 320x740 a 200%, 844x390 a 200%, insets inferior/superior, transiciones de tabs, habilidad, compra, pausa y ciclo de vida. Compilaciones web/Android; render navegador de escritorio y móvil. Prueba física y rendimiento no medidos.

## Sources

[1] https://developer.apple.com/design/human-interface-guidelines/tab-bars
[2] https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/103
[3] https://game-ace.com/blog/mobile-game-design
[4] https://gamedesign.gg/articles/hud-design-principles
