Profile: DauEncounter
Parent: EncounterCL
Id: dau-encounter
Title: "DAU - Encuentro de Atención de Urgencia"
Description: "Perfil utilizado para representar el episodio de atención de urgencia, desde la admisión del paciente hasta el alta. Define los datos esenciales del encuentro clínico y se basa en el perfil EncounterCL de CL-Core (hl7.fhir.cl.clcore), adaptándolo al contexto presencial de urgencia establecido por la Guía de Implementación DAU."
* ^url = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/StructureDefinition/dau-encounter"
* ^status = #draft
* ^version = "0.1.0"


* identifier 1..*
* identifier ^short = "Identificador de la atención de urgencia"
* identifier.system 1..1
* identifier.value 1..1

* status 1..1
* status ^short = "Estado de la atención de urgencia"

* subject 1..1
* subject only Reference(DauPatient)
* subject ^short = "Paciente atendido en urgencia"

* period 1..1
* period.start 1..1
* period.start ^short = "Fecha y hora de ingreso"
* period.end 1..1
* period.end ^short = "Fecha y hora de término de la atención"

* reasonCode 1..1
* reasonCode ^short = "Motivo de consulta"

* diagnosis 0..*
* diagnosis ^short = "Diagnósticos registrados durante la atención"
* diagnosis.condition 1..1
* diagnosis.condition only Reference(DiagnosticoUrgenciaDAU)

* hospitalization 0..1
* hospitalization.dischargeDisposition 0..1
* hospitalization.dischargeDisposition ^short = "Destino o condición de egreso"

* serviceProvider 1..1
* serviceProvider only Reference(OrganizacionUrgenciaDAU)
* serviceProvider ^short = "Establecimiento de salud responsable"
