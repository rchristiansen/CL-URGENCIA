# Notas de continuidad de desarrollo

Documento de traspaso: qué está resuelto, qué está decidido y qué sigue abierto. Complementa el `README.md` y la página *Historial de cambios*.

## Estado de la versión 0.2.0

La guía se rediseñó desde un documento único al cierre (`Bundle document` + `Composition`) hacia **tres eventos** (`Bundle transaction`): admisión, alta y abandono. SUSHI compila con 0 errores y 0 advertencias; el IG Publisher reporta 0 errores (ejemplos validados contra CL-Core 1.9.2 y NID 0.4.6).

Fuentes usadas para el rediseño:

- *Modelo FHIR Mínimo — Admisión y Alta de Urgencia* (Encounter central, DocumentReference al PDF).
- CMBD de Urgencia DEIS (`CMBD_URGENCIAS3.xlsx`): campos, formatos y dominios.
- Guía publicada 0.1.2-ballot: códigos de tipo de abandono y patrón por eventos.

## Decisiones de diseño

1. **Eventos, no documento.** La red necesita saber en el momento que un paciente ingresó o se fue, no solo al cierre.
2. **`Bundle.type = transaction` con `PUT` condicional por identificador.** Estándar en cualquier servidor FHIR, atómico y alineado con 0.1.2-ballot. El evento no se declara: se deduce del estado del `Encounter`, que cada perfil de transacción obliga. Se descartó `message` porque `$process-message` exige programar la lógica en el Bus.
3. **Encounter central, correlación por ID DAU.** `PUT Encounter?identifier=[sistema]|[ID DAU]` crea el episodio en la admisión y lo actualiza en el alta o abandono. Nunca se correlaciona por `Encounter.id`.
4. **Transacciones autocontenidas e idempotentes.** Cada una trae paciente, establecimiento y encuentro; un alta sin admisión previa crea el episodio, y un reenvío no duplica recursos.
5. **Perfil de Encounter por evento.** Las reglas de cada momento (estado, `period.end`, destino) se validan con perfiles derivados, no con lógica en el Bus.
6. **Fuga y NEA = evento `abandono`.** Se distinguen por `CSTipoAbandono` (1 NEA, 2 fuga), mismos códigos que 0.1.2-ballot.
7. **Sin `Composition`.** El `DocumentReference` basta para descubrir y acceder al PDF. Diferencia deliberada con el documento *Modelo FHIR Mínimo*, que la listaba como obligatoria.
8. **Lo clínico detallado queda en el PDF.** Solo se estructura diagnóstico y medicamentos al alta. Categorización, signos vitales, exámenes y procedimientos quedan fuera.
9. **Datos CMBD no clínicos como extensiones opcionales.** Permiten alimentar la estadística sin obligar a los establecimientos.
10. **Paciente, profesional y establecimiento son los perfiles del NID** (`MINSALPaciente`, `MINSALPrestadorProfesional`, `MINSALPrestadorOrganizacional`), sin perfilamiento propio. La terminología administrativa (previsión, tramo, leyes, título) también es la del NID.
11. **Tipo de diagnóstico CMBD → `Condition.verificationStatus`.** Hipótesis/confirmado/descartado = `provisional`/`confirmed`/`refuted`. Hipótesis vs egreso → `Encounter.diagnosis.use` (`AD`/`DD`).

## Pendientes

### Terminología e identificadores

- Identificadores: RUN usa el OID de los ejemplos NID (`urn:oid:2.16.840.1.113883.2.22.1.152.787300`) y el establecimiento el sistema DEIS de TEI (`https://interoperabilidad.minsal.cl/fhir/ig/tei/CodeSystem/CSEstablecimientoDestino`). Confirmar que son los oficiales.
- CL-Core se fijó en **1.9.2** porque NID 0.4.6 depende de esa versión y fija bindings versionados (países en `CodPais`). Con 1.9.3 cargada en paralelo, los países cambian a `urn:iso:std:iso:3166` y ningún código satisface ambos. `EncounterCL` y `CoreDiagnosticoCl` son idénticos en 1.9.2 y 1.9.3. Para volver a 1.9.3+ hay que migrar a una versión del NID construida sobre ella (0.4.9 es la última).
- `MINSALPaciente` exige identidad de género, nacionalidad, país de origen, teléfono, fecha de nacimiento y `deceased[x]`. Pacientes NN o sin teléfono no validan: definir con NID cómo se informan en urgencia.
- `CSLeyPrevisionales` del NID no incluye PRAIS (código 05 del CMBD). La extensión quedó con binding `extensible` mientras se resuelve.
- Armonizar procedencia y medio de llegada: el CMBD (7 y 17 códigos) difiere de la guía 0.1.2-ballot (14 y 14 códigos). La guía usa el CMBD.
- Definir URI de TAPSA para diagnósticos.
- Publicar los CodeSystems en el Servidor Terminológico Nacional y quitar `experimental`.

### Bus y operación

- Confirmar endpoint y autenticación del Bus para las transacciones.
- Confirmar que el repositorio soporta `PUT` condicional y `Subscription` (para avisar eventos a la red).
- Definir cómo evitar que una admisión reenviada tarde reabra un episodio cerrado (validación en el Bus o `If-Match`).
- Confirmar con HCC qué información muestra al paciente (episodios, diagnóstico, PDF).
- Confirmar si el PDF lo hospeda el establecimiento (URL) o se replica en el repositorio central.
- Definir plazo máximo de envío por evento (ej.: admisión < 15 min).
- Definir tratamiento de correcciones (`entered-in-error`) y de reapertura de episodios.

### Validación clínica

- Validar con DIGERA/DEIS el conjunto obligatorio por evento (tabla en *Modelo de eventos*).
- Confirmar si el alta debe exigir profesional responsable (hoy opcional).
- Confirmar si el alta debe exigir PDF siempre (hoy obligatorio).

## Cómo retomar

```bash
npm run sushi      # solo perfiles
npm run build      # SUSHI + IG Publisher; revisar output/qa.html
```
