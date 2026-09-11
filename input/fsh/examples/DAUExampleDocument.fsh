Instance: DAUExampleOrganization
InstanceOf: OrganizacionUrgenciaDAU
Usage: #example
Title: "Establecimiento de ejemplo DAU"
* identifier[0].system = "https://deis.minsal.cl/establecimientos"
* identifier[0].value = "100101"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov
* name = "Establecimiento de Salud de Ejemplo"

Instance: DAUExamplePractitioner
InstanceOf: ProfesionalUrgenciaDAU
Usage: #example
Title: "Profesional de ejemplo DAU"
* identifier[0].system = "https://hl7chile.cl/fhir/ig/nid/identificadores-profesionales"
* identifier[0].value = "PROF-EXAMPLE-001"
* name[0].given[0] = "Ana"
* name[0].family = "Pérez"
* gender = #female

Instance: DAUExamplePractitionerRole
InstanceOf: RolProfesionalUrgenciaDAU
Usage: #example
Title: "Rol profesional de ejemplo DAU"
* practitioner = Reference(DAUExamplePractitioner)
* organization = Reference(DAUExampleOrganization)

Instance: DAUExampleComposition
InstanceOf: ComposicionDocumentoDAU
Usage: #example
Title: "Composition de ejemplo DAU"
* identifier.system = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/documentos"
* identifier.value = "DAU-2026-000001"
* status = #final
* type = TipoDocumentoDAU#dau
* subject = Reference(DAUExamplePatient)
* encounter = Reference(DAUExampleEncounter)
* date = "2026-09-09T12:30:00-03:00"
* author = Reference(DAUExamplePractitionerRole)
* title = "Datos de Atención de Urgencia"
* custodian = Reference(DAUExampleOrganization)
* section[0].code = SeccionesDAU#resumen
* section[0].title = "Resumen de la atención"
* section[0].text.status = #generated
* section[0].text.div = "<div>Atención de urgencia de ejemplo.</div>"
* section[0].entry[0] = Reference(DAUExampleEncounter)
* section[1].code = SeccionesDAU#admision
* section[1].title = "Admisión e identificación"
* section[1].entry[0] = Reference(DAUExamplePatient)

Instance: DAUExampleBundle
InstanceOf: BundleDocumentoDAU
Usage: #example
Title: "Bundle documental DAU de ejemplo"
* identifier.system = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/documentos"
* identifier.value = "DAU-2026-000001"
* type = #document
* timestamp = "2026-09-09T12:30:00-03:00"
* entry[composition].fullUrl = "urn:uuid:composition-dau-example"
* entry[composition].resource = DAUExampleComposition
* entry[1].fullUrl = "urn:uuid:patient-dau-example"
* entry[1].resource = DAUExamplePatient
* entry[2].fullUrl = "urn:uuid:encounter-dau-example"
* entry[2].resource = DAUExampleEncounter
* entry[3].fullUrl = "urn:uuid:organization-dau-example"
* entry[3].resource = DAUExampleOrganization
* entry[4].fullUrl = "urn:uuid:practitioner-dau-example"
* entry[4].resource = DAUExamplePractitioner
* entry[5].fullUrl = "urn:uuid:practitioner-role-dau-example"
* entry[5].resource = DAUExamplePractitionerRole
