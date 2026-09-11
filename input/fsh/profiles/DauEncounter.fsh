Profile: DauEncounter
Parent: Encounter
Id: dau-encounter
Title: "DAU - Encuentro de Atención de Urgencia"
Description: "Perfil que representa una atención de urgencia dentro del proceso de Datos de Atención de Urgencia (DAU)."
* ^url = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/StructureDefinition/dau-encounter"
* ^status = #draft
* ^version = "0.1.0"
* ^publisher = "Hospital Regional de Arica Dr. Juan Noé Crevani"

* identifier 1..*
* identifier ^short = "Identificador de la atención de urgencia"
* identifier.system 1..1
* identifier.value 1..1

* status 1..1
* status ^short = "Estado de la atención de urgencia"

* class 1..1
* class ^short = "Clasificación del tipo de atención"
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#EMER

* subject 1..1
* subject only Reference(DauPatient)
* subject ^short = "Paciente atendido en urgencia"

* period 1..1
* period.start 1..1
* period.start ^short = "Fecha y hora de ingreso"
* period.end 0..1
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
