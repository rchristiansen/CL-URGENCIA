# Mapeo HL7 v2 a FHIR R4

## Alcance

Esta página define la transformación del flujo de urgencia desde HL7 v2 hacia recursos FHIR R4.

El mapeo es una propuesta técnica y debe asociarse a una versión concreta de HL7 v2, tipo de mensaje y evento disparador antes de ser utilizado como contrato de interoperabilidad.

El procesamiento se realiza en el siguiente orden:

1. Recepción desde el HIS/RCE.
2. Transformación a FHIR R4.
3. Consulta al Servicio Terminológico.
4. Validación del paciente contra MPI/NID.
5. Validación de perfiles DAU.
6. Publicación en el repositorio y Portal Ciudadano.

## Flujo de transformación

<div class="mermaid">
flowchart TD
    A["HL7 v2"] --> B["Transformación FHIR R4"]
    B --> C["Servicio Terminológico"]
    C --> D["MPI / NID"]
    D --> E["Validación DAU"]
    E --> F["Bundle.type = document"]
    F --> G["Portal Ciudadano"]
</div>

## Mapeo de admisión y paciente

| Mensaje/Campo HL7 v2 | Campo Clínico DAU | Recurso y Elemento FHIR R4 | Perfil CL-Core / NID | Card. | Observaciones / Binding |
|---|---|---|---|---|---|
| `MSH-4` | Establecimiento | `Composition.custodian` | CL-Core Organization / NID | 1..1 | Código DEIS. |
| `MSH-7` | Fecha de mensaje | `Bundle.timestamp` | FHIR R4 | 1..1 | ISO 8601 con zona horaria. |
| `EVN-2` | Fecha del evento | `Encounter.period.start` | `DauEncounter` | 1..1 | Fecha clínica del evento. |
| `PID-3` | Identificador paciente | `Patient.identifier` | MPI / NID Patient | 1..* | RUN, pasaporte, MPI o local. |
| `PID-3.4` | Autoridad asignadora | `Patient.identifier.assigner` | NID Patient | 1..1 | Mantener sistema de origen. |
| `PID-5` | Nombre legal | `Patient.name[use=official]` | CL-Core Patient / NID | 1..1 | Nombres y apellidos. |
| `PID-7` | Fecha nacimiento | `Patient.birthDate` | CL-Core Patient / NID | 1..1 | Convertir `AAAAMMDD`. |
| `PID-8` | Sexo registral | `Patient.gender` | NID / ACE | 1..1 | `M → male`, `F → female`, `U → unknown`. |
| `PID-11` | Dirección | `Patient.address` | CL-Core Patient / Norma 820 | 0..1 | Región, comuna y domicilio. |
| `PID-13` | Teléfono | `Patient.telecom` | CL-Core Patient / NID | 0..* | Formato E.164. |
| `PID-14` | Correo | `Patient.telecom` | CL-Core Patient / NID | 0..1 | Dato protegido. |
| `PV1-2` | Clase atención | `Encounter.class` | `DauEncounter` | 1..1 | Código `EMER`. |
| `PV1-3` | Unidad urgencia | `Encounter.location` | CL-Core Location / NID | 1..1 | Unidad o box de atención. |
| `PV1-19` | ID atención | `Encounter.identifier` | `DauEncounter` | 1..1 | Diferente del ID del DAU. |
| `PV1-44` | Fecha admisión | `Encounter.period.start` | `DauEncounter` | 1..1 | Fecha y hora con zona. |
| `PV2-3` | Motivo consulta | `Encounter.reasonCode` | `DauEncounter` | 1..1 | Texto y código validado. |
| `PV2-8` | Procedencia | Extensión de `Encounter` | Norma 820 / MINSAL | 1..1 | Código de procedencia nacional. |
| `PV2-9` | Medio llegada | Extensión de `Encounter` | Norma 820 / MINSAL | 1..1 | Ambulancia, vehículo, a pie u otro. |
| `PID-18` | ID cuenta o episodio | `Encounter.identifier` | `DauEncounter` | 0..1 | Conservar si el HIS/RCE lo informa. |

## Mapeo de categorización y observaciones

| Mensaje/Campo HL7 v2 | Campo Clínico DAU | Recurso y Elemento FHIR R4 | Perfil CL-Core / NID | Card. | Observaciones / Binding |
|---|---|---|---|---|---|
| `OBX` categorización | Sistema categorización | `Observation.method` | `DauObservation` | 1..1 | Discrecional, ESI o UGO. |
| `OBX` categorización | Nivel categorización | `Observation.valueCodeableConcept` | ValueSet CategorizacionDAU | 1..1 | C1-C5 o ESI 1-5. |
| `OBX-14` | Fecha categorización | `Observation.effectiveDateTime` | `DauObservation` | 1..1 | Repetible por evento. |
| `OBX` profesional | Profesional categorizador | `Observation.performer` | CL-Core PractitionerRole / NID | 1..1 | Profesional validado en HPD/NID. |
| `OBX` `8867-4` | Frecuencia cardíaca | `Observation.valueQuantity` | LOINC / UCUM | 0..1 | Unidad `/min`. |
| `OBX` `8480-6` | Presión sistólica | `Observation.component` | LOINC / UCUM | 0..1 | Unidad `mm[Hg]`. |
| `OBX` `8462-4` | Presión diastólica | `Observation.component` | LOINC / UCUM | 0..1 | Unidad `mm[Hg]`. |
| `OBX` `8310-5` | Temperatura | `Observation.valueQuantity` | LOINC / UCUM | 0..1 | Unidad `Cel`. |
| `OBX` `9279-1` | Frecuencia respiratoria | `Observation.valueQuantity` | LOINC / UCUM | 0..1 | Unidad `/min`. |
| `OBX` `59408-5` | Saturación oxígeno | `Observation.valueQuantity` | LOINC / UCUM | 0..1 | Unidad `%`. |
| `OBX` `72514-3` | Intensidad dolor | `Observation.valueQuantity` | LOINC / SNOMED CT | 0..1 | Registrar escala. |
| `OBX` `9269-2` | Glasgow | `Observation.valueQuantity` | LOINC / SNOMED CT | 0..1 | Puntaje total. |
| `OBX` hemoglucotest | Glicemia capilar | `Observation.valueQuantity` | LOINC / UCUM | 0..1 | Unidad `mg/dL` o `mmol/L`. |
| `OBX` anamnesis | Anamnesis | `Composition.section.text` | `DocumentoDAU` | 0..1 | Narrativa clínica. |
| `OBX` examen físico | Examen físico | `Composition.section.text` | `DocumentoDAU` | 0..1 | Texto clínico. |
| `OBX` evolución | Evolución clínica | `Composition.section.text` | `DocumentoDAU` | 0..1 | Respuesta a acciones clínicas. |

## Mapeo de diagnósticos y solicitudes

| Mensaje/Campo HL7 v2 | Campo Clínico DAU | Recurso y Elemento FHIR R4 | Perfil CL-Core / NID | Card. | Observaciones / Binding |
|---|---|---|---|---|---|
| `DG1-3` | Código diagnóstico | `Condition.code.coding` | `DiagnosticoUrgenciaDAU` | 0..* | CIE-10 o SNOMED CT. |
| `DG1-5` | Fecha diagnóstico | `Condition.onsetDateTime` | `DauCondition` | 0..1 | Fecha de registro. |
| `DG1-6` | Tipo diagnóstico | `Condition.category` | ValueSet DiagnosticoDAU | 1..1 | Hipótesis, principal, secundario o final. |
| `DG1` | Certeza clínica | `Condition.verificationStatus` | FHIR VerificationStatus | 0..1 | Provisional, confirmado o refutado. |
| `ORC-1` | Estado solicitud | `ServiceRequest.status` | FHIR RequestStatus | 1..1 | `active`, `completed`, `revoked`. |
| `ORC-2` | ID solicitud | `ServiceRequest.identifier` | NID / sistema institucional | 0..1 | Identificador de orden. |
| `ORC-9` | Fecha solicitud | `ServiceRequest.authoredOn` | FHIR R4 | 1..1 | Fecha y hora. |
| `ORC-12` | Profesional solicitante | `ServiceRequest.requester` | CL-Core PractitionerRole / NID | 0..1 | Profesional validado. |
| `OBR-4` | Prestación solicitada | `ServiceRequest.code` | FONASA / LOINC / SNOMED CT | 1..1 | Validación terminológica. |

## Mapeo de tratamientos, procedimientos y egreso

| Mensaje/Campo HL7 v2 | Campo Clínico DAU | Recurso y Elemento FHIR R4 | Perfil CL-Core / NID | Card. | Observaciones / Binding |
|---|---|---|---|---|---|
| `PR1` | Procedimiento realizado | `Procedure.code` | SNOMED CT | 0..* | Una instancia por procedimiento. |
| `PR1-5` | Fecha procedimiento | `Procedure.performedDateTime` | FHIR R4 | 0..1 | Fecha y hora efectiva. |
| `PR1-10` | Profesional ejecutor | `Procedure.performer` | CL-Core PractitionerRole / NID | 0..* | Profesional validado. |
| `RXA` | Medicamento administrado | `MedicationAdministration.medication[x]` | Catálogo farmacéutico | 0..* | Una instancia por medicamento. |
| `RXA-3` | Fecha administración | `MedicationAdministration.effectiveDateTime` | FHIR R4 | 0..1 | Fecha y hora efectiva. |
| `RXA-5` | Dosis administrada | `MedicationAdministration.dosage.dose` | UCUM | 0..1 | Valor y unidad. |
| `RXO` / `RXE` | Medicamento indicado | `MedicationRequest.medication[x]` | Catálogo farmacéutico | 0..* | Medicamento prescrito. |
| `RXE-2` | Dosis e instrucciones | `MedicationRequest.dosageInstruction` | UCUM / SNOMED CT | 0..1 | Dosis, vía, frecuencia y duración. |
| `PV1-36` | Condición egreso | `Encounter.hospitalization.dischargeDisposition` | ValueSet EgresoDAU | 1..1 | Alta, hospitalización, traslado, abandono o fallecimiento. |
| `PV1-45` | Egreso efectivo | `Encounter.period.end` | `DauEncounter` | 0..1 | Fecha y hora de salida. |
| `TXA-6` | Fecha de creación del documento | `Composition.date` | `DocumentoDAU` | 1..1 | Fecha y hora de origen del documento. |
| `TXA-2` | Tipo documento | `Composition.type` | CodeSystem DocumentoDAU | 1..1 | Código `DAU`. |
| `TXA-9` | Autor documento | `Composition.author` | CL-Core PractitionerRole / NID | 1..* | Profesional responsable. |
| `TXA-17` | Estado de completitud | `Composition.status` | FHIR CompositionStatus | 1..1 | Homologar `preliminary`, `final`, `amended` o `entered-in-error`. |
| `TXA-12` | ID documento | `Composition.identifier` | `DocumentoDAU` | 1..1 | Identificador único del documento. |
| `OBX-2 = ED` | PDF DAU | `DocumentReference.content.attachment.data` | `DauDocumentReference` | 0..1 | `application/pdf` en Base64. |

## Reglas de consistencia

- `PID-3` debe validarse mediante MPI/NID antes de publicar.
- `PV1-19` identifica la atención y no el documento.
- `MSH-10` identifica el mensaje HL7 v2.
- Los segmentos `OBX` repetibles generan recursos `Observation`.
- Los segmentos `DG1` repetibles generan recursos `Condition`.
- Los segmentos `PR1` repetibles generan recursos `Procedure`.
- Los segmentos `ORC` y `OBR` generan recursos `ServiceRequest`.
- Los segmentos `RXA` generan `MedicationAdministration`.
- Los segmentos `RXO` y `RXE` generan `MedicationRequest`.
- Los códigos originales se conservan junto con los códigos homologados.
- Los resultados de laboratorio e imagenología no forman parte del documento DAU; solo se representan las solicitudes cuando existan.
