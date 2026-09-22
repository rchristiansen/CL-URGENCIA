# Casos de uso

## Objetivo

Describir el flujo mediante el cual el HIS/RCE envía la información de una atención de urgencia al Bus de Interoperabilidad para validación y publicación.

## Actores

| Actor | Rol |
|---|---|
| Establecimiento de origen | Registra y envía la atención de urgencia. |
| HIS / RCE | Genera la información de admisión, atención, solicitudes y egreso. |
| Bus de Interoperabilidad | Coordina las validaciones y la publicación. |
| Servicio Terminológico | Valida códigos, catálogos y unidades de medida. |
| MPI | Valida la identidad del paciente y los identificadores nacionales. |
| Repositorio FHIR | Conserva el documento DAU y sus recursos. |
| Portal Ciudadano | Consume la información publicada. |

## Puntos de integración

1. **Intercambio mediante el Bus de Interoperabilidad:** el sistema clínico de origen, como el HIS o RCE, genera y envía la información de la atención de urgencia al Bus para su validación y publicación.

## Flujo general

<div class="mermaid">
sequenceDiagram
    participant HIS as HIS / RCE
    participant BUS as Bus de Interoperabilidad
    participant TERM as Servicio Terminológico
    participant MPI as MPI
    participant REP as Repositorio FHIR
    participant POR as Portal Ciudadano

    HIS->>BUS: Información de atención de urgencia
    BUS->>TERM: Validar códigos y unidades
    TERM-->>BUS: Resultado terminológico
    BUS->>MPI: Validar Patient contra MPI
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
| Sistema utilizado, nivel asignado, fecha/hora y profesional. |
| Evaluación clínica | Anamnesis, examen físico, antecedentes, alergias y evolución clínica. |
| Signos vitales | Frecuencia cardíaca, presión arterial, temperatura, frecuencia respiratoria, saturación, dolor, Glasgow y glicemia. |
| Egreso | Condición, destino, hospitalización, traslado o NEA. |
| Diagnósticos | Hipótesis, diagnóstico principal, diagnósticos secundarios, código y descripción. |
| Solicitudes | Exámenes de laboratorio, imagenología, procedimientos o derivaciones solicitadas durante el episodio. |
| Tratamientos | Medicamentos administrados, indicaciones y procedimientos realizados. |
| Egreso | Condición, destino, hospitalización, traslado o NEA. |
| Documento | Autor, fecha de emisión y PDF cuando corresponda. |

## Caso de uso 1: Envío FHIR directo

1. El HIS/RCE registra la atención de urgencia.
2. Construye un `Bundle.type = document`.
3. Incluye una `Composition` como primera entrada.
4. Incluye `Patient`, `Encounter`, `Condition`, `Observation`, `Procedure`, `ServiceRequest`, medicamentos y `DocumentReference` cuando corresponda.
5. Envía el documento al Bus mediante HTTP.
6. El Bus valida la estructura, terminología e identidad del paciente.
7. El Bus publica el documento y responde con el resultado de la operación.

## Caso de uso 2: Publicación del documento DAU

El repositorio conserva:

- `Bundle` documental.
- `Composition`.
- Recursos clínicos referenciados.
- Solicitudes de laboratorio o imagenología realizadas durante la atención.
- PDF mediante `DocumentReference`, si fue generado.
- Resultado de las validaciones realizadas.

El documento DAU no contiene informes ni resultados de laboratorio o imagenología. Esos resultados pertenecen a sus respectivos flujos y guías de implementación.

## Respuesta del Bus

| Resultado | Respuesta |
|---|---|
| Documento válido | Respuesta HTTP exitosa o `ACK`. |
| Error estructural | `OperationOutcome` o `NACK`. |
| Código inválido | Rechazo con detalle terminológico. |
| Identidad no validada | Documento retenido y respuesta de conciliación. |
