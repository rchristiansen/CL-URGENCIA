# Historial de cambios

## Versión 0.1.1

Actualización técnica de la Guía de Implementación FHIR R4 para el Documento de Atención de Urgencia (DAU).

### Cambios en el alcance de interoperabilidad

- **Intercambio directo FHIR R4:** se consolida el intercambio directo de recursos FHIR R4 mediante un `Bundle` de tipo `document`.

- **Eliminación del mapeo HL7 v2 a FHIR:** se retira el mapeo de mensajes HL7 v2 hacia recursos FHIR.

- **Eliminación de la transformación HL7 v2:** la transformación de mensajes HL7 v2 deja de formar parte del alcance de la guía.

- **Actualización documental:** se actualizan los diagramas, la arquitectura y las descripciones del flujo de integración para reflejar el intercambio directo entre los sistemas HIS/RCE y el Bus de Interoperabilidad de MINSAL.

### Alineación con CL-Core

- **Asociación del paciente con CL-Core:** el perfil `DauPatient` se asocia al perfil `CorePacienteCl` de `CL-Core`.

---

## Versión 0.1.0

Versión inicial de la guía para la Atención de Urgencia (DAU). Define el modelo clínico e interoperable para el registro, generación, intercambio y recepción de atenciones de urgencia mediante FHIR.

### Alcance y arquitectura

- **Intercambio mediante FHIR R4:** adopción del estándar FHIR utilizando un `Bundle` de tipo `document`, estructurado mediante una `Composition`.

- **Mapeo HL7 v2 a FHIR:** incorporación del mapeo de mensajes HL7 v2 hacia recursos FHIR como referencia para la interoperabilidad de atenciones de urgencia.

- **Flujo de integración:** definición del flujo de intercambio entre los sistemas HIS/RCE, el Bus de Interoperabilidad de MINSAL, el servicio terminológico, el MPI, el repositorio FHIR y el Portal Ciudadano.

- **Documento clínico DAU:** definición de la atención de urgencia como un documento clínico interoperable, compuesto por recursos FHIR relacionados con la identificación del paciente, el episodio de atención, la información clínica, las solicitudes, los procedimientos, los tratamientos y el egreso.

### Perfiles

- **`BundleDocumentoDAU`:** perfil de `Bundle` de tipo `document` para empaquetar estructuradamente el Documento de Atención de Urgencia.

- **`ComposicionDocumentoDAU`:** perfil de `Composition` que estructura las secciones del documento DAU y corresponde a su primera entrada obligatoria.

- **`DauPatient`:** perfil de `Patient` para la identificación del paciente atendido en urgencia.

- **`DauEncounter`:** perfil de `Encounter` para representar el episodio completo de atención de urgencia, incluyendo sus estados, fechas, establecimiento, ubicación y desenlace.

- **`ObservacionUrgenciaDAU`:** perfil de `Observation` para registrar la categorización de urgencia, los signos vitales y otros hallazgos clínicos.

- **`DiagnosticoUrgenciaDAU`:** perfil de `Condition` para representar las hipótesis diagnósticas y los diagnósticos establecidos durante o al término de la atención.

- **`SolicitudUrgenciaDAU`:** perfil de `ServiceRequest` para solicitudes de laboratorio, imagenología, procedimientos y derivaciones.

- **`ProcedimientoUrgenciaDAU`:** perfil de `Procedure` para registrar los procedimientos clínicos realizados durante la atención.

- **`MedicamentoAdministradoUrgenciaDAU`:** perfil de `MedicationAdministration` para representar los medicamentos y tratamientos administrados durante la atención.

- **`MedicamentoIndicadoUrgenciaDAU`:** perfil de `MedicationRequest` para representar los medicamentos prescritos o indicados al momento del alta.

- **`ProfesionalUrgenciaDAU`:** perfil de `Practitioner` para identificar a los profesionales de salud responsables o participantes en la atención.

- **`RolProfesionalUrgenciaDAU`:** perfil de `PractitionerRole` para representar la función o participación del profesional dentro del establecimiento.

- **`OrganizacionUrgenciaDAU`:** perfil de `Organization` para identificar los establecimientos y organizaciones participantes.

- **`UbicacionUrgenciaDAU`:** perfil de `Location` para representar las unidades, sectores y boxes donde se desarrolla la atención.

- **`DocumentoPDFUrgenciaDAU`:** perfil de `DocumentReference` para referenciar o adjuntar la representación PDF del DAU, cuando corresponda.

### Terminología

- **Estado de los recursos terminológicos:** declaración explícita de la propiedad `experimental = true` en los recursos `CodeSystem` y `ValueSet`, reflejando que estos se encuentran en etapa de construcción, revisión y validación técnica.

- **Terminología del dominio DAU:** definición inicial de códigos, sistemas de codificación y conjuntos de valores propios para representar los conceptos asociados a la atención de urgencia.

### Recursos incorporados

Se incorporan los siguientes recursos FHIR para representar el documento DAU y su información clínica relacionada:

`Bundle`, `Composition`, `Patient`, `Encounter`, `Organization`, `Location`, `Practitioner`, `PractitionerRole`, `Condition`, `Observation`, `Procedure`, `ServiceRequest`, `MedicationAdministration`, `MedicationRequest` y `DocumentReference`.

### Dependencias

- Se agrega dependencia con `hl7.fhir.cl.clcore` versión `1.8.5`.

### Documentación

- **Resolución de identidad:** se resuelve la identidad del paciente mediante el MPI dentro del flujo de interoperabilidad.

- **Casos de uso:** incorporación de tres diagramas correspondientes a los casos de uso principales de la guía.

- **Diagramas de arquitectura:** incorporación del diagrama de flujo de integración con el Bus de Interoperabilidad y del diagrama asociado al uso de la identidad resuelta.

- **Plantilla de publicación:** adopción de la plantilla `hl7chile-ig-template`, incorporando la identidad visual de MINSAL y HL7 Chile.