Profile: OrganizacionUrgenciaDAU
Parent: CoreOrganizacionCl
Id: organizacion-urgencia-dau
Title: "Organización participante en atención de urgencia"
Description: "Establecimiento, Servicio de Salud o unidad participante en el DAU."

* identifier 1..* MS
* active 1..1 MS
* type 1..* MS
* name 1..1 MS
* telecom 0..* MS
* address 0..* MS
* partOf 0..1 MS
* partOf only Reference(OrganizacionUrgenciaDAU)
* endpoint 0..* MS