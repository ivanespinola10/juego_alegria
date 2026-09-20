# El Mundo de Alegría 1.1.0 (build 8)

## Objetivo de esta versión
Actualización de calidad para mantener la experiencia de baja estimulación y hacer que el producto se sienta más terminado, claro y confiable.

## Cambios incluidos
- Corrección del pack Dino Bebés y sus rutas reales de assets.
- Limpieza de stickers rotos y duplicados.
- Selector de herramientas con estado activo claro.
- Borrador real para trazos, sin pintar de blanco sobre el dibujo base.
- Barra superior más limpia, con nombre del pack y contador de dibujo.
- Cambio de dibujo con precarga para reducir pantallas vacías.
- Confirmación antes de limpiar una obra.
- Compartir protegido como acción para adultos.
- Enlace de Google Play incluido en el texto de compartir.
- Libro Infinito convertido en la propuesta principal del menú.
- Paywall centrado en compra única, sin suscripción.
- Restauración de compras visible.
- Google Play Billing aislado de Web y validado por product ID.
- Preferencias de idioma y audio persistentes.
- Importación mediante selector del sistema, sin pedir permisos de almacenamiento innecesarios.
- Tarjetas de packs más limpias y con vista previa real.
- Versión preparada como 1.1.0+8.

## Antes de generar el AAB
1. Ejecutar `flutter pub get`.
2. Ejecutar `flutter analyze`.
3. Ejecutar `flutter test`.
4. Probar en Android real:
   - todos los packs;
   - pintura, pincel, marcador, borrador y stickers;
   - limpiar y cambiar dibujos;
   - compartir después de la compuerta de adulto;
   - compra del producto `libro_infinito`;
   - restauración de compra;
   - importar dibujos;
   - cierre/reapertura conservando idioma, audio y desbloqueo.
5. Verificar que el proyecto compile apuntando al nivel de API exigido por Google Play antes de subir el AAB.
6. Generar: `flutter build appbundle --release`.

## Posicionamiento
**El libro de colorear que nunca se termina.**

Sin anuncios. Sin suscripción. Compra única para desbloquear el Libro Infinito.
