# Arquitectura de interoperabilidad

## Jerarquía normativa

La arquitectura utiliza:

1. HL7 FHIR R4 `4.0.1`.
2. CL-Core Chile `1.9.3`.
3. MPI Para identificación del paciente.
4. Guía de dominio Datos de Atención de Urgencia (DAU).

La identidad del paciente deberá validarse mediante las transacciones y perfiles oficiales de MPI que se acuerden para la versión normativa.

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
    HIS["HIS / RCE"]
    BUS["Bus de Interoperabilidad"]
    ESTRUCT["Validación del<br/>Bundle FHIR R4"]
    GUIA["Validación contra la<br/>Guía de Implementación DAU"]
    TERM["Validación terminológica"]
    PORTAL["Portal Ciudadano"]
    RECHAZO["Rechazo y detalle<br/>del error"]

    HIS -->|"Envía Bundle FHIR R4<br/>tipo document"| BUS
    BUS --> ESTRUCT
    ESTRUCT --> GUIA
    GUIA --> TERM
    TERM -->|"Documento DAU válido"| PORTAL

    ESTRUCT -.->|"Estructura inválida"| RECHAZO
    GUIA -.->|"No cumple la guía"| RECHAZO
    TERM -.->|"Terminología inválida"| RECHAZO
    RECHAZO -->|"Notifica el rechazo"| HIS
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

## Secuencia de validación

<div class="mermaid">
flowchart TD
    A["Recepción de Bundle FHIR R4<br/>tipo document"]
    B["Validación de estructura<br/>del Bundle"]
    C["Validación terminológica"]
    D["Validación contra los<br/>perfiles DAU"]
    E["Entrega al Portal Ciudadano<br/>FHIR + PDF asociado"]

    A --> B
    B --> C
    C --> D
    D --> E
</div>

## Validación del paciente mediante MPI

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

La consulta terminológica se realiza validación de identidad del paciente con la guía MPI.

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
- Las organizaciones y profesionales se validan mediante CL-Core
- El paciente se valida mediante MPI.
- Los identificadores originales se conservan junto con los identificadores nacionales.

## Seguridad y trazabilidad

El Bus registra:

- Sistema emisor.
- Fecha y hora de recepción.
- Identificador del paciente.
- Identificador MPI.
- Identificador de atención.
- Identificador del DAU.
- Resultado terminológico.
- Resultado MPI.
- Resultado de validación.
- Versión publicada.
- Respuesta enviada al HIS/RCE.

El Portal Ciudadano solo recibe documentos asociados a una identidad validada y con autorización vigente.
