# Guía de Implementación FHIR - Urgencia (DAU)

Guía de Implementación (IG) FHIR R4 para el intercambio del Documento de Atención de Urgencia (DAU) en Chile. Define la representación de la atención de urgencia, desde la información clínica registrada en el HIS/RCE del establecimiento hasta su validación e interoperabilidad mediante el Bus de Interoperabilidad de MINSAL.

La guía permite recibir información desde sistemas que generan recursos FHIR R4 y establece un modelo clínico interoperable común para la atención de urgencia. Este modelo incluye la identificación del paciente, el episodio de atención, la categorización, las observaciones clínicas, los diagnósticos, las solicitudes, los procedimientos, los tratamientos y el egreso.

Las solicitudes de laboratorio e imagenología realizadas durante el episodio pueden representarse mediante `ServiceRequest` cuando existan.

## Estado

- Versión: 0.1.0
- Estado FHIR: draft
- FHIR: R4 (4.0.1)
- Publicador: Unidad de Interoperabilidad, MINSAL
- Canonical: `https://interoperabilidad.minsal.cl/fhir/ig/urgencia`
- Dependencia implementada: CL-Core `1.9.3`

## Alcance

La guía cubre el intercambio del documento clínico DAU generado al finalizar o cerrar una atención de urgencia. El establecimiento puede entregar la información mediante dos puntos de integración:

1. **Intercambio mediante HL7 FHIR R4:** los sistemas participantes generan y envían un `Bundle` de tipo `document`, cuya primera entrada corresponde a una `Composition` que representa el Documento de Atención de Urgencia (DAU).

El modelo lógico del DAU es  FHIR R4.

| Fase | Contenido | Estado |
|---|---|---|
| Fase 1 | Documento DAU al egreso, identificación del paciente, episodio de atención, categorización, motivo de consulta, signos vitales, diagnósticos, solicitudes, tratamientos, procedimientos, destino e indicaciones de alta | Perfiles y ejemplo documental implementados; pendientes de validación clínica e institucional |
| Fuera del alcance actual | Procesos pertenecientes a otras guías de dominio | Se gestionan mediante sus respectivos flujos de interoperabilidad |

El alcance prioriza la información clínica necesaria para interoperar y permitir la consulta posterior del DAU.

## Jerarquía normativa

La guía utiliza FHIR R4 `4.0.1` y declara dependencia con CL-Core `1.9.3`. MPI, terminologías nacionales, autenticación y autorización se consideran dependencias externas que deben formalizarse mediante sus guías y acuerdos institucionales correspondientes.

El documento DAU se representa mediante un `Bundle.type = document` y una `Composition` como primera entrada. Los demás recursos se relacionan con la `Composition` y permiten representar el episodio completo de atención.

## Perfiles y recursos principales

| Perfil o recurso | Recurso base | Uso |
|---|---|---|
| `ComposicionDocumentoDAU` | Composition | Cabecera, autor, paciente, atención, custodio y secciones del documento DAU. |
| `BundleDocumentoDAU` | Bundle | Contenedor FHIR del documento; su primera entrada debe ser la `Composition`. |
| `DauPatient` | Patient | Identificación del paciente de la atención, basado en CL-Core. |
| `DauEncounter` | Encounter | Episodio de atención de urgencia, fechas, estado, establecimiento y egreso. |
| `ObservacionUrgenciaDAU` | Observation | Categorización, signos vitales y otras observaciones clínicas. |
| `DiagnosticoUrgenciaDAU` | Condition | Hipótesis y diagnósticos registrados durante la atención. |
| `SolicitudUrgenciaDAU` | ServiceRequest | Solicitudes de laboratorio, imagenología, procedimientos o derivaciones. |
| `ProcedimientoUrgenciaDAU` | Procedure | Procedimientos realizados durante la atención. |
| `MedicamentoAdministradoUrgenciaDAU` | MedicationAdministration | Medicamentos administrados durante la atención. |
| `MedicamentoIndicadoUrgenciaDAU` | MedicationRequest | Medicamentos prescritos o indicados al cierre de la atención. |
| `ProfesionalUrgenciaDAU` | Practitioner | Profesional responsable o participante de la atención. |
| `RolProfesionalUrgenciaDAU` | PractitionerRole | Relación del profesional con la organización y su función. |
| `OrganizacionUrgenciaDAU` | Organization | Establecimiento o unidad responsable de la atención. |
| `UbicacionUrgenciaDAU` | Location | Box, unidad o servicio donde se realiza la atención. |
| `DocumentoPDFUrgenciaDAU` | DocumentReference | PDF generado por el HIS/RCE, cuando corresponda. |

Los perfiles, cardinalidades y bindings se encuentran sujetos a validación técnica, clínica e institucional durante el desarrollo de la guía.

## Documento DAU

La estructura documental mínima es:

```text
Bundle.type = document
Bundle.entry[0].resource = Composition
Composition.subject = Patient
Composition.encounter = Encounter
Composition.author = Practitioner o PractitionerRole
Composition.custodian = Organization
```

El documento puede contener recursos asociados como:

- Paciente.
- Encuentro de urgencia.
- Organización y ubicación.
- Profesionales participantes.
- Observaciones clínicas.
- Diagnósticos.
- Solicitudes de laboratorio e imagenología.
- Procedimientos.
- Medicamentos administrados o indicados.
- PDF del DAU, cuando corresponda.

## Documentación del sitio publicado

| Página | Contenido |
|---|---|
| Inicio | Visión general, objetivo, alcance, estructura del DAU y recursos focales. |
| Arquitectura | Sistemas participantes, flujo HIS/RCE–Bus, transformación, terminología, MPI, NID y publicación. |
| Casos de uso | Actores, puntos de integración y flujo de intercambio del documento DAU. |
| Estructura del DAU | `Bundle.type=document`, `Composition` y recursos asociados. |
| Terminología | Categorización, diagnósticos, procedimientos, estados, destinos y códigos clínicos. |
| Validaciones | Reglas de identidad, obligatoriedad, consistencia y validación terminológica. |
| Historial de cambios | Cambios técnicos y funcionales por versión. |

La guía contempla dos casos de uso: envío FHIR directo y publicación del documento DAU.

## Estructura del repositorio

- `input/fsh/`: perfiles, terminología e instancias de ejemplo en FHIR Shorthand (FSH).
- `input/pagecontent/`: páginas narrativas del sitio publicado.
- `hl7chile-ig-template/`: plantilla de publicación institucional.
- `sushi-config.yaml`: configuración de SUSHI, dependencia, páginas y menú.
- `ig.ini`: configuración del IG Publisher.
- `package-list.json`: historial y metadatos de versiones publicables.
- `package.json`: versiones y comandos de compilación.
- `scripts/ig.mjs`: utilidades de diagnóstico, compilación y servidor local.

## Compilación local

Requisitos previos: **Node.js 18+**, **Java 11+** —se recomienda Temurin 17—, **Ruby** y **Jekyll**.

```bash
npm install
npm run doctor
```

Una vez verificado el entorno:

```bash
npm run publisher
npm run build
npm run serve
```

| Comando | Qué hace |
|---|---|
| `npm run doctor` | Diagnostica Node, Java, Jekyll y el IG Publisher. |
| `npm run sushi` | Compila los archivos FSH a recursos FHIR generados. |
| `npm run build` | Ejecuta SUSHI y el IG Publisher para generar el sitio completo. |
| `npm run serve` | Sirve la guía generada en un servidor local. |
| `npm run publisher` | Descarga o actualiza `publisher.jar`. |
| `npm run clean` | Limpia los artefactos generados. |

También es posible ejecutar directamente el publicador cuando se encuentre descargado:

```bash
java -jar input-cache/publisher.jar -ig ig.ini
```

El sitio generado queda en `output/index.html` y el informe de validación en `output/qa.html`. Se recomienda revisar la guía mediante `npm run serve`, ya que la apertura directa con `file://` puede impedir la carga de recursos de la plantilla y de los diagramas.

## Fuentes

Esta guía se construye a partir de:

- Conjunto mínimo de datos del Documento de Atención de Urgencia (DAU), versión de trabajo 0.1.
- Lineamientos de interoperabilidad HL7 FHIR R4 de MINSAL.
- CL-Core `1.9.3`.
- Guías de Implementación FHIR de referencia de Laboratorio Clínico e Imagenología, utilizadas como referencia para las solicitudes y la interoperabilidad entre dominios.
- Terminologías clínicas aplicables a categorización, diagnósticos, procedimientos, medicamentos, destinos y estados de atención.

## Contacto

Publicado por:

Área de Historia Clínica Compartida y Datos Clínicos  
Unidad de Interoperabilidad y Datos Clínicos  
Departamento Transformación Digital  
Gabinete Ministra de Salud  
Ministerio de Salud, República de Chile
