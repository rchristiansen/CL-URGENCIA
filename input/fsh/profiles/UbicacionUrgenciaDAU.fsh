Profile: UbicacionUrgenciaDAU
Parent: Location
Id: ubicacion-urgencia-dau
Title: "Ubicación de atención de urgencia"
Description: "Box, unidad o servicio donde se desarrolla la atención de urgencia."
* ^url = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/StructureDefinition/ubicacion-urgencia-dau"
* ^status = #draft
* ^version = "0.1.0"
* status 1..1 MS
* name 1..1 MS
* managingOrganization 1..1 MS
* managingOrganization only Reference(OrganizacionUrgenciaDAU)
