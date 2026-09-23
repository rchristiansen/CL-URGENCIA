## Objetivo

Esta guía define **lo mínimo** que un establecimiento debe informar a la red cuando atiende a una persona en su unidad de urgencia, para que cualquier otro punto de la red (APS, especialidad, otro hospital, SAMU) sepa:

1. **Quién** fue atendido.
2. **Dónde** y **cuándo** ocurrió la atención.
3. **Cómo terminó**: alta (con destino), o abandono voluntario (fuga o NEA).
4. **Qué tenía** el paciente: hipótesis y diagnóstico de egreso.
5. **Qué se le indicó**: medicamentos al alta.
6. **Dónde está el detalle clínico completo**: el documento DAU en PDF.

El foco es la **continuidad de la atención**, no el registro clínico exhaustivo. El detalle clínico (anamnesis, examen físico, signos vitales, exámenes, procedimientos) sigue en el PDF generado por el HIS/RCE.

## Tres eventos

La atención de urgencia se informa mediante **tres transacciones FHIR** (`Bundle` de tipo `transaction`), una por cada hito:

| Evento | Cuándo se envía | Estado del episodio | Contenido clave |
|---|---|---|---|
| **Admisión** | Al admitir al paciente en urgencia | Abierto (`in-progress`) | Paciente, establecimiento, fecha/hora de admisión, motivo de consulta, procedencia, medio de llegada |
| **Alta** | Al dar el alta médica | Cerrado (`finished`) | Fecha/hora de alta, destino, diagnóstico de egreso, medicamentos indicados, PDF |
| **Abandono** | Al constatar que el paciente se retiró sin alta (fuga o NEA) | Cerrado (`finished`) | Fecha/hora de abandono, tipo de abandono, hipótesis diagnóstica y PDF si existen |

Todo episodio abre con una **admisión** y cierra con un **alta** o un **abandono**.

<div class="diagrama-urgencia">
stateDiagram-v2
    direction LR
    [*] --> EnAtencion: Admisión
    EnAtencion --> Cerrado: Alta
    EnAtencion --> Cerrado: Abandono (fuga / NEA)
    Cerrado --> [*]
    state "En atención (in-progress)" as EnAtencion
    state "Cerrado (finished)" as Cerrado
</div>

## Flujo general

<div class="diagrama-urgencia">
flowchart LR
    HIS["HIS / RCE<br/>urgencia"] -->|"transacción FHIR<br/>admisión · alta · abandono"| BUS["Bus de Interoperabilidad<br/>MINSAL"]
    BUS --> REP["Repositorio FHIR"]
    REP --> RED["Red asistencial<br/>APS · especialidad · hospitales"]
    REP --> HCC["HCC<br/>Portal Ciudadano"]
</div>

La información queda disponible para los equipos de la red que continúan la atención y para el propio paciente en **HCC (Portal Ciudadano)**.

## Principio del modelo

El recurso central es el **`Encounter`**: representa un único episodio de urgencia, desde la admisión hasta su cierre. No se crea un recurso distinto para cada evento: cada transacción **actualiza el mismo `Encounter`** mediante `PUT` condicional por su **ID DAU**, con el estado del momento.

```text
Patient ............ ¿Quién?
Organization ....... ¿Dónde?
Encounter .......... ¿Qué atención ocurrió, cuándo y cómo terminó?
Condition .......... ¿Qué diagnóstico se registró?
MedicationRequest .. ¿Qué medicamentos se indicaron al alta?
DocumentReference .. ¿Dónde está el documento clínico completo? → PDF
```

## Perfiles

| Perfil | Recurso | Uso |
|---|---|---|
| [Bundle de admisión](StructureDefinition-bundle-admision-urgencia.html) | `Bundle` (transaction) | Evento admisión. |
| [Bundle de alta](StructureDefinition-bundle-alta-urgencia.html) | `Bundle` (transaction) | Evento alta. |
| [Bundle de abandono](StructureDefinition-bundle-abandono-urgencia.html) | `Bundle` (transaction) | Evento abandono. |
| [Encuentro de urgencia](StructureDefinition-encuentro-urgencia.html) | `Encounter` | Episodio. Variantes por evento: [admisión](StructureDefinition-encuentro-urgencia-admision.html), [alta](StructureDefinition-encuentro-urgencia-alta.html), [abandono](StructureDefinition-encuentro-urgencia-abandono.html). |
| [MINSAL Paciente](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/StructureDefinition-MINSALPaciente.html) (NID) | `Patient` | Perfil nacional del NID, usado directamente. |
| [MINSAL Prestador Organizacional](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/StructureDefinition-MINSALPrestadorOrganizacional.html) (NID) | `Organization` | Perfil nacional del NID, usado directamente. Se identifica por código DEIS. |
| [MINSAL Prestador Profesional](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/StructureDefinition-MINSALPrestadorProfesional.html) (NID) | `Practitioner` | Perfil nacional del NID, usado directamente. Opcional en los mensajes. |
| [Diagnóstico de urgencia](StructureDefinition-diagnostico-urgencia.html) | `Condition` | Hipótesis o diagnóstico de egreso. Basado en CL-Core `CoreDiagnosticoCl`. |
| [Indicación de medicamento](StructureDefinition-indicacion-medicamento-urgencia.html) | `MedicationRequest` | Medicamentos indicados al alta. Opcional. |
| [Documento de urgencia](StructureDefinition-documento-urgencia.html) | `DocumentReference` | Enlace al PDF del DAU. |

## Cómo leer esta guía

- [Modelo de eventos](modelo.html): qué contiene cada transacción y cómo se relacionan los recursos.
- [Arquitectura](arquitectura.html): envío al Bus, validaciones y consulta desde la red.
- [Casos de uso](casos-de-uso.html): escenarios de admisión, alta, fuga y consulta por otro establecimiento.
- [Mapeo CMBD](mapeo-cmbd.html): correspondencia campo a campo entre el CMBD de Urgencia (DEIS) y FHIR.

## Dependencias

| Dependencia | Versión | Uso |
|---|---|---|
| FHIR R4 | `4.0.1` | Estándar base. |
| CL-Core | `1.9.2` | Perfiles base de encuentro y diagnóstico. |
| [NID](https://interoperabilidad.minsal.cl/fhir/ig/nid/0.4.6/artifacts.html) | `0.4.6` | Paciente, prestador profesional y prestador organizacional; terminología de previsión, tramo FONASA, leyes previsionales y título profesional. |
| CIE-10 | — | Diagnósticos (preferente). |
| SNOMED CT | — | Diagnósticos (alternativo). |
| LOINC | — | Tipo de documento (`59258-4` Emergency department Discharge summary). |
| MPI MINSAL | — | Resolución de identidad del paciente (dependencia externa). |

{% include diagramas.html %}
