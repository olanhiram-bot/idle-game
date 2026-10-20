# Completed tasks


<!-- archived from TODO.md -->

Source section: Now

- [x] T-001 — Primer ciclo jugable de Farol de Ceniza
  Status: done
  Sources: docs/GAME_CONCEPT.md; autorización del usuario «ok empieza a trabajar».
  Scope: combate manual por defecto, automático optativo, llamarada cargada con ataques del jugador, oro, una mejora, tres faroles, pausa y suspensión; personajes vectoriales propios. Corrección expresa del usuario: interacción en vez de solo observar. Sin guardado en esta entrega.
  Acceptance: recompensa única; compra con saldo y límite; progreso de tres tramos; reloj inyectable, sin recuperación ilimitada ni ganancias en segundo plano; interfaz usable estrecha y con texto ampliado; ejecutar la versión web real.
  Checks: dart format --output=none --set-exit-if-changed lib test && flutter analyze && flutter test && flutter build web && flutter build apk --debug. Pruebas manuales del render web y de compra/pausa.
  Touches: lib/; test/; README.md; docs/GAME_CONCEPT.md; web/index.html; TODO.md.
  Evidence: formato y flutter analyze sin problemas; flutter test con 13 pruebas aprobadas; flutter build web y flutter build apk --debug correctos. Navegador real: cuatro ataques generan 2 oro y carga completa; llamarada reduce 4 a 1 la resistencia y consume carga; manual no progresa sin interacción; automático se activa explícitamente. Captura móvil revisada. Sin prueba física ni medición de rendimiento.
  Dependencies: None.
  Ownership: sesión interactiva actual de Hermes idle-game.


<!-- archived from TODO.md -->

Source section: Now

- [x] T-003 — Distribución RPG a pantalla completa
  Status: done
  Sources: petición del usuario de escena completa, barras contextuales y tabs inferiores; docs/MOBILE_RPG_LAYOUT.md.
  Scope: HUD, escala uniforme, navegación Combate/Mecha/Ruta, controles y zonas seguras. Sin cambiar economía ni añadir vida ficticia al héroe.
  Acceptance: escena llena viewport; barras sobre personajes; tabs visibles; interacción y progreso conservados; accesibilidad estrecha y horizontal con texto al 200%.
  Checks: dart format --output=none --set-exit-if-changed lib test && flutter analyze && flutter test && flutter build web && flutter build apk --debug.
  Evidence: todos los comandos aprobados, 14 pruebas. Navegador real: ataques, recompensa, llamarada, cambio de tres tabs conservando estado. Capturas revisadas en 390x844 y 1280x800; widgets adicionales 320x740 y 844x390 al 200% con insets. Citas del documento verificadas. Sin prueba física ni perfil de rendimiento.
  Touches: lib/main.dart; lib/presentation/; test/widget_test.dart; README.md; docs/MOBILE_RPG_LAYOUT.md; TODO.md.
  Dependencies: T-001.
  Ownership: sesión interactiva Hermes idle-game.
