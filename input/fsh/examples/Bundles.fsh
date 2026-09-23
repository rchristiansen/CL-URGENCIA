// Escenario 1: María Carmona es admitida (10:00) y recibe el alta a domicilio (12:30).
// Escenario 2: la misma paciente vuelve otro día y se retira sin alta (fuga).
//
// Dentro de una transacción los recursos se referencian por su fullUrl (urn:uuid).
// El servidor resuelve cada PUT condicional y reescribe esas referencias con el id real.
//
// EpisodioDAU123EstadoAdmision y EpisodioDAU123EstadoAlta NO son dos encuentros:
// son el mismo Encounter (ID DAU DAU-2026-000123) enviado en dos momentos.
// El servidor crea el recurso con la admisión y lo actualiza con el alta.

// ─────────────────────── Identificadores compartidos ───────────────────────

RuleSet: RefPaciente(elemento)
* {elemento}.reference = "urn:uuid:6f1c2a10-0001-4000-8000-000000000001"

RuleSet: RefEstablecimiento(elemento)
* {elemento}.reference = "urn:uuid:6f1c2a10-0002-4000-8000-000000000002"

RuleSet: RefProfesional(elemento)
* {elemento}.reference = "urn:uuid:6f1c2a10-0004-4000-8000-000000000004"

RuleSet: EntradasActores
* entry[paciente].fullUrl = "urn:uuid:6f1c2a10-0001-4000-8000-000000000001"
* entry[paciente].resource = PacienteUrgenciaEj
* entry[paciente].request.method = #PUT
* entry[paciente].request.url = "Patient?identifier=urn:oid:2.16.840.1.113883.2.22.1.152.787300|11111111-1"
* entry[establecimiento][0].fullUrl = "urn:uuid:6f1c2a10-0002-4000-8000-000000000002"
* entry[establecimiento][0].resource = EstablecimientoUrgenciaEj
* entry[establecimiento][0].request.method = #PUT
* entry[establecimiento][0].request.url = "Organization?identifier=https://interoperabilidad.minsal.cl/fhir/ig/tei/CodeSystem/CSEstablecimientoDestino|112100"

RuleSet: DatosAdmisionEpisodio1
* identifier[0].system = "https://hospital-ejemplo.cl/fhir/sid/dau"
* identifier[0].value = "DAU-2026-000123"
* class = $v3ActCode#EMER
* serviceType = CSUnidadAtencion#02 "Atención de adulto"
* insert RefPaciente(subject)
* period.start = "2026-09-09T10:00:00-03:00"
* reasonCode.text = "Dolor abdominal de 12 horas de evolución"
* hospitalization.admitSource = CSProcedencia#6 "Espontáneo"
* hospitalization.extension[medioLlegada].valueCodeableConcept = CSMedioLlegada#6 "Vehículo particular"
* extension[prevision].extension[prevision].valueCodeableConcept = $CSPrevisionNID#1 "FONASA"
* extension[prevision].extension[tramoFonasa].valueCodeableConcept = $CSTramosFONASA#B "FONASA B"
* extension[leyPrevisional].valueCodeableConcept = $CSLeyPrevisionales#96 "Ninguna"
* extension[clasificacionConsulta].valueCodeableConcept = CSClasificacionConsulta#09 "Otros"
* insert RefEstablecimiento(serviceProvider)

// ─────────────────────────────── Admisión ───────────────────────────────

Instance: EpisodioDAU123EstadoAdmision
InstanceOf: EncuentroUrgenciaAdmision
Usage: #inline
* insert DatosAdmisionEpisodio1
* status = #in-progress

Instance: BundleAdmisionEj
InstanceOf: BundleAdmisionUrgencia
Usage: #example
Title: "Bundle de admisión"
Description: "Admisión de la paciente a urgencia: abre el episodio DAU-2026-000123."
* type = #transaction
* insert EntradasActores
* entry[encuentro].fullUrl = "urn:uuid:6f1c2a10-0010-4000-8000-000000000010"
* entry[encuentro].resource = EpisodioDAU123EstadoAdmision
* entry[encuentro].request.method = #PUT
* entry[encuentro].request.url = "Encounter?identifier=https://hospital-ejemplo.cl/fhir/sid/dau|DAU-2026-000123"

// ───────────────────────────────── Alta ─────────────────────────────────

Instance: EpisodioDAU123EstadoAlta
InstanceOf: EncuentroUrgenciaAlta
Usage: #inline
* insert DatosAdmisionEpisodio1
* status = #finished
* period.end = "2026-09-09T12:30:00-03:00"
* participant[0].type = $v3ParticipationType#DIS "discharger"
* insert RefProfesional(participant[0].individual)
* diagnosis[0].condition.reference = "urn:uuid:6f1c2a10-0020-4000-8000-000000000020"
* diagnosis[0].use = $diagnosisRole#DD "Discharge diagnosis"
* diagnosis[0].rank = 1
* hospitalization.dischargeDisposition = CSDestinoAlta#05 "Domicilio"
* hospitalization.destination.reference = "urn:uuid:6f1c2a10-0003-4000-8000-000000000003"
* extension[pertinencia].valueBoolean = true
* extension[pronosticoMedicoLegal].valueCodeableConcept = CSPronosticoMedicoLegal#04 "Sin lesiones"

Instance: DiagnosticoAltaEj
InstanceOf: DiagnosticoUrgencia
Usage: #inline
* identifier[0].system = "https://hospital-ejemplo.cl/fhir/sid/diagnosticos"
* identifier[0].value = "DG-2026-88001"
* clinicalStatus = $conditionClinical#active
* verificationStatus = $conditionVerStatus#confirmed
* code = $icd10#K29.7 "Gastritis, unspecified"
* code.text = "Gastritis aguda"
* insert RefPaciente(subject)
* encounter.reference = "urn:uuid:6f1c2a10-0011-4000-8000-000000000011"
* recordedDate = "2026-09-09T12:20:00-03:00"
* insert RefProfesional(recorder)
* extension[ges].valueBoolean = false

Instance: IndicacionMedicamentoEj
InstanceOf: IndicacionMedicamentoUrgencia
Usage: #inline
* identifier[0].system = "https://hospital-ejemplo.cl/fhir/sid/indicaciones"
* identifier[0].value = "IND-2026-5501-1"
* status = #active
* intent = #order
* groupIdentifier.system = "https://hospital-ejemplo.cl/fhir/sid/recetas"
* groupIdentifier.value = "REC-2026-5501"
* medicationCodeableConcept.text = "Omeprazol 20 mg cápsula"
* insert RefPaciente(subject)
* encounter.reference = "urn:uuid:6f1c2a10-0011-4000-8000-000000000011"
* authoredOn = "2026-09-09T12:25:00-03:00"
* insert RefProfesional(requester)
* dosageInstruction[0].text = "1 cápsula cada 12 horas por 14 días"

Instance: DocumentoAltaEj
InstanceOf: DocumentoUrgencia
Usage: #inline
* masterIdentifier.system = "https://hospital-ejemplo.cl/fhir/sid/documentos"
* masterIdentifier.value = "DOC-DAU-2026-000123"
* status = #current
* type = $loinc#59258-4
* insert RefPaciente(subject)
* date = "2026-09-09T12:30:00-03:00"
* insert RefProfesional(author[0])
* insert RefEstablecimiento(custodian)
* content[0].attachment.contentType = #application/pdf
* content[0].attachment.url = "https://his.hospital-ejemplo.cl/documentos/DAU-2026-000123.pdf"
* content[0].attachment.title = "Dato de Atención de Urgencia DAU-2026-000123"
* content[0].attachment.creation = "2026-09-09T12:30:00-03:00"
* context.encounter[0].reference = "urn:uuid:6f1c2a10-0011-4000-8000-000000000011"

Instance: BundleAltaEj
InstanceOf: BundleAltaUrgencia
Usage: #example
Title: "Bundle de alta"
Description: "Alta a domicilio del episodio DAU-2026-000123 con diagnóstico, indicación de medicamento y PDF."
* type = #transaction
* insert EntradasActores
* entry[establecimiento][1].fullUrl = "urn:uuid:6f1c2a10-0003-4000-8000-000000000003"
* entry[establecimiento][1].resource = EstablecimientoDestinoEj
* entry[establecimiento][1].request.method = #PUT
* entry[establecimiento][1].request.url = "Organization?identifier=https://interoperabilidad.minsal.cl/fhir/ig/tei/CodeSystem/CSEstablecimientoDestino|112307"
* entry[profesional][0].fullUrl = "urn:uuid:6f1c2a10-0004-4000-8000-000000000004"
* entry[profesional][0].resource = ProfesionalUrgenciaEj
* entry[profesional][0].request.method = #PUT
* entry[profesional][0].request.url = "Practitioner?identifier=urn:oid:2.16.840.1.113883.2.22.1.152.787300|22222222-2"
* entry[encuentro].fullUrl = "urn:uuid:6f1c2a10-0011-4000-8000-000000000011"
* entry[encuentro].resource = EpisodioDAU123EstadoAlta
* entry[encuentro].request.method = #PUT
* entry[encuentro].request.url = "Encounter?identifier=https://hospital-ejemplo.cl/fhir/sid/dau|DAU-2026-000123"
* entry[diagnostico][0].fullUrl = "urn:uuid:6f1c2a10-0020-4000-8000-000000000020"
* entry[diagnostico][0].resource = DiagnosticoAltaEj
* entry[diagnostico][0].request.method = #PUT
* entry[diagnostico][0].request.url = "Condition?identifier=https://hospital-ejemplo.cl/fhir/sid/diagnosticos|DG-2026-88001"
* entry[medicamento][0].fullUrl = "urn:uuid:6f1c2a10-0030-4000-8000-000000000030"
* entry[medicamento][0].resource = IndicacionMedicamentoEj
* entry[medicamento][0].request.method = #PUT
* entry[medicamento][0].request.url = "MedicationRequest?identifier=https://hospital-ejemplo.cl/fhir/sid/indicaciones|IND-2026-5501-1"
* entry[documento].fullUrl = "urn:uuid:6f1c2a10-0040-4000-8000-000000000040"
* entry[documento].resource = DocumentoAltaEj
* entry[documento].request.method = #PUT
* entry[documento].request.url = "DocumentReference?identifier=https://hospital-ejemplo.cl/fhir/sid/documentos|DOC-DAU-2026-000123"

// ─────────────────────────────── Abandono ───────────────────────────────

Instance: EpisodioDAU456EstadoAbandono
InstanceOf: EncuentroUrgenciaAbandono
Usage: #inline
* identifier[0].system = "https://hospital-ejemplo.cl/fhir/sid/dau"
* identifier[0].value = "DAU-2026-000456"
* status = #finished
* class = $v3ActCode#EMER
* serviceType = CSUnidadAtencion#02 "Atención de adulto"
* insert RefPaciente(subject)
* period.start = "2026-09-20T21:10:00-03:00"
* period.end = "2026-09-20T23:05:00-03:00"
* reasonCode.text = "Cefalea intensa"
* diagnosis[0].condition.reference = "urn:uuid:6f1c2a10-0021-4000-8000-000000000021"
* diagnosis[0].use = $diagnosisRole#AD "Admission diagnosis"
* hospitalization.admitSource = CSProcedencia#6 "Espontáneo"
* hospitalization.dischargeDisposition = CSTipoAbandono#2 "Abandono durante la atención médica (fuga)"
* insert RefEstablecimiento(serviceProvider)

Instance: HipotesisAbandonoEj
InstanceOf: DiagnosticoUrgencia
Usage: #inline
* identifier[0].system = "https://hospital-ejemplo.cl/fhir/sid/diagnosticos"
* identifier[0].value = "DG-2026-90112"
* verificationStatus = $conditionVerStatus#provisional
* code = $icd10#R51 "Headache"
* code.text = "Cefalea en estudio"
* insert RefPaciente(subject)
* encounter.reference = "urn:uuid:6f1c2a10-0012-4000-8000-000000000012"
* recordedDate = "2026-09-20T22:00:00-03:00"

Instance: BundleAbandonoEj
InstanceOf: BundleAbandonoUrgencia
Usage: #example
Title: "Bundle de abandono (fuga)"
Description: "Cierre del episodio DAU-2026-000456 porque la paciente se retiró sin alta médica."
* type = #transaction
* insert EntradasActores
* entry[encuentro].fullUrl = "urn:uuid:6f1c2a10-0012-4000-8000-000000000012"
* entry[encuentro].resource = EpisodioDAU456EstadoAbandono
* entry[encuentro].request.method = #PUT
* entry[encuentro].request.url = "Encounter?identifier=https://hospital-ejemplo.cl/fhir/sid/dau|DAU-2026-000456"
* entry[diagnostico][0].fullUrl = "urn:uuid:6f1c2a10-0021-4000-8000-000000000021"
* entry[diagnostico][0].resource = HipotesisAbandonoEj
* entry[diagnostico][0].request.method = #PUT
* entry[diagnostico][0].request.url = "Condition?identifier=https://hospital-ejemplo.cl/fhir/sid/diagnosticos|DG-2026-90112"
