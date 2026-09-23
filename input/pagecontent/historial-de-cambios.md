## Versión 0.2.0

Rediseño de la guía hacia un **modelo de eventos mínimo** orientado a la continuidad de la atención en la red. Reemplaza el modelo documental de las versiones 0.1.x.

### Alcance funcional

- **Tres eventos:** la atención se informa mediante tres transacciones: **admisión**, **alta** y **abandono** (fuga o NEA). Reemplaza el envío único de un documento al cierre.
- **Encounter como recurso central:** un único episodio que se abre en la admisión (`in-progress`) y se cierra con el alta o el abandono (`finished`). Los eventos se correlacionan por el ID DAU (`Encounter.identifier`).
- **Contenido clínico mínimo:** diagnóstico de egreso, medicamentos indicados al alta y referencia al PDF del DAU. El detalle clínico queda en el PDF.
- **Abandono:** fuga y NEA se unifican en el evento `abandono` y se distinguen por el tipo de abandono (códigos alineados con la versión 0.1.2-ballot).
- **CMBD de Urgencia:** se incorpora el mapeo campo a campo del CMBD (DEIS) a FHIR, con sus dominios como CodeSystems locales.

### Estructura

- **`Bundle.type = transaction`** en lugar de `Bundle.type = document` con `Composition`, alineado con la versión 0.1.2-ballot.
- **`PUT` condicional por identificador** en todas las entradas: el ID DAU correlaciona los eventos y un reenvío no duplica recursos. Diagnóstico, indicación de medicamento y documento exigen identificador.
- **HCC (Portal Ciudadano)** se incorpora como consumidor en los diagramas de arquitectura y casos de uso.
- **Se elimina `Composition`:** el `DocumentReference` basta para descubrir y acceder al PDF.

### Dependencias

- Se agrega `hl7.fhir.cl.minsal.nid` `0.4.6`.
- `hl7.fhir.cl.clcore` pasa de `1.9.3` a `1.9.2`, la versión sobre la que está construido NID 0.4.6.

### Perfiles

Nuevos:

- `TransaccionAdmisionUrgencia`, `TransaccionAltaUrgencia`, `TransaccionAbandonoUrgencia` (y su base `TransaccionUrgencia`).
- `EncuentroUrgencia` y sus variantes por evento: `EncuentroUrgenciaAdmision`, `EncuentroUrgenciaAlta`, `EncuentroUrgenciaAbandono`.
- `IndicacionMedicamentoUrgencia` (`MedicationRequest`) con nombre y posología en texto libre.

Paciente, profesional y establecimiento usan **directamente** los perfiles del NID 0.4.6: `MINSALPaciente`, `MINSALPrestadorProfesional` y `MINSALPrestadorOrganizacional`. Se eliminan `DauPatient`, `ProfesionalUrgenciaDAU` y `OrganizacionUrgenciaDAU`.

Renombrados y simplificados:

- `DiagnosticoUrgenciaDAU` → `DiagnosticoUrgencia` (tipo de diagnóstico en `verificationStatus`).
- `DocumentoPDFUrgenciaDAU` → `DocumentoUrgencia` (PDF por URL).

Eliminados: `BundleDocumentoDAU`, `ComposicionDocumentoDAU`, `ObservacionUrgenciaDAU`, `SolicitudUrgenciaDAU`, `ProcedimientoUrgenciaDAU`, `MedicamentoAdministradoUrgenciaDAU`, `RolProfesionalUrgenciaDAU`, `UbicacionUrgenciaDAU`.

### Terminología y extensiones

- CodeSystems del CMBD: procedencia, medio de llegada, unidad de atención, clasificación de la consulta, destino de alta y pronóstico médico-legal.
- Previsión, tramo FONASA, leyes previsionales y título profesional usan la terminología del NID.
- CodeSystems propios: evento de urgencia y tipo de abandono.
- Extensiones opcionales para datos del CMBD sin elemento FHIR equivalente: medio de llegada, previsión, ley previsional, clasificación de la consulta, pronóstico médico-legal, pertinencia y diagnóstico GES.
- Se eliminan `TipoDocumentoDAU`, `SeccionesDAU`, `CondicionEgresoDAU` y `TipoDiagnosticoDAU`.

## Versión 0.1.2

Actualización técnica de la Guía de Implementación FHIR R4 para el Documento de Atención de Urgencia (DAU).

### Alcance funcional

- **Eliminación de categorización:** se elimina la categorización y la recategorización del alcance de la versión actual de la guía.

- **Actualización del conjunto mínimo de datos:** se ajusta el conjunto mínimo de datos para excluir categorización y recategorización.

- **Incorporación de NEA:** se incorpora NEA como desenlace válido del episodio de atención de urgencia.

- **Actualización del cierre de atención:** se ajustan los perfiles, ejemplos y documentación para representar episodios cerrados por NEA, incluso cuando no exista diagnóstico o tratamiento.

### Dependencias

- **Actualización de dependencia:** se actualiza la dependencia `hl7.fhir.cl.clcore` desde `1.8.5` a `1.9.3` en la configuración de la guía y en la documentación asociada.

### Perfiles

- **Alineación del encuentro con CL-Core:** el perfil `DauEncounter` se mantiene como extensión del perfil `EncounterCL` de `CL-Core` y se ajusta para admitir cierre por NEA.

- **Alineación del diagnóstico con CL-Core:** el perfil `DiagnosticoUrgenciaDAU` pasa a construirse sobre `CoreDiagnosticoCl` para cumplir con las restricciones del perfil nacional usado por el encuentro.

- **Observaciones clínicas:** el perfil `ObservacionUrgenciaDAU` se conserva para signos vitales, escalas y otras observaciones clínicas, sin usarlo para categorización.

### Terminología

- **Secciones del documento DAU:** se elimina la sección de categorización del conjunto de secciones del documento.

- **Condición de egreso DAU:** se mantiene el uso de un código local para NEA como desenlace válido del episodio.

### Documentación actualizada

- **Gobernanza y narrativa:** se actualizan los documentos de gobernanza, el `README` y las páginas narrativas para reflejar la nueva versión de `CL-Core` y la eliminación de categorización.

- **Ejemplos:** se actualizan los ejemplos del encuentro y del documento para mostrar un cierre por NEA sin diagnóstico ni tratamiento.


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

- Se agrega dependencia con `hl7.fhir.cl.clcore` versión `1.9.3`.

### Documentación

- **Resolución de identidad:** se resuelve la identidad del paciente mediante el MPI dentro del flujo de interoperabilidad.

- **Casos de uso:** incorporación de tres diagramas correspondientes a los casos de uso principales de la guía.

- **Diagramas de arquitectura:** incorporación del diagrama de flujo de integración con el Bus de Interoperabilidad y del diagrama asociado al uso de la identidad resuelta.

- **Plantilla de publicación:** adopción de la plantilla `hl7chile-ig-template`, incorporando la identidad visual de MINSAL y HL7 Chile.