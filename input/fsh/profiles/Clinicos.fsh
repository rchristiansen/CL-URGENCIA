// Contenido clínico mínimo para la continuidad de la atención:
// qué tenía el paciente (diagnóstico), qué se le indicó (medicamentos)
// y dónde está el detalle completo (documento PDF).

Profile: DiagnosticoUrgencia
Parent: CoreDiagnosticoCl
Id: diagnostico-urgencia
Title: "Diagnóstico de urgencia"
Description: "Hipótesis o diagnóstico de egreso de la atención de urgencia. Basado en CoreDiagnosticoCl de CL-Core. El tipo de diagnóstico del CMBD (hipótesis, confirmado, descartado) se expresa con `verificationStatus`."
* ^status = #draft
* extension contains DiagnosticoGES named ges 0..1 MS
* identifier 1..* MS
* identifier ^short = "Identificador del diagnóstico en el HIS/RCE (llave del PUT condicional)"
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* verificationStatus 1..1 MS
* verificationStatus ^short = "provisional (hipótesis) | confirmed (confirmado) | refuted (descartado)"
* code 1..1 MS
* code from VSDiagnosticoUrgencia (preferred)
* code ^short = "Diagnóstico: CIE-10 preferente; texto libre si no está codificado"
* code.coding MS
* code.text 1..1 MS
* subject 1..1 MS
* subject only Reference($MINSALPaciente)
* encounter 1..1 MS
* encounter only Reference(EncuentroUrgencia)
* recordedDate MS
* recorder MS
* recorder only Reference($MINSALPrestadorProfesional)

Profile: IndicacionMedicamentoUrgencia
Parent: MedicationRequest
Id: indicacion-medicamento-urgencia
Title: "Indicación de medicamento al alta"
Description: "Medicamento indicado al alta de urgencia para que el paciente continúe su tratamiento. Acepta nombre genérico y posología en texto libre (CMBD: INDICACIÓN DE FÁRMACOS e ID RECETA)."
* ^status = #draft
* identifier 1..* MS
* identifier ^short = "Identificador de la indicación en el HIS/RCE (llave del PUT condicional)"
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* status 1..1 MS
* intent 1..1 MS
* intent = #order
* groupIdentifier MS
* groupIdentifier ^short = "ID de la receta"
* medication[x] 1..1 MS
* medication[x] only CodeableConcept
* medicationCodeableConcept.text 1..1 MS
* medicationCodeableConcept.text ^short = "Nombre genérico, concentración y presentación"
* subject 1..1 MS
* subject only Reference($MINSALPaciente)
* encounter 1..1 MS
* encounter only Reference(EncuentroUrgencia)
* authoredOn 1..1 MS
* requester 1..1 MS
* requester only Reference($MINSALPrestadorProfesional)
* dosageInstruction 1..* MS
* dosageInstruction.text 1..1 MS
* dosageInstruction.text ^short = "Dosis, frecuencia y duración (ej.: 1 comprimido cada 8 horas por 4 días)"

Profile: DocumentoUrgencia
Parent: DocumentReference
Id: documento-urgencia
Title: "Documento de la atención de urgencia"
Description: "Referencia al documento clínico de la atención (DAU o epicrisis de urgencia) en PDF. Permite a cualquier establecimiento de la red descubrir y descargar el detalle clínico completo."
* ^status = #draft
* masterIdentifier 1..1 MS
* masterIdentifier ^short = "Identificador único del documento (llave del PUT condicional)"
* masterIdentifier.system 1..1 MS
* masterIdentifier.value 1..1 MS
* status 1..1 MS
* status = #current
* type 1..1 MS
* type = $loinc#59258-4
* subject 1..1 MS
* subject only Reference($MINSALPaciente)
* date 1..1 MS
* author 1..* MS
* author only Reference($MINSALPrestadorProfesional or $MINSALPrestadorOrganizacional)
* custodian 1..1 MS
* custodian only Reference($MINSALPrestadorOrganizacional)
* content 1..1 MS
* content.attachment.contentType 1..1 MS
* content.attachment.contentType = #application/pdf
* content.attachment.url 1..1 MS
* content.attachment.url ^short = "URL donde el receptor puede obtener el PDF"
* content.attachment.title MS
* content.attachment.creation MS
* context 1..1 MS
* context.encounter 1..1 MS
* context.encounter only Reference(EncuentroUrgencia)
