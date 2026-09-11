#!/usr/bin/env node
// Herramientas de build local de la guía. Subcomandos: doctor | publisher | build | serve | clean.
// Se invocan vía npm (ver "scripts" en package.json), no directamente.
//
// Existe en vez de usar `java -jar publisher.jar` a secas por dos razones:
//
//  1. El IG Publisher necesita Java 11+, y en varias máquinas del equipo el `java` del
//     PATH es un JRE 8 antiguo (en Windows el java8path de Oracle vive en el PATH de
//     máquina, que se resuelve ANTES que el de usuario, así que no basta con instalar un
//     JDK nuevo). Acá se busca un JDK adecuado y se invoca por ruta absoluta.
//  2. La JVM arranca con el encoding de la plataforma; en Windows es windows-1252 y
//     arruina los acentos del contenido en español. Se fuerza UTF-8 siempre.

import { spawnSync } from 'node:child_process'
import { createReadStream, existsSync, mkdirSync, readdirSync, rmSync, statSync } from 'node:fs'
import { createServer } from 'node:http'
import { dirname, extname, join, normalize, resolve, sep } from 'node:path'
import { fileURLToPath } from 'node:url'

const RAIZ = resolve(dirname(fileURLToPath(import.meta.url)), '..')
const SALIDA = join(RAIZ, 'output')
const PUERTO = Number(process.env.IG_PORT ?? 8081)
const PUBLISHER = join(RAIZ, 'input-cache', 'publisher.jar')
const PUBLISHER_URL =
  'https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar'
const JAVA_MINIMO = 11
const REGENERABLES = ['fsh-generated', 'output', 'temp']

const esWindows = process.platform === 'win32'
const ejecutable = (base) => (esWindows ? `${base}.exe` : base)

// ─── detección de herramientas ────────────────────────────────────────────────

// `java -version` escribe en stderr y el formato cambió entre Java 8 y 9:
// Java 8 dice  version "1.8.0_441"  → major 8
// Java 9+ dice version "17.0.20.1"  → major 17
function versionJava(binJava) {
  const r = spawnSync(binJava, ['-version'], { encoding: 'utf8' })
  if (r.error || r.status !== 0) return null
  const m = /version "(\d+)(?:\.(\d+))?/.exec(`${r.stderr}${r.stdout}`)
  if (!m) return null
  const major = Number(m[1])
  return major === 1 ? Number(m[2]) : major
}

function candidatosJdk() {
  const casa = process.env.USERPROFILE || process.env.HOME || ''
  const raices = esWindows
    ? [
        join(casa, '.jdks'),
        'C:\\Program Files\\Eclipse Adoptium',
        'C:\\Program Files\\Java',
        'C:\\Program Files\\Microsoft',
        'C:\\Program Files\\Amazon Corretto',
        'C:\\Program Files\\Zulu',
      ]
    : ['/usr/lib/jvm', '/Library/Java/JavaVirtualMachines', join(casa, '.jdks'), '/opt/java']

  const encontrados = []
  for (const raiz of raices) {
    if (!existsSync(raiz)) continue
    let hijos
    try {
      hijos = readdirSync(raiz)
    } catch {
      continue // sin permiso de lectura: no es fatal, seguimos con las demás raíces
    }
    for (const hijo of hijos) {
      // macOS anida el home real bajo Contents/Home
      for (const sufijo of ['', 'Contents/Home']) {
        const bin = join(raiz, hijo, sufijo, 'bin', ejecutable('java'))
        if (existsSync(bin)) encontrados.push(bin)
      }
    }
  }
  return encontrados
}

// Devuelve { bin, version } del primer Java >= JAVA_MINIMO, o null.
// Orden: JAVA_HOME, luego JDKs instalados (mayor versión primero), luego el del PATH.
export function buscarJava() {
  const evaluar = (bin) => {
    if (!bin || !existsSync(bin)) return null
    const version = versionJava(bin)
    return version && version >= JAVA_MINIMO ? { bin, version } : null
  }

  if (process.env.JAVA_HOME) {
    const desdeHome = evaluar(join(process.env.JAVA_HOME, 'bin', ejecutable('java')))
    if (desdeHome) return desdeHome
  }

  const instalados = candidatosJdk()
    .map(evaluar)
    .filter(Boolean)
    .sort((a, b) => b.version - a.version)
  if (instalados.length > 0) return instalados[0]

  const enPath = spawnSync(ejecutable('java'), ['-version'], { encoding: 'utf8' })
  if (!enPath.error) {
    const version = versionJava(ejecutable('java'))
    if (version && version >= JAVA_MINIMO) return { bin: ejecutable('java'), version }
  }
  return null
}

// El IG Publisher invoca `jekyll` como proceso hijo, así que tiene que estar en el PATH
// que le pasamos. Si Ruby está instalado pero no en el PATH, devolvemos su bin para
// inyectarlo nosotros.
export function buscarJekyll() {
  const directo = spawnSync(esWindows ? 'jekyll.bat' : 'jekyll', ['--version'], {
    encoding: 'utf8',
    shell: esWindows,
  })
  if (!directo.error && directo.status === 0) {
    return { version: directo.stdout.trim(), binExtra: null }
  }

  if (esWindows) {
    for (const raiz of ['C:\\', join(process.env.USERPROFILE || '', '')]) {
      if (!existsSync(raiz)) continue
      let hijos = []
      try {
        hijos = readdirSync(raiz).filter((h) => /^Ruby\d/i.test(h))
      } catch {
        continue
      }
      for (const hijo of hijos) {
        const bin = join(raiz, hijo, 'bin')
        if (!existsSync(join(bin, 'jekyll.bat'))) continue
        const r = spawnSync(join(bin, 'jekyll.bat'), ['--version'], {
          encoding: 'utf8',
          shell: true,
        })
        if (!r.error && r.status === 0) return { version: r.stdout.trim(), binExtra: bin }
      }
    }
  }
  return null
}

// ─── subcomandos ──────────────────────────────────────────────────────────────

function doctor() {
  const filas = []
  const java = buscarJava()
  const jekyll = buscarJekyll()
  const jar = existsSync(PUBLISHER)

  filas.push(['Node', true, process.version])
  filas.push(['Java (>=' + JAVA_MINIMO + ')', !!java, java ? `${java.version} — ${java.bin}` : 'no encontrado'])
  filas.push([
    'Jekyll',
    !!jekyll,
    jekyll ? `${jekyll.version}${jekyll.binExtra ? ` (fuera del PATH: ${jekyll.binExtra})` : ''}` : 'no encontrado',
  ])
  filas.push([
    'publisher.jar',
    jar,
    jar ? `${(statSync(PUBLISHER).size / 1048576).toFixed(0)} MB — input-cache/` : 'falta: npm run publisher',
  ])

  console.log('\nEntorno de build local\n')
  for (const [nombre, ok, detalle] of filas) {
    console.log(`  ${ok ? 'OK  ' : 'FALTA'}  ${nombre.padEnd(16)} ${detalle}`)
  }

  const faltan = filas.filter(([, ok]) => !ok).map(([n]) => n)
  if (faltan.length === 0) {
    console.log('\nTodo listo. Corre: npm run build\n')
    return 0
  }

  console.log('\nCómo instalar lo que falta:\n')
  if (!java) {
    console.log('  Java 11+ (recomendado Temurin 17)')
    console.log('    Windows sin permisos de admin: descarga el ZIP de')
    console.log('      https://adoptium.net/temurin/releases/?version=17&package=jdk')
    console.log('    y descomprímelo; luego define JAVA_HOME apuntando a esa carpeta.')
    console.log('    macOS: brew install --cask temurin@17     Linux: apt install openjdk-17-jdk\n')
  }
  if (!jekyll) {
    console.log('  Jekyll (lo usa el IG Publisher para generar el HTML)')
    console.log('    Windows: winget install RubyInstallerTeam.RubyWithDevKit.3.3 --scope user')
    console.log('    macOS/Linux: instala Ruby 3.x y luego  gem install jekyll bundler')
    console.log('    Windows, después de instalar Ruby:      gem install jekyll bundler\n')
  }
  if (!jar) console.log('  publisher.jar:  npm run publisher\n')
  return 1
}

function descargarPublisher() {
  mkdirSync(dirname(PUBLISHER), { recursive: true })
  console.log(`Descargando IG Publisher (~230 MB) desde:\n  ${PUBLISHER_URL}`)
  const r = spawnSync('curl', ['-L', '--fail', '--progress-bar', '-o', PUBLISHER, PUBLISHER_URL], {
    stdio: 'inherit',
  })
  if (r.error || r.status !== 0) {
    console.error('\nFalló la descarga. Bájalo a mano y guárdalo en input-cache/publisher.jar:')
    console.error(`  ${PUBLISHER_URL}`)
    return 1
  }
  console.log(`\nListo: input-cache/publisher.jar (${(statSync(PUBLISHER).size / 1048576).toFixed(0)} MB)`)
  return 0
}

function build() {
  const java = buscarJava()
  if (!java) {
    console.error(`No se encontró Java ${JAVA_MINIMO}+. Corre "npm run doctor" para ver cómo instalarlo.`)
    return 1
  }
  if (!existsSync(PUBLISHER)) {
    console.error('Falta input-cache/publisher.jar. Corre "npm run publisher".')
    return 1
  }
  const jekyll = buscarJekyll()
  if (!jekyll) {
    console.error('No se encontró Jekyll; el publisher no podrá generar el HTML.')
    console.error('Corre "npm run doctor" para ver cómo instalarlo.')
    return 1
  }

  const entorno = { ...process.env, JAVA_HOME: resolve(dirname(java.bin), '..') }
  if (jekyll.binExtra) {
    entorno.PATH = `${jekyll.binExtra}${esWindows ? ';' : ':'}${entorno.PATH ?? ''}`
  }

  console.log(`Java ${java.version} — ${java.bin}`)
  console.log(`Jekyll ${jekyll.version}\n`)

  // -Dfile.encoding=UTF-8 no es opcional: sin él la JVM usa el encoding de la
  // plataforma y el contenido en español sale con los acentos corruptos.
  const r = spawnSync(
    java.bin,
    ['-Dfile.encoding=UTF-8', '-jar', PUBLISHER, '-ig', 'ig.ini'],
    { cwd: RAIZ, env: entorno, stdio: 'inherit' },
  )
  if (r.error) {
    console.error(`No se pudo ejecutar el publisher: ${r.error.message}`)
    return 1
  }
  if (r.status !== 0) return r.status

  console.log('\nSitio:  output/index.html')
  console.log('QA:     output/qa.html')
  return 0
}

const TIPOS = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.xml': 'application/xml; charset=utf-8',
  '.ttl': 'text/turtle; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8',
  '.csv': 'text/csv; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.map': 'application/json; charset=utf-8',
  '.tgz': 'application/gzip',
  '.zip': 'application/zip',
  '.pdf': 'application/pdf',
}

// Servidor estático mínimo sobre output/. Hace falta un servidor de verdad (y no abrir
// output/index.html con file://) porque la plantilla del IG carga JS y hace fetch de
// recursos: con file:// el navegador bloquea esas peticiones por CORS y quedan sin
// renderizar los diagramas Mermaid y los cuadros de terminología.
function serve() {
  if (!existsSync(join(SALIDA, 'index.html'))) {
    console.error('No existe output/index.html. Corre primero "npm run build".')
    return 1
  }

  const servidor = createServer((peticion, respuesta) => {
    let ruta
    try {
      ruta = decodeURIComponent(new URL(peticion.url, 'http://localhost').pathname)
    } catch {
      respuesta.writeHead(400).end('URL inválida')
      return
    }
    if (ruta.endsWith('/')) ruta += 'index.html'

    // normalize() colapsa los ".." antes de que podamos comparar; sin esta comprobación
    // una petición a /../../algo escaparía de output/.
    const archivo = join(SALIDA, normalize(ruta))
    if (archivo !== SALIDA && !archivo.startsWith(SALIDA + sep)) {
      respuesta.writeHead(403).end('Prohibido')
      return
    }
    if (!existsSync(archivo) || !statSync(archivo).isFile()) {
      respuesta.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' })
      respuesta.end(`No encontrado: ${ruta}`)
      return
    }

    respuesta.writeHead(200, {
      'Content-Type': TIPOS[extname(archivo).toLowerCase()] ?? 'application/octet-stream',
      'Cache-Control': 'no-cache',
    })
    createReadStream(archivo).pipe(respuesta)
  })

  servidor.on('error', (e) => {
    if (e.code === 'EADDRINUSE') {
      console.error(`El puerto ${PUERTO} está ocupado. Usa otro:  IG_PORT=8081 npm run serve`)
      process.exit(1)
    }
    throw e
  })

  servidor.listen(PUERTO, () => {
    console.log(`\nGuía servida en  http://localhost:${PUERTO}/`)
    console.log(`Informe QA en    http://localhost:${PUERTO}/qa.html`)
    console.log('\nCtrl+C para detener.\n')
  })
}

function clean() {
  for (const dir of REGENERABLES) {
    const ruta = join(RAIZ, dir)
    if (!existsSync(ruta)) continue
    rmSync(ruta, { recursive: true, force: true })
    console.log(`borrado ${dir}/`)
  }
  console.log('\nSe conserva input-cache/ (publisher.jar y caché de terminología).')
  return 0
}

// ─── entrada ──────────────────────────────────────────────────────────────────

const subcomandos = { doctor, publisher: descargarPublisher, build, serve, clean }
const elegido = process.argv[2]

if (!Object.hasOwn(subcomandos, elegido)) {
  console.error(`Subcomando desconocido: ${elegido ?? '(ninguno)'}`)
  console.error(`Disponibles: ${Object.keys(subcomandos).join(', ')}`)
  process.exit(2)
}

// "serve" no devuelve nada y deja el proceso vivo escuchando; el resto devuelve
// un código de salida.
const codigo = subcomandos[elegido]()
if (typeof codigo === 'number') process.exit(codigo)
