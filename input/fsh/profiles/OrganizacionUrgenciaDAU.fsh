Profile: OrganizacionUrgenciaDAU
Parent: CoreOrganizacionCl
Id: organizacion-urgencia-dau
Title: "Organización participante en atención de urgencia"
Description: "Perfil utilizado para representar los establecimientos de salud y otras organizaciones participantes en la atención de urgencia y en el intercambio del documento clínico DAU. Extiende el perfil de organización definido en CL-Core (hl7.fhir.cl.clcore) en lugar del recurso base Organization de FHIR R4, manteniendo la alineación con el portafolio de Guías de Implementación de MINSAL."

* identifier 1..* MS
* active 1..1 MS
* type 1..* MS
* name 1..1 MS
* telecom 0..* MS
* address 0..* MS
* partOf 0..1 MS
* partOf only Reference(OrganizacionUrgenciaDAU)
* endpoint 0..* MS