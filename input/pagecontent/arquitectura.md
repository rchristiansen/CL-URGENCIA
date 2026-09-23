## Participantes

| Sistema | Rol |
|---|---|
| HIS / RCE del establecimiento | Envía las transacciones de admisión, alta y abandono. Publica el PDF del DAU. |
| Bus de Interoperabilidad MINSAL | Recibe, valida y aplica las transacciones en el repositorio. |
| MPI MINSAL | Resuelve la identidad única del paciente. |
| Servidor Terminológico Nacional | Valida los códigos. |
| Repositorio FHIR | Conserva el estado vigente de cada episodio y la referencia a su documento. |
| Red asistencial | APS, especialidad, otros hospitales y SAMU. Consultan el repositorio para dar continuidad. |
| HCC (Portal Ciudadano) | Muestra al paciente sus atenciones de urgencia y el documento DAU. |

## Flujo

<div class="diagrama-urgencia">
flowchart LR
    HIS["HIS / RCE"] -->|"POST transaction<br/>admisión · alta · abandono"| BUS["Bus de<br/>Interoperabilidad"]
    BUS --> VAL["Validación<br/>perfil + terminología"]
    VAL --> MPI["Identidad<br/>MPI"]
    MPI --> REP["Repositorio FHIR"]
    REP -->|"consulta"| RED["Red asistencial<br/>APS · especialidad · hospitales"]
    REP -->|"consulta"| HCC["HCC<br/>Portal Ciudadano"]
    RED -.->|"descarga PDF"| HIS
    HCC -.->|"descarga PDF"| HIS
    VAL -.->|"OperationOutcome"| HIS
</div>

## Envío

El HIS/RCE envía cada transacción a la base FHIR del Bus:

```http
POST [base]
Content-Type: application/fhir+json

{
  "resourceType": "Bundle",
  "type": "transaction",
  "entry": [
    {
      "fullUrl": "urn:uuid:...",
      "resource": { "resourceType": "Encounter", ... },
      "request": { "method": "PUT", "url": "Encounter?identifier=[sistema DAU]|[ID DAU]" }
    },
    ...
  ]
}
```

El envío debe ocurrir **en el momento del evento** (tiempo real o casi real), no en lotes al final del día: el valor para la continuidad depende de que la red se entere mientras el paciente está en urgencia o recién egresado.

## Respuesta

| Resultado | HTTP | Cuerpo |
|---|---|---|
| Transacción aplicada | `200 OK` | `Bundle` de tipo `transaction-response` con el resultado de cada entrada (`201 Created` o `200 OK`) |
| Error de estructura, perfil o terminología | `400` / `422` | `OperationOutcome` con el detalle por elemento; no se aplica ninguna entrada |
| Identificador condicional ambiguo (más de un recurso coincide) | `412` | `OperationOutcome` |
| Identidad no resuelta en MPI | `422` | `OperationOutcome`; el HIS/RCE corrige y reenvía |

Si el HIS/RCE no recibe respuesta, puede **reenviar la misma transacción**: el `PUT` condicional evita duplicados.

## Procesamiento en el Bus

1. Validar el `Bundle` contra el perfil del evento ([admisión](StructureDefinition-bundle-admision-urgencia.html), [alta](StructureDefinition-bundle-alta-urgencia.html) o [abandono](StructureDefinition-bundle-abandono-urgencia.html)).
2. Validar los códigos contra el Servidor Terminológico.
3. Resolver el `Patient` contra MPI y agregar el identificador MPI.
4. Aplicar la transacción en el repositorio. Cada `PUT` condicional crea o actualiza el recurso según su identificador.
5. Registrar la trazabilidad: emisor, fecha de recepción, resultado de validación y respuesta.

## Identidad del paciente

| Resultado MPI | Acción del Bus |
|---|---|
| Identidad única encontrada | Asociar el episodio al paciente MPI. |
| Paciente no encontrado | Ejecutar la transacción MPI de creación. |
| Identidad duplicada o contradictoria | Rechazar y enviar a conciliación. |
| RUN con dígito verificador inválido | Rechazar la transacción. |
| MPI no disponible | Responder error transitorio; el HIS/RCE reintenta. |

Los pacientes sin RUN (extranjeros, recién nacidos, NN) se envían con el identificador disponible: pasaporte, RUN de la madre o identificador local del establecimiento.

## Consulta desde la red y HCC

La red asistencial y HCC (Portal Ciudadano) consultan el repositorio con búsquedas FHIR estándar:

```http
# Atenciones de urgencia de un paciente
GET [base]/Encounter?patient.identifier=urn:oid:2.16.840.1.113883.2.22.1.152.787300|11111111-1&class=EMER

# Pacientes actualmente en urgencia en un establecimiento
GET [base]/Encounter?service-provider.identifier=https://interoperabilidad.minsal.cl/fhir/ig/tei/CodeSystem/CSEstablecimientoDestino|112100&class=EMER&status=in-progress

# Diagnósticos de egreso y documento de una atención
GET [base]/Condition?encounter=Encounter/[id]
GET [base]/DocumentReference?encounter=Encounter/[id]
```

Para enterarse de un evento apenas ocurre (por ejemplo, el CESFAM del paciente ante un alta o una fuga), el consumidor crea una `Subscription` sobre `Encounter` con `class=EMER`.

El PDF se descarga desde `DocumentReference.content.attachment.url`, publicado por el establecimiento emisor (o replicado en el repositorio, según el acuerdo institucional).

## Seguridad

- Transporte cifrado (TLS 1.2 o superior).
- Autenticación del sistema emisor ante el Bus (mecanismo definido por MINSAL).
- La URL del PDF debe exigir autenticación; no debe ser pública.
- HCC muestra al paciente solo sus propias atenciones.
- El acceso de la red se rige por las políticas de acceso y el consentimiento del paciente cuando corresponda.

{% include diagramas.html %}
