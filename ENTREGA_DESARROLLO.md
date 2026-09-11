# Notas de continuidad de desarrollo

Documento de traspaso: qué está resuelto, qué está decidido pero no implementado y qué sigue abierto en la Guía de Implementación FHIR de Urgencia — Datos de Atención de Urgencia (DAU). Complementa el `README.md` —qué es la guía— y la página *Historial de cambios* del sitio publicado —qué cambió en cada versión—.

## Estado de la versión 0.1.0

La guía se encuentra en estado **draft** y en desarrollo inicial. SUSHI compila la estructura actual con **0 errores y 0 advertencias**. La versión incluye los perfiles documentales y clínicos definidos para el DAU, junto con ejemplos FHIR de referencia.

| Elemento | Estado |
|---|---|
| Estructura del proyecto IG | Disponible |
| Configuración de SUSHI e IG Publisher | Disponible |
| Perfil de paciente | Implementado mediante `DauPatient` basado en CL-Core 1.8.5 |
| Modelo documental DAU | Implementado mediante `BundleDocumentoDAU` y `ComposicionDocumentoDAU` |
| Perfiles clínicos | Implementados como base técnica; pendientes de validación clínica |
| Solicitudes de laboratorio e imagenología | Representadas mediante `SolicitudUrgenciaDAU` (`ServiceRequest`) cuando existan |
| Resultados de laboratorio e imagenología | Fuera del alcance del documento DAU |
| Mapeo HL7 v2 a FHIR | Propuesto; pendiente de validación con mensajes reales |
| Terminologías y valores permitidos | CodeSystems y ValueSets iniciales; bindings nacionales pendientes |
| Publicación oficial del canonical | Pendiente |

## Decisiones de diseño tomadas

Estas decisiones deben conservarse mientras no exista un acuerdo técnico o clínico que las modifique:

1. **El alcance inicial se centra en el documento clínico DAU.** La guía representa la información clínica de una atención de urgencia al finalizar o cerrar el episodio.
2. **El DAU se representa como un documento FHIR R4.** La estructura principal es un `Bundle` con `type = document` y una `Composition` como primera entrada.
3. **El modelo lógico es independiente del formato de entrada.** El establecimiento puede enviar FHIR R4 directamente o HL7 v2 para que el Bus o un adaptador lo transforme al modelo FHIR.
4. **El HIS/RCE del establecimiento es el origen de la información clínica.** El flujo comienza con la información de admisión, identificación, categorización, observaciones, diagnósticos, solicitudes, tratamientos, procedimientos y egreso.
5. **El Bus consulta terminología y valida identidad.** El flujo contempla la transformación a FHIR, la consulta terminológica y la validación del paciente mediante MPI/NID antes de publicar.
6. **El Portal Ciudadano es un consumidor posterior.** No participa en la generación ni transformación del documento DAU.
7. **Las solicitudes se representan con `ServiceRequest`.** Las solicitudes de laboratorio e imagenología se incorporan únicamente cuando fueron realizadas durante el episodio.
8. **Las guías de laboratorio e imagenología mantienen sus propios flujos.** El documento DAU no incorpora sus recursos de resultados ni informes.
9. **Las fechas utilizan el formato FHIR/ISO 8601.** Cuando corresponda, deben conservar la zona horaria y distinguir la fecha de atención, emisión y recepción.

## Pendientes técnicos

### Perfilamiento FHIR

- Validar clínicamente las cardinalidades de `Composition`, `Bundle`, `Encounter`, `Observation`, `Condition`, `ServiceRequest`, `Procedure`, medicamentos, profesionales, organización y documentos.
- Definir las secciones clínicas definitivas de `ComposicionDocumentoDAU`.
- Confirmar el conjunto mínimo de datos obligatorio para el documento DAU.
- Validar la representación del destino del paciente: alta, hospitalización, traslado, abandono, NEA o fallecimiento.
- Confirmar si el PDF se entrega mediante `Attachment.data`, `Attachment.url` o ambos mecanismos según el acuerdo institucional.
- Validar los ejemplos completos contra un validador FHIR R4 y contra los sistemas participantes.

### Terminología e identidad

- Confirmar los ValueSets nacionales para categorización, diagnósticos CIE-10, procedimientos, medicamentos, destinos y estados.
- Definir los sistemas de códigos nacionales y locales que deben conservarse junto con los textos originales.
- Formalizar la dependencia técnica con los paquetes y transacciones oficiales de MPI/NID cuando estén disponibles.
- Definir la respuesta del Bus cuando la identidad del paciente o un código no pueda validarse.
- Mantener los códigos originales cuando la homologación no sea posible.

### Mapeo HL7 v2 a FHIR

El mapeo inicial propuesto es:

| HL7 v2 | FHIR | Uso |
|---|---|---|
| `PID` | `Patient` | Identificación y datos demográficos. |
| `PV1` / `EVN` | `Encounter` | Episodio, tipo, fechas, ubicación y estado. |
| `OBX` | `Observation` | Signos vitales, categorización y observaciones clínicas. |
| `DG1` | `Condition` | Diagnósticos e hipótesis diagnósticas. |
| `ORC` / `OBR` | `ServiceRequest` | Solicitudes de laboratorio, imagenología, procedimientos o derivaciones. |
| `PR1` | `Procedure` | Procedimientos realizados. |
| `RXA` | `MedicationAdministration` | Medicamentos administrados. |
| `RXO` / `RXE` | `MedicationRequest` | Tratamientos o indicaciones prescritas. |
| `TXA` | `Composition` | Metadatos del documento clínico, cuando el mensaje de origen lo utilice. |
| `ED` en `OBX` | `DocumentReference` | PDF u otro documento clínico asociado, cuando corresponda. |

Pendientes del mapeo:

- Confirmar la versión HL7 v2 y los tipos de mensaje utilizados por los sistemas de urgencia.
- Definir los eventos disparadores para admisión, atención, solicitudes y egreso.
- Validar los campos con mensajes reales del HIS/RCE.
- Definir cómo se preservan los textos libres, códigos originales y datos ausentes.
- Definir la correlación entre el identificador del mensaje, el identificador de la atención y el identificador del documento DAU.
- Confirmar que las solicitudes sin información disponible no se generen como recursos incompletos.

### Reglas que debe implementar el Bus

Estas reglas corresponden al procesamiento y no se expresan completamente mediante invariantes FHIR:

- Validar el dígito verificador del RUN y la consistencia de los identificadores del paciente.
- Resolver o confirmar la identidad mediante MPI/NID antes de publicar el DAU.
- Consultar y validar los códigos mediante el Servicio Terminológico.
- Verificar que la primera entrada del Bundle documental sea la `Composition`.
- Validar la consistencia entre paciente, episodio, establecimiento, profesionales y fechas.
- Persistir el documento antes de enviar el acuse de recibo correspondiente.
- Implementar control de duplicados, trazabilidad técnica y auditoría de recepción.
- Registrar los errores de validación con información suficiente para que el establecimiento pueda corregir y reenviar.
- Mantener separados los flujos de solicitudes DAU y los flujos de resultados de laboratorio o imagenología.

## Puntos abiertos de alcance

1. Confirmar si el documento se genera exclusivamente al cierre de la atención o si también deben intercambiarse estados intermedios.
2. Definir el conjunto mínimo de datos clínicos y separar los campos obligatorios de los opcionales.
3. Confirmar la representación de las solicitudes de laboratorio e imagenología dentro del DAU cuando existan.
4. Definir el repositorio FHIR o mecanismo de publicación que recibirá el documento.
5. Confirmar el perfil de identidad definitivo y la responsabilidad de cada componente entre HIS/RCE, Bus, MPI/NID y Servicio Terminológico.
6. Validar con los equipos clínicos las reglas de negocio para alta, hospitalización, traslado, abandono y NEA.

## Cómo retomar el desarrollo

```bash
npm install          # instala SUSHI en la versión fijada
npm run doctor       # verifica Node, Java, Jekyll y publisher.jar
npm run publisher    # descarga el IG Publisher si aún no existe
npm run build        # SUSHI + IG Publisher
npm run serve        # sirve la guía en http://localhost:8081
```

Para iterar solo los perfiles FSH:

```bash
npm run sushi
```

Después de cada cambio se debe revisar el resultado de SUSHI, el `output/qa.html`, los enlaces del sitio y los ejemplos generados. Antes de publicar la versión 0.1.0 se deben cerrar las cardinalidades, dependencias, terminologías y reglas de validación definidas como pendientes.
