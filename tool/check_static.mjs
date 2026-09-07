// Small repository checks; not a substitute for flutter analyze/test.
import {readFileSync, existsSync} from 'node:fs';
import assert from 'node:assert/strict';
const read = p => readFileSync(p, 'utf8');
const menu = read('lib/menu_principal.dart');
const paths = [...new Set(menu.match(/assets\/[A-Za-z0-9_./-]+\.png/g))];
assert.equal(paths.length, 50);
for (const path of paths) assert.ok(existsSync(path), `Missing ${path}`);
assert.ok(!/setBool\(['"]es_pro['"],\s*true/.test(menu), 'Fake purchase unlock');
const files = read('lib/gestor_archivos.dart');
assert.ok(!files.includes('Permission.'), 'Unnecessary media permission');
assert.ok(!files.includes('listSync'), 'Synchronous directory scan');
assert.ok(files.includes('maxPixels') && files.includes('maxBytes'));
assert.ok(!read('lib/juego_pintura.dart').includes('requestReview'));
assert.ok(read('lib/servicio_audio.dart').includes("getBool('audio_activo') ?? false"));
console.log(`PASS: ${paths.length} assets; no fake purchase, no broad permission request, bounded imports, no automatic review, quiet default.`);
