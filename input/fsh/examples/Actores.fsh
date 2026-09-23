// Actores conformes a los perfiles del NID (hl7.fhir.cl.minsal.nid 0.4.6).

Instance: PacienteUrgenciaEj
InstanceOf: MINSALPaciente
Usage: #example
Title: "Paciente de urgencia"
Description: "Paciente chilena identificada por RUN, conforme a MINSALPaciente del NID."
* extension[IdentidadDeGenero].valueCodeableConcept = $CSIdentidaddeGenero#2 "Femenina"
* extension[SexoBiologico].valueCodeableConcept = http://hl7.org/fhir/administrative-gender#female "Female"
* extension[nacionalidad].valueCodeableConcept = $CodPais#152 "Chile"
* extension[PaisOrigen].valueCodeableConcept = $CodPais#152 "Chile"
* identifier[0].use = #official
* identifier[0].type = $CSTipoIdentificador#01 "RUN"
* identifier[0].type.extension[paisEmisionDocumento].valueCodeableConcept = $CodPais#152 "Chile"
* identifier[0].system = $sidRUN
* identifier[0].value = "11111111-1"
* active = true
* name[NombreOficial].use = #official
* name[NombreOficial].family = "Carmona"
* name[NombreOficial].given[0] = "María"
* telecom[0].system = #phone
* telecom[0].value = "+56912345678"
* telecom[0].use = #mobile
* gender = #female
* birthDate = "1975-04-12"
* deceasedBoolean = false

Instance: EstablecimientoUrgenciaEj
InstanceOf: MINSALPrestadorOrganizacional
Usage: #example
Title: "Hospital de ejemplo"
Description: "Establecimiento emisor identificado por su código DEIS, conforme a MINSALPrestadorOrganizacional del NID."
* identifier.system = $sidDEIS
* identifier.value = "112100"
* active = true
* name = "Hospital de Ejemplo"
* partOf.display = "Servicio de Salud Metropolitano Sur Oriente"

Instance: EstablecimientoDestinoEj
InstanceOf: MINSALPrestadorOrganizacional
Usage: #example
Title: "CESFAM de ejemplo"
Description: "Establecimiento de atención primaria al que se deriva a la paciente para control."
* identifier.system = $sidDEIS
* identifier.value = "112307"
* active = true
* name = "CESFAM de Ejemplo"

Instance: ProfesionalUrgenciaEj
InstanceOf: MINSALPrestadorProfesional
Usage: #example
Title: "Médica de urgencia"
Description: "Médica cirujana que da el alta, conforme a MINSALPrestadorProfesional del NID."
* identifier[run].use = #official
* identifier[run].type = $CSTipoIdentificador#01 "RUN"
* identifier[run].system = $sidRUN
* identifier[run].value = "22222222-2"
* active = true
* name.family = "Pérez"
* name.given[0] = "Ana"
* gender = #female
* birthDate = "1985-06-20"
* qualification[TituloProfesional].identifier.value = "cert"
* qualification[TituloProfesional].code = $CSTituloProfesionalNID#1 "MÉDICO CIRUJANO"
* qualification[TituloProfesional].code.text = "Médico cirujano"
