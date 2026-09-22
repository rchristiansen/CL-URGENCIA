# Guía de Implementación FHIR R4 - Urgencia

## Datos de Atención de Urgencia (DAU)

## Introducción

Esta Guía de Implementación define el modelo de interoperabilidad para el intercambio de los **Datos de Atención de Urgencia (DAU)** entre el **HIS/RCE**, el Bus de Interoperabilidad y el Portal Ciudadano.

El objetivo es transformar la información clínica y administrativa registrada durante una atención de urgencia en recursos **HL7 FHIR R4**, validarlos mediante los servicios nacionales de terminología e identidad y publicarlos para su consulta en el Portal Ciudadano.

La guía utiliza FHIR R4 `4.0.1` y CL-Core `1.9.3`. MPI, y los catálogos nacionales se consideran dependencias externas pendientes de confirmación y no se declaran todavía como paquetes implementados por esta guía.

Para el detalle de los actores y mensajes, consultar [Casos de uso](casos-de-uso.html).

## Alcance inicial

Esta primera versión contempla:

- Información de admisión del paciente.
- Identificación mediante RUN, pasaporte, MPI o identificador local.
- Código DEIS del establecimiento y Servicio de Salud.
- Fecha y hora de admisión.
- Procedencia y medio de llegada.
- Motivo de consulta.
- Evaluación clínica disponible.
- Signos vitales y observaciones clínicas.
- Condición y destino de egreso, incluido NEA.
- Anamnesis, antecedentes y alergias.
- Diagnósticos e hipótesis diagnósticas.
- Solicitudes de exámenes y procedimientos.
- Solicitudes de laboratorio e imagenología realizadas durante el episodio, cuando existan.
- Tratamientos y medicamentos administrados.
- Medicamentos e indicaciones de alta.
- Procedimientos realizados.
- Condición y destino de egreso.
- Identificación de profesionales participantes.
- Documento DAU en formato estructurado y PDF.
- Identificación del documento y trazabilidad técnica de la recepción.

## Principio de diseño

La información enviada por el HIS/RCE se transforma primero al modelo canónico FHIR R4. Posteriormente, el Bus consulta el Servicio Terminológico, valida la identidad del paciente contra MPI y publica el resultado.

<div class="mermaid">
flowchart TD
    A["RCE/HIS "] -->|"Bundle FHIR R4 tipo document"| B["Bus de Interoperabilidad"]
    B --> C["Resolución de identidad<br/>MPI"]
    C --> D["Validación terminológica"]
    D --> E["Validación contra la<br/>Guía de Implementación DAU"]
    E --> F["Portal Ciudadano"]
</div>

## Modelo documental

El DAU se representa mediante un `Bundle` FHIR R4 de tipo `document`.

```text
Bundle.type = document
Bundle.entry[0].resource = Composition
```

La `Composition` organiza el documento y referencia:

- `Patient`.
- `Encounter`.
- `Organization`.
- `PractitionerRole`.
- `Condition`.
- `Observation`.
- `Procedure`.
- `ServiceRequest`.
- `MedicationRequest`.
- `DocumentReference`.

## Recursos focales

| Contenido | Recurso FHIR | Perfil propuesto |
|---|---|---|
| Documento DAU | `Composition` | `ComposicionDocumentoDAU` |
| Contenedor documental | `Bundle` | `BundleDocumentoDAU` |
| Paciente | `Patient` | `DauPatient` sobre CL-Core |
| Atención | `Encounter` | `DauEncounter` |
| Diagnóstico | `Condition` | `DiagnosticoUrgenciaDAU` |
| Triage y signos vitales | `Observation` | `ObservacionUrgenciaDAU` |
| Solicitudes | `ServiceRequest` | `SolicitudUrgenciaDAU` |
| Procedimientos | `Procedure` | `ProcedimientoUrgenciaDAU` |
| Medicamentos administrados | `MedicationAdministration` | `MedicamentoAdministradoUrgenciaDAU` |
| Medicamentos indicados | `MedicationRequest` | `MedicamentoIndicadoUrgenciaDAU` |
| Profesionales | `PractitionerRole` | `RolProfesionalUrgenciaDAU` |
| Establecimiento | `Organization` | `OrganizacionUrgenciaDAU` |
| PDF | `DocumentReference` | `DocumentoPDFUrgenciaDAU` |

## Alineación nacional

| Guía | Aplicación |
|---|---|
| CL-Core | Perfiles transversales chilenos para paciente, prestador y organización. |
| MPI | Dependencia para identidad del paciente. |
| LOINC | Signos vitales, mediciones y resultados observacionales. |
| SNOMED CT | Procedimientos, conceptos clínicos y hallazgos. |
| CIE-10 | Diagnósticos registrados al cierre. |
| UCUM | Unidades de medida. |
