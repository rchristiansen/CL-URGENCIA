Correspondencia entre los campos del **Conjunto Mínimo Básico de Datos (CMBD) de Urgencia** del DEIS y los elementos FHIR de esta guía. Permite que un mismo mensaje sirva a la continuidad de la atención y a la estadística nacional.

**Evento** indica la primera transacción en que se informa el dato; las transacciones siguientes lo repiten si sigue vigente.

Paciente, profesional y establecimiento usan directamente los perfiles del [NID 0.4.6](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/artifacts.html); los códigos de previsión, tramo FONASA, leyes previsionales y título profesional también son los del NID. Los códigos del NID no llevan cero a la izquierda: `01 FONASA` del CMBD se envía como `1`.

Convenciones de formato:

- Fecha y hora del CMBD (`DDMMAAAA` + `HH:MM`) se envían como un solo `dateTime` ISO 8601 con zona horaria: `2026-09-09T10:00:00-03:00`.
- Los códigos del CMBD se envían tal cual, con el `system` del CodeSystem correspondiente.

## Identificación del prestador

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| COD SS | `Organization.partOf` (referencia al Servicio de Salud) | Admisión |
| COD ESTAB | `Organization.identifier.value` (system `https://interoperabilidad.minsal.cl/fhir/ig/tei/CodeSystem/CSEstablecimientoDestino`) | Admisión |

## Identificación del DAU

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| ID DAU | `Encounter.identifier.value` | Admisión |
| ID ATENCION | `Encounter.identifier` (segundo identificador, si difiere del ID DAU) | Admisión |

## Datos del paciente

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| ID_BD_PERSONAS | `Patient.identifier` (system MPI). Lo agrega el Bus al resolver identidad. | — |
| ID PACIENTE | `Patient.identifier` con tipo `12` Número de ficha clínica sistema local | Admisión |
| RUN + DV | `Patient.identifier.value` = `RUN-DV`, tipo `01` RUN | Admisión |
| TIPO_IDENTIFICACION | `Patient.identifier.type` (ver tabla de equivalencias) | Admisión |
| FECHA NACIMIENTO | `Patient.birthDate` | Admisión |
| SEXO | `Patient.extension[SexoBiologico]` ([CL-Core CSSexoListadoDeis](https://hl7chile.cl/fhir/ig/clcore/CodeSystem-CSSexoListadoDeis.html)) y `Patient.gender` | Admisión |
| TELÉFONO CONTACTO | `Patient.telecom` (`system = phone`) | Admisión |

Equivalencia TIPO_IDENTIFICACION → CL-Core `CSTipoIdentificador`:

| CMBD | CL-Core |
|---|---|
| 1 RUN | `01` RUN |
| 2 Pasaporte | `05` PPN |
| 3 RUN materno | `03` RUN Madre |
| 4 Sin RUN | `12` Número de ficha clínica sistema local |
| 9 Otro | `14` Otro |

Equivalencia SEXO → `Patient.gender`: `01 → male`, `02 → female`, `03 → other`, `99 → unknown`.

Datos que exige `MINSALPaciente` aunque el CMBD no los incluye: identidad de género, nacionalidad, país de origen, país emisor del documento, teléfono, fecha de nacimiento, sexo y si está fallecido.

## Previsión

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| PREVISIÓN | `Encounter.extension[prevision].extension[prevision]` ([NID CSPrevision](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/CodeSystem-CSPrevision.html)) | Admisión |
| CLASIFICACIÓN BENEFICIARIO FONASA | `Encounter.extension[prevision].extension[tramoFonasa]` ([NID CSTramosFONASA](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/CodeSystem-CSTramosFONASA.html)) | Admisión |
| LEYES PREVISIONALES | `Encounter.extension[leyPrevisional]` (0..*) ([NID CSLeyPrevisionales](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/CodeSystem-CSLeyPrevisionales.html)) | Admisión |

## Admisión

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| FECHA_ADM + HORA_ADM | `Encounter.period.start` | Admisión |
| PROCEDENCIA DEL PACIENTE | `Encounter.hospitalization.admitSource` ([CSProcedencia](CodeSystem-procedencia.html)) | Admisión |
| UNIDAD DE ATENCIÓN | `Encounter.serviceType` ([CSUnidadAtencion](CodeSystem-unidad-atencion.html)) | Admisión |
| MOT_CONSULTA | `Encounter.reasonCode.text` | Admisión |
| CLASIFICACIÓN DE LA CONSULTA | `Encounter.extension[clasificacionConsulta]` | Admisión |
| LLEGADA | `Encounter.hospitalization.extension[medioLlegada]` ([CSMedioLlegada](CodeSystem-medio-llegada.html)) | Admisión |

## Atención clínica

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| FECHA_ATENCION + HORA_ATENCION | `Condition.recordedDate` de la hipótesis diagnóstica | Alta / Abandono |
| HIPOTESIS_DIAG | `Condition.code.text` con `verificationStatus = provisional`, referenciada en `Encounter.diagnosis` con `use = AD` | Alta / Abandono |
| COD_DIAG + TIPO_COD_DIAG | `Condition.code.coding` (el `system` indica el tipo de codificación) | Alta / Abandono |
| INDICACIÓN DE FÁRMACOS | Un `MedicationRequest` por fármaco: `medicationCodeableConcept.text` + `dosageInstruction.text` | Alta |
| ID RECETA | `MedicationRequest.groupIdentifier` | Alta |
| SOLIC_MEDIOS_DIAG / DESCRIP_MEDIOS_DIAG | No se envía estructurado; queda en el PDF | — |

Equivalencia TIPO_COD_DIAG → `Condition.code.coding.system`:

| CMBD | system |
|---|---|
| 01 CIE-10 | `http://hl7.org/fhir/sid/icd-10` |
| 02 TAPSA | Pendiente de definir por el DEIS |
| 03 SNOMED | `http://snomed.info/sct` |
| 04 Otros | Solo `Condition.code.text` |

## Alta médica

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| FECHA_ALTA + HORA_ALTA | `Encounter.period.end` | Alta |
| DIAG_FINAL | `Condition.code.text`, referenciada en `Encounter.diagnosis` con `use = DD` | Alta |
| TIPO_DIAG | `Condition.verificationStatus`: `01 → provisional`, `02 → confirmed`, `03 → refuted` | Alta |
| COD_DIAG + TIPO_COD_DIAG | `Condition.code.coding` | Alta |
| CONDICIÓN AL CIERRE | Se deduce del destino: `03 Fallecido` → fallecido; otro → vivo | Alta |
| PRONÓSTICO MÉDICO LEGAL | `Encounter.extension[pronosticoMedicoLegal]` | Alta |
| DESTINO_ALTA | `Encounter.hospitalization.dischargeDisposition` ([CSDestinoAlta](CodeSystem-destino-alta.html)) | Alta |
| GES | `Condition.extension[ges]` | Alta |
| PERTINENCIA | `Encounter.extension[pertinencia]` | Alta |

## Profesional que da el alta

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| ID PROFESIONAL ALTA | `Encounter.participant.individual` → `Practitioner` (`participant.type = DIS`) | Alta |
| RUN + DV | `Practitioner.identifier[run]` | Alta |
| TÍTULO PROFESIONAL | `Practitioner.qualification[TituloProfesional].code` ([NID CSTituloProfesional](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/CodeSystem-CSTituloProfesional.html)) | Alta |
| ESPECIALIDAD MÉDICA | `Practitioner.qualification[EspecialidadMedica].code` ([NID CSEspecialidadMed](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/CodeSystem-CSEspecialidadMed.html)) | Alta |

## Otros

| Campo CMBD | Elemento FHIR | Evento |
|---|---|---|
| ABANDONO | Transacción de abandono + `Encounter.hospitalization.dischargeDisposition` ([CSTipoAbandono](CodeSystem-tipo-abandono.html)) | Abandono |

## Campos no incluidos

Los campos de **categorización** (CATEGORIZACIÓN ESI, PRIMERA_CATE, ULTIMA_CATE, fechas, horas, profesionales y número de categorizaciones) quedan fuera del alcance de esta versión, por decisión de la versión 0.1.2.
