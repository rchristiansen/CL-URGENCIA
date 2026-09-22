Profile: DauPatient
Parent: CorePacienteCl
Id: dau-patient
Title: "DAU - Paciente"
Description: "Perfil de paciente utilizado para identificar a la persona atendida en el servicio de urgencia y relacionarla con el documento clínico DAU y los recursos FHIR asociados. Extiende el perfil de paciente definido en CL-Core (hl7.fhir.cl.clcore) en lugar del recurso base Patient de FHIR R4, manteniendo la alineación con el portafolio de Guías de Implementación de MINSAL."

* identifier 1..* MS
* name 1..* MS
* birthDate MS
* gender MS
* address 0..* MS
* telecom 0..* MS
* link 0..* MS