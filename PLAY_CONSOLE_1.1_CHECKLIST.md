# Checklist Play Console — Mundo de Alegría 1.1.0+8

## Build
- [ ] `flutter pub get`
- [ ] `flutter analyze` sin issues
- [ ] `flutter test` con todos los tests aprobados
- [ ] Probar en Android real o emulador API 36
- [ ] `flutter build appbundle --release`
- [ ] Verificar firma de release
- [ ] Subir el AAB a una pista de prueba antes de producción

## Android
- [x] applicationId: `com.mundoalegria.kids`
- [x] versionName: `1.1.0`
- [x] versionCode: `8`
- [x] targetSdk: 36
- [x] compileSdk: 36
- [x] Sin permisos generales de almacenamiento solicitados por la app

## Google Play Billing
- [ ] Confirmar que el producto `libro_infinito` sigue activo en Play Console
- [ ] Confirmar que es un producto no consumible / compra única
- [ ] Probar compra con cuenta de licencia
- [ ] Probar compra pendiente/cancelada
- [ ] Probar restauración después de reinstalar o borrar datos
- [ ] Verificar que el precio localizado mostrado coincide con Google Play

## Familias / niños
- [ ] Revisar Target audience and content
- [ ] Revisar Data safety
- [ ] Revisar IARC Content Rating
- [ ] Declarar correctamente que no hay anuncios
- [ ] Verificar que la política de privacidad pública coincide con el comportamiento real
- [ ] Probar compuerta de adulto en compra y compartir
- [ ] Revisar cualquier vínculo externo antes de producción

## QA funcional
- [ ] Capibaras abre y permite colorear
- [ ] Animalitos abre y permite colorear
- [ ] Dinosaurios abre y permite colorear
- [ ] Dino Bebés abre y permite colorear
- [ ] Abecedario abre y permite colorear
- [ ] Pintura / relleno funciona
- [ ] Pincel funciona
- [ ] Marcador funciona
- [ ] Borrador real funciona sobre trazos
- [ ] Stickers funcionan y pueden deshacerse
- [ ] Limpiar pide confirmación
- [ ] Cambio anterior/siguiente no deja pantalla vacía
- [ ] Audio conserva preferencia al reiniciar
- [ ] Idioma conserva preferencia al reiniciar
- [ ] Libro Infinito bloqueado muestra paywall
- [ ] Libro Infinito desbloqueado permite importar
- [ ] Compartir genera la obra y abre el menú del sistema

## Ficha de tienda
- [ ] Título consistente: El Mundo de Alegría
- [ ] Mensaje principal: "El libro de colorear que nunca se termina"
- [ ] Destacar: sin anuncios, sin suscripción, compra única
- [ ] Captura 1: menú limpio + Libro Infinito
- [ ] Captura 2: colorear con un toque
- [ ] Captura 3: pinceles + stickers
- [ ] Captura 4: importa tus propios dibujos
- [ ] Video corto: dibujo → coloreado → stickers → compartir
- [ ] Notas de versión 1.1 listas
