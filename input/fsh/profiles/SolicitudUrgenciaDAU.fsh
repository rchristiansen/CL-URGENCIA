Profile: SolicitudUrgenciaDAU
Parent: ServiceRequest
Id: solicitud-urgencia-dau
Title: "Solicitud clínica de urgencia"
Description: "Solicitud de laboratorio, imagenología, procedimiento o derivación asociada al DAU."
* ^url = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/StructureDefinition/solicitud-urgencia-dau"
* ^status = #draft
* ^version = "0.1.0"
* status 1..1 MS
* intent 1..1 MS
* code 1..1 MS
* subject 1..1 MS
* subject only Reference(DauPatient)
* encounter 1..1 MS
* encounter only Reference(DauEncounter)
* authoredOn 1..1 MS
* requester 0..1 MS
* requester only Reference(ProfesionalUrgenciaDAU or RolProfesionalUrgenciaDAU)
