# Casos de uso

## Objetivo

Describir el flujo mediante el cual el HIS/RCE envía la información de una atención de urgencia al Bus de Interoperabilidad para su transformación a FHIR R4, validación y publicación.

## Actores

| Actor | Rol |
|---|---|
| Establecimiento de origen | Registra y envía la atención de urgencia. |
| HIS / RCE | Genera la información de admisión, atención, solicitudes y egreso. |
| Bus de Interoperabilidad | Transforma los datos a FHIR R4 y coordina las validaciones. |
| Servicio Terminológico | Valida códigos, catálogos y unidades de medida. |
| MPI / NID MINSAL | Valida la identidad del paciente y los identificadores nacionales. |
| Repositorio FHIR | Conserva el documento DAU y sus recursos. |
| Portal Ciudadano | Consume la información publicada. |

## Puntos de integración

1. **Punto FHIR directo:** el HIS/RCE envía un `Bundle` FHIR R4 de tipo `document`.
2. **Punto HL7 v2 homologado:** el HIS/RCE envía mensajes HL7 v2 con la información de admisión, atención, solicitudes y egreso.

Ambos puntos convergen en el mismo modelo canónico FHIR R4.

## Flujo general

<div class="mermaid">
sequenceDiagram
    participant HIS as HIS / RCE
    participant BUS as Bus de Interoperabilidad
    participant FHIR as Transformación FHIR R4
    participant TERM as Servicio Terminológico
    participant MPI as MPI / NID MINSAL
    participant REP as Repositorio FHIR
    participant POR as Portal Ciudadano

    HIS->>BUS: HL7 v2 o Bundle FHIR R4
    BUS->>FHIR: Transformar información de urgencia
    FHIR-->>BUS: Bundle document canónico
    BUS->>TERM: Validar códigos y unidades
    TERM-->>BUS: Resultado terminológico
    BUS->>MPI: Validar Patient contra MPI/NID
    MPI-->>BUS: Identidad validada
    BUS->>BUS: Validar perfiles DAU y referencias
    BUS->>REP: Publicar Bundle document y PDF, si existe
    REP-->>POR: Datos disponibles
    BUS-->>HIS: ACK / OperationOutcome
</div>

## Información enviada por el HIS/RCE

| Grupo | Información |
|---|---|
| Admisión | Identificador DAU, código DEIS, fecha de admisión, procedencia y medio de llegada. |
| Paciente | RUN, pasaporte u otro identificador, nombre, fecha de nacimiento, sexo y contacto. |
| Categorización | Sistema utilizado, nivel asignado, fecha/hora y profesional. |
| Signos vitales | Frecuencia cardíaca, presión arterial, temperatura, frecuencia respiratoria, saturación, dolor, Glasgow y glicemia. |
| Atención clínica | Anamnesis, examen físico, antecedentes, alergias y evolución clínica. |
| Diagnósticos | Hipótesis, diagnóstico principal, diagnósticos secundarios, código y descripción. |
| Solicitudes | Exámenes de laboratorio, imagenología, procedimientos o derivaciones solicitadas durante el episodio. |
| Tratamientos | Medicamentos administrados, indicaciones y procedimientos realizados. |
| Egreso | Condición, destino, hospitalización, traslado, abandono, NEA o fallecimiento. |
| Documento | Autor, fecha de emisión y PDF cuando corresponda. |

## Caso de uso 1: Envío FHIR directo

1. El HIS/RCE registra la atención de urgencia.
2. Construye un `Bundle.type = document`.
3. Incluye una `Composition` como primera entrada.
4. Incluye `Patient`, `Encounter`, `Condition`, `Observation`, `Procedure`, `ServiceRequest`, medicamentos y `DocumentReference` cuando corresponda.
5. Envía el documento al Bus mediante HTTP.
6. El Bus valida la estructura, terminología e identidad del paciente.
7. El Bus publica el documento y responde con el resultado de la operación.

## Caso de uso 2: Envío HL7 v2

1. El HIS/RCE genera los mensajes HL7 v2 acordados.
2. El Bus recibe los segmentos definidos para admisión, atención, solicitudes, tratamientos y egreso.
3. El Bus transforma la información a FHIR R4.
4. El Servicio Terminológico valida los códigos.
5. MPI/NID valida la identidad del paciente.
6. El Bus construye el `Bundle.type = document`.
7. El Bus publica el documento y responde con `ACK`, `NACK` u `OperationOutcome`, según corresponda.

## Caso de uso 3: Publicación del documento DAU

El repositorio conserva:

- `Bundle` documental.
- `Composition`.
- Recursos clínicos referenciados.
- Solicitudes de laboratorio o imagenología realizadas durante la atención.
- PDF mediante `DocumentReference`, si fue generado.
- Identificador del mensaje de origen.
- Resultado de las validaciones realizadas.

El documento DAU no contiene informes ni resultados de laboratorio o imagenología. Esos resultados pertenecen a sus respectivos flujos y guías de implementación.

## Respuesta del Bus

| Resultado | Respuesta |
|---|---|
| Documento válido | Respuesta HTTP exitosa o `ACK`. |
| Error estructural | `OperationOutcome` o `NACK`. |
| Código inválido | Rechazo con detalle terminológico. |
| Identidad no validada | Documento retenido y respuesta de conciliación. |
