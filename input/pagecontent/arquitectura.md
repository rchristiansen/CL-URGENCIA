# Arquitectura de interoperabilidad

## Jerarquía normativa

La arquitectura utiliza:

1. HL7 FHIR R4 `4.0.1`.
2. CL-Core Chile `1.8.5`.
3. MPI/NID MINSAL como dependencias externas pendientes de formalización.
5. Guía de dominio Datos de Atención de Urgencia (DAU).

La identidad del paciente deberá validarse mediante las transacciones y perfiles oficiales de MPI/NID que se acuerden para la versión normativa.

## Sistemas participantes

| Sistema | Rol |
|---|---|
| HIS / RCE | Registra y envía la información completa de la atención. |
| Bus de Interoperabilidad | Transforma, valida, consulta servicios nacionales y publica. |
| Servicio Terminológico | Valida códigos y unidades después de la transformación FHIR. |
| MPI MINSAL | Resuelve la identidad única del paciente. |
| NID MINSAL | Define perfiles y transacciones nacionales de interoperabilidad. |
| Repositorio FHIR | Conserva el documento, recursos, PDF y versiones. |
| Portal Ciudadano | Consume la información estructurada o documental publicada. |

## Flujo de integración

<div class="mermaid">
flowchart LR
    HIS["HIS / RCE"] -->|"HL7 v2 / FHIR R4"| TRANS["Transformación a FHIR R4"]
    TRANS --> TERM["Servicio Terminológico"]
    TERM --> MPI["Validación MPI / NID"]
    MPI --> VAL["Validación perfiles DAU"]
    VAL --> REP["Repositorio FHIR"]
    REP --> PORTAL["Portal Ciudadano"]
</div>

## Modelo de transacción

El documento clínico se representa como:

```text
Bundle.type = document
```

La primera entrada corresponde a:

```text
Bundle.entry[0].resource = Composition
```

La carga del documento se realiza mediante:

```http
POST [URL_BASE]/Bundle
Content-Type: application/fhir+json
```

Un `Bundle.type = transaction` puede utilizarse para registrar múltiples recursos en una única operación HTTP. En ese caso, el `Bundle.type = document` del DAU se conserva como el documento clínico publicado.

## Recursos FHIR R4

| Recurso | Uso |
|---|---|
| `Bundle` | Contenedor documental. |
| `Composition` | Documento, secciones, autor, paciente, atención y custodio. |
| `Patient` | Identidad y datos demográficos. |
| `Encounter` | Episodio, admisión, atención, estado y egreso. |
| `Organization` | Establecimiento y Servicio de Salud. |
| `Location` | Unidad, box o ubicación clínica. |
| `Practitioner` | Identificación del profesional. |
| `PractitionerRole` | Profesión, rol, especialidad y organización. |
| `Condition` | Antecedentes, hipótesis y diagnósticos. |
| `Observation` | Categorización, signos vitales y mediciones. |
| `Procedure` | Procedimientos realizados. |
| `ServiceRequest` | Solicitudes de exámenes, procedimientos y derivaciones. |
| `MedicationAdministration` | Medicamentos administrados. |
| `MedicationRequest` | Medicamentos indicados. |
| `DocumentReference` | PDF y documentos relacionados. |

## Secuencia de validación

<div class="mermaid">
flowchart TD
    A["Entrada HL7 v2 / FHIR"] --> B["Bundle FHIR R4"]
    B --> C["Validación terminológica"]
    C --> D["Validación Patient contra MPI"]
    D --> E["Validación perfiles NID / CL-Core"]
    E --> F["Validación perfiles DAU"]
    F --> G["Publicación FHIR y PDF"]
</div>

## Validación del paciente mediante MPI/NID

El Bus debe validar el recurso `Patient` antes de publicar cualquier información clínica.

| Resultado | Acción |
|---|---|
| Identidad única encontrada | Asociar el DAU al paciente MPI y continuar. |
| Identidad duplicada | Detener publicación y enviar a conciliación. |
| RUN inválido | Rechazar el documento y registrar el error. |
| Pasaporte válido | Consultar MPI utilizando pasaporte como identificador. |
| Paciente no encontrado | Ejecutar la transacción MPI correspondiente. |
| Datos demográficos contradictorios | Detener publicación hasta corregir la identidad. |
| MPI no disponible | Mantener el documento en cola y reintentar. |

## Servicio Terminológico

La consulta terminológica se realiza después de la transformación a FHIR y antes de la validación MPI/NID.

Se validan:

- Códigos de categorización.
- Procedencia.
- Medio de llegada.
- Diagnósticos CIE-10.
- Conceptos clínicos SNOMED CT.
- Signos vitales LOINC.
- Unidades UCUM.
- Procedimientos SNOMED CT.
- Prestaciones FONASA.
- Medicamentos del catálogo nacional.
- Condiciones y destinos de egreso.

## Identidad institucional y profesional

- El establecimiento se identifica mediante código DEIS.
- El Servicio de Salud se identifica mediante catálogo nacional.
- Los profesionales se identifican mediante RUN, identificador profesional y rol.
- Las organizaciones y profesionales se validan mediante NID/HPD.
- El paciente se valida mediante MPI.
- Los identificadores originales se conservan junto con los identificadores nacionales.

## Seguridad y trazabilidad

El Bus registra:

- `MSH-10`.
- Sistema emisor.
- Fecha y hora de recepción.
- Identificador del paciente.
- Identificador MPI.
- Identificador de atención.
- Identificador del DAU.
- Resultado terminológico.
- Resultado MPI/NID.
- Resultado de validación.
- Versión publicada.
- Respuesta enviada al HIS/RCE.

El Portal Ciudadano solo recibe documentos asociados a una identidad validada y con autorización vigente.
