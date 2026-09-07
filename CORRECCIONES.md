# Libro Infinito — rama de revisión, no publicar todavía

## Implementado

- Las 50 rutas de páginas del menú existen, incluido Dino Bebés.
- Silencio inicial, sonido e idioma persistentes; no se cambia el ID Android.
- Barrera adulta antes de importar, consultar el desbloqueo, compartir o borrar un pack. Es una barrera para niños pequeños, no verificación de edad/identidad ni autenticación bancaria.
- Una lámina propia gratuita por instalación; cancelar o rechazar un archivo no consume la prueba. Borrar el pack no restablece la prueba. La protección local no pretende resistir una reinstalación o manipulación.
- Se conserva `es_pro` para quien ya lo activó; no se concede automáticamente a todas las instalaciones ni se considera recibo de compra.
- Eliminado el falso botón de compra. El desbloqueo aparece como no disponible hasta integrar y configurar Google Play Billing. Esta rama NO monetiza aún.
- Importación secuencial de hasta 20 imágenes por lote, 20 MiB/archivo, 40 MP de entrada y 2048 px de salida. No limita el total de una biblioteca desbloqueada. Informa cuántas omite; permite reintentar otro lote.
- Decodificación y reexportación PNG con nombres internos únicos por pack; libera imagen, códec, descriptor y buffer. Las rutas originales no se utilizan como nombres de destino. Verificar EXIF en teléfonos reales.
- Lectura de directorios asíncrona y sin seguir enlaces; sin solicitudes amplias de permisos multimedia. Las dependencias antiguas se conservan en pubspec/lock para no introducir una actualización masiva sin validar.
- Confirmación al limpiar, cambiar de página o salir después de pintar. No es autoguardado: un cierre del proceso aún pierde el trabajo.
- Compartir está identificado como tal, protegido, sin reseña automática, con resolución acotada y liberación de memoria. No se afirma que la hoja de compartir haya guardado una copia.
- Un toque selecciona el color; pulsación larga mezcla. El borrador sigue pintando blanco: restaurar el fondo real queda pendiente.
- Tooltips de navegación y respeto a reducción de movimiento en stickers.

## Lo que NO está incluido todavía

- Compra real, precio, restauración, verificación y reembolsos. Crear un producto permanente no consumible (ID propuesto `libro_infinito`) en Play Console, luego integrar Billing y probar todos sus estados antes de publicar. Nunca usar el booleano legado como prueba de pago.
- Conversión de foto a contornos: se comunican fotos tal como son, no se promete esa conversión.
- Autoguardado, deshacer rellenos, borrador real, biblioteca virtualizada y remodelación completa del diseño.
- Migración restaurable de compradores/fundadores en otros dispositivos: primero confirmar si la descarga actual se vende o es gratuita y qué compraron los usuarios existentes.
- No se cambió visibilidad del repositorio, precio, versión de producción, firma ni Play Console.

## Verificación

```sh
node tool/check_static.mjs
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

Las comprobaciones estáticas no acreditan compilación ni funcionamiento Android. Probar importación PNG/JPG corrupto, 12 MP, superior a 40 MP, vertical con EXIF, sin espacio libre y cancelación. Probar fondo/restauración, salir/cambiar/limpiar con trabajo, compartir cancelado y dispositivo pequeño horizontal. Los recursos de firma ya estaban excluidos por `android/.gitignore`; la auditoría anterior omitió ese archivo.

## Decisiones de producto

Mantener herramientas y catálogo gratuito sin anuncios ni suscripción. Reservar para una compra única la importación ilimitada; no cobrar por cada página ni presionar al niño. Son hipótesis de producto coherentes con la propuesta, no garantía de conversión o ventas.

Referencias: [integración de Google Play Billing](https://developer.android.com/google/play/billing/integrate), [acceso selectivo a fotos](https://developer.android.com/training/data-storage/shared/photo-picker).
