Profile: ComposicionDocumentoDAU
Parent: Composition
Id: composicion-documento-dau
Title: "DAU - Composition del documento clínico"
Description: "Composition que organiza las secciones y recursos del documento de atención de urgencia."
* ^url = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/StructureDefinition/composicion-documento-dau"
* ^status = #draft
* ^version = "0.1.0"
* identifier 1..1 MS
* status 1..1 MS
* type 1..1 MS
* type from VSTipoDocumentoDAU (required)
* subject 1..1 MS
* subject only Reference(DauPatient)
* encounter 1..1 MS
* encounter only Reference(DauEncounter)
* date 1..1 MS
* author 1..* MS
* author only Reference(ProfesionalUrgenciaDAU or RolProfesionalUrgenciaDAU)
* title 1..1 MS
* custodian 1..1 MS
* custodian only Reference(OrganizacionUrgenciaDAU)
* section 1..* MS
* section.code 1..1 MS
* section.code from VSSeccionesDAU (required)
* section.title 1..1 MS
* section.text 0..1 MS
* section.entry 0..* MS
