# Historial de cambios

## [0.1.0] - 2026-09-10

### Agregado

- Creación de la Guía de Implementación FHIR R4 para Datos de Atención de Urgencia (DAU).
- Definición del flujo de integración entre HIS/RCE, Bus de Interoperabilidad, Servicio Terminológico, MPI/NID, repositorio FHIR y Portal Ciudadano.
- Definición del documento DAU mediante `Bundle.type = document`.
- Definición de `Composition` como primera entrada del documento.
- Incorporación de los recursos `Patient`, `Encounter`, `Organization`, `Location`, `Practitioner`, `PractitionerRole`, `Condition`, `Observation`, `Procedure`, `ServiceRequest`, `MedicationAdministration`, `MedicationRequest` y `DocumentReference`.
- Incorporación de la información de admisión, identificación, categorización, signos vitales, atención clínica, diagnósticos, solicitudes, tratamientos y egreso.
- Declaración de CL-Core `1.8.5` como dependencia transversal implementada.
- Definición inicial de CodeSystems y ValueSets propios para el dominio DAU.
- Incorporación de perfiles para el Bundle documental, Composition y solicitudes.
- Incorporación de un ejemplo documental compuesto por `Bundle`, `Composition`, paciente, encuentro, organización y profesionales.
- Documentación inicial del flujo HL7 v2 hacia FHIR R4. El mapeo queda pendiente de cierre para una versión concreta de HL7 v2.

### Referencias

- HL7 FHIR R4 `4.0.1`.
- CL-Core Chile `1.8.5`.
- MPI/NID MINSAL: dependencia externa pendiente de formalización.
- Norma Técnica N.° 820.
