Instance: DAUExamplePatient
InstanceOf: DauPatient
Usage: #example
Title: "Paciente de ejemplo DAU"
Description: "Paciente utilizado como ejemplo para la Guía de Implementación DAU."

* identifier[0].system = "https://ejemplo.cl/identificadores/pacientes"
* identifier[0].value = "PACIENTE-URGENCIA-001"
* name[NombreOficial].use = #official
* name[NombreOficial].given[0] = "María"
* name[NombreOficial].family = "Carmona"
* gender = #female
* birthDate = "1975-04-12"

Instance: DAUExampleEncounter
InstanceOf: DauEncounter
Usage: #example
Title: "Atención de urgencia de ejemplo"
Description: "Encuentro de atención de urgencia utilizado como ejemplo."

* identifier[0].system = "http://example/fhir/sid/dau"
* identifier[0].value = "DAU-2026-000001"
* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#EMER
* subject = Reference(DAUExamplePatient)
* period.start = "2026-09-09T10:00:00-03:00"
* period.end = "2026-09-09T12:00:00-03:00"
* reasonCode.text = "Dolor abdominal"
* serviceProvider = Reference(DAUExampleOrganization)
