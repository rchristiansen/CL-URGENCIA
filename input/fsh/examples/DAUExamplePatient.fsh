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
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#VR
* subject = Reference(DAUExamplePatient)
* period.start = "2026-09-09T10:00:00-03:00"
* period.end = "2026-09-09T12:00:00-03:00"
* type.extension[0].url = "https://hl7chile.cl/fhir/ig/clcore/StructureDefinition/TiposEncuentro"
* type.extension[0].valueCode = #PR
* type[0].coding[0].system = "https://hl7chile.cl/fhir/ig/clcore/CodeSystem/CSTiposEncuentroCL"
* type[0].coding[0].code = #PR
* serviceType.extension[0].url = "https://hl7chile.cl/fhir/ig/clcore/StructureDefinition/TiposServicio"
* serviceType.extension[0].valueCode = #nutINTA
* serviceType.coding[0].system = "https://hl7chile.cl/fhir/ig/clcore/CodeSystem/CSCodigoServicio"
* serviceType.coding[0].code = #nutINTA
* participant[0].type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
* participant[0].type[0].coding[0].code = #PPRF
* participant[0].individual = Reference(DAUExamplePractitioner)
* length = 120 'min'
* reasonCode.text = "Dolor abdominal"
* serviceProvider = Reference(DAUExampleOrganization)
