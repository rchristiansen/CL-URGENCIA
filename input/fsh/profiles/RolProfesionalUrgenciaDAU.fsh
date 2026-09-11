Profile: RolProfesionalUrgenciaDAU
Parent: PractitionerRole
Id: rol-profesional-urgencia-dau
Title: "Rol del profesional en urgencia"
Description: "Participación de un profesional y su organización en la atención de urgencia."
* ^url = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/StructureDefinition/rol-profesional-urgencia-dau"
* ^status = #draft
* ^version = "0.1.0"
* practitioner 1..1 MS
* practitioner only Reference(ProfesionalUrgenciaDAU)
* organization 1..1 MS
* organization only Reference(OrganizacionUrgenciaDAU)
* code 0..* MS
