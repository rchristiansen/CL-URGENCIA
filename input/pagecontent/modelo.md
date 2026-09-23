## Estructura de una transacción

Los tres eventos usan la misma estructura: un `Bundle` de tipo `transaction` en que **cada entrada es un `PUT` condicional por identificador**.

```text
Bundle (type = transaction)
├── Encounter ......... PUT Encounter?identifier=[sistema DAU]|[ID DAU]
├── Patient ........... PUT Patient?identifier=[sistema]|[RUN u otro]
├── Organization ...... PUT Organization?identifier=[sistema DEIS]|[código]   (emisor y destino)
├── Practitioner ...... PUT Practitioner?identifier=[sistema]|[RUN]            (opcional)
└── ... recursos del evento, también con PUT condicional:
    ├── Condition ............ PUT Condition?identifier=...
    ├── MedicationRequest .... PUT MedicationRequest?identifier=...
    └── DocumentReference .... PUT DocumentReference?identifier=...
```

El `PUT` condicional **crea** el recurso si no existe y lo **actualiza** si ya existe. De ahí salen tres propiedades del modelo:

- **Correlación sin lógica adicional:** la admisión crea el `Encounter`; el alta o el abandono actualizan ese mismo `Encounter`, porque comparten el ID DAU.
- **Reenvío seguro:** si el HIS/RCE reintenta una transacción, no se duplican pacientes, episodios ni diagnósticos.
- **Transacción autocontenida:** trae siempre paciente, establecimiento y encuentro. Un alta sin admisión previa crea el episodio igual.

Dentro de la transacción los recursos se referencian entre sí por su `fullUrl` (`urn:uuid:...`). El servidor reemplaza esas referencias por los ids reales al procesarla.

<div class="mermaid">
flowchart LR
    E["Encounter<br/>episodio urgencia"] -->|subject| P["Patient<br/>MINSALPaciente"]
    E -->|serviceProvider| O["Organization<br/>MINSALPrestadorOrganizacional"]
    E -->|participant| PR["Practitioner<br/>MINSALPrestadorProfesional"]
    E -->|diagnosis| C["Condition<br/>diagnóstico"]
    MR["MedicationRequest<br/>indicación al alta"] -->|encounter| E
    DR["DocumentReference"] -->|context.encounter| E
    DR -->|attachment.url| PDF["PDF DAU"]
</div>

## Cómo se reconoce el evento

No hay un recurso que diga "esto es un alta". El evento se deduce del estado del `Encounter`, que cada perfil de transacción obliga:

| Evento | Perfil | `Encounter.status` | `Encounter.hospitalization.dischargeDisposition` |
|---|---|---|---|
| Admisión | [Transacción de admisión](StructureDefinition-transaccion-admision-urgencia.html) | `in-progress` | No se envía |
| Alta | [Transacción de alta](StructureDefinition-transaccion-alta-urgencia.html) | `finished` | [Destino de alta](ValueSet-vs-destino-alta.html) |
| Abandono | [Transacción de abandono](StructureDefinition-transaccion-abandono-urgencia.html) | `finished` | [Tipo de abandono](ValueSet-vs-tipo-abandono.html) |

Quien necesite reaccionar a un evento (por ejemplo, avisar al CESFAM de un alta o de una fuga) lo hace suscribiéndose a los cambios de `Encounter` en el repositorio.

## Contenido por evento

**Obligatorio** = la transacción se rechaza si falta. **Si existe** = se envía cuando el HIS/RCE tiene el dato.

| Recurso / dato | Admisión | Alta | Abandono |
|---|---|---|---|
| `Patient` | Obligatorio | Obligatorio | Obligatorio |
| `Organization` (emisor) | Obligatorio | Obligatorio | Obligatorio |
| `Encounter.status` | `in-progress` | `finished` | `finished` |
| `Encounter.period.start` (admisión) | Obligatorio | Obligatorio | Obligatorio |
| `Encounter.period.end` | No se envía | Obligatorio (alta) | Obligatorio (abandono) |
| `Encounter.reasonCode` (motivo de consulta) | Si existe | Si existe | Si existe |
| `Encounter.hospitalization.admitSource` (procedencia) | Si existe | Si existe | Si existe |
| `Encounter.hospitalization.dischargeDisposition` | No se envía | Obligatorio | Obligatorio |
| `Encounter.hospitalization.destination` | — | Si hay traslado o derivación | — |
| `Condition` (diagnóstico) | — | Obligatorio, al menos uno (`DD`) | Si existe (hipótesis `AD`) |
| `MedicationRequest` | — | Si existe | — |
| `DocumentReference` (PDF) | — | Obligatorio | Si existe |
| `Practitioner` | Si existe | Si existe (quien da el alta) | Si existe |

## Identificadores

Cada recurso de la transacción debe traer un identificador estable, que es la llave del `PUT` condicional:

| Recurso | Identificador | Ejemplo de `request.url` |
|---|---|---|
| `Encounter` | ID DAU del establecimiento | `Encounter?identifier=https://hospital.cl/sid/dau\|DAU-2026-000123` |
| `Patient` | RUN (o pasaporte, RUN madre, identificador local) | `Patient?identifier=urn:oid:2.16.840.1.113883.2.22.1.152.787300\|11111111-1` |
| `Organization` | Código DEIS | `Organization?identifier=https://interoperabilidad.minsal.cl/fhir/ig/tei/CodeSystem/CSEstablecimientoDestino\|112100` |
| `Practitioner` | RUN | `Practitioner?identifier=urn:oid:2.16.840.1.113883.2.22.1.152.787300\|22222222-2` |
| `Condition` | Id del diagnóstico en el HIS/RCE | `Condition?identifier=https://hospital.cl/sid/diagnosticos\|DG-88001` |
| `MedicationRequest` | Id de la indicación en el HIS/RCE | `MedicationRequest?identifier=https://hospital.cl/sid/indicaciones\|IND-5501-1` |
| `DocumentReference` | `masterIdentifier` del documento | `DocumentReference?identifier=https://hospital.cl/sid/documentos\|DOC-000123` |

El ID DAU debe ser **único** en el establecimiento, **no reutilizarse** nunca y ser **el mismo** en las tres transacciones del episodio. El `system` identifica al establecimiento, por lo que el par `system|value` es único a nivel nacional.

## Reglas de negocio

| Regla | Dónde se valida |
|---|---|
| Todas las entradas usan `PUT` condicional por identificador. | Invariante `urg-tx-put-condicional` |
| Un episodio `finished` debe tener `period.end`. | Invariante `urg-enc-1` |
| Un episodio `finished` debe tener destino o tipo de abandono. | Invariante `urg-enc-2` |
| El alta usa solo destinos de alta; el abandono usa solo tipos de abandono. | Perfiles `EncuentroUrgenciaAlta` y `EncuentroUrgenciaAbandono` |
| La transacción se aplica completa o no se aplica. | Servidor FHIR (semántica de `transaction`) |
| El HIS/RCE no debe enviar una admisión de un episodio ya cerrado: el `PUT` lo reabriría. | HIS/RCE; el Bus puede rechazarla |
| Para anular un episodio enviado por error se reenvía el `Encounter` con `status = entered-in-error`. | HIS/RCE |

## Fuga y NEA

Ambos son **abandono voluntario** y se informan con la transacción de abandono. Se distinguen por el [tipo de abandono](CodeSystem-tipo-abandono.html):

| Código | Significado | Cuándo |
|---|---|---|
| `1` | Abandono antes de la atención médica (NEA, No Espera Atención) | El paciente se va antes de ser evaluado por el profesional. |
| `2` | Abandono durante la atención médica (fuga) | El paciente se va después de iniciada la atención, sin alta. |

`period.end` corresponde a la fecha y hora en que el equipo **constata** el abandono.

## Qué no incluye este modelo

Para mantener el modelo mínimo, los siguientes datos **no** se envían como recursos estructurados. Siguen disponibles en el PDF:

- Categorización (ESI u otra).
- Signos vitales, anamnesis, examen físico y evolución.
- Solicitudes y resultados de exámenes (tienen sus propias guías de laboratorio e imagenología).
- Procedimientos y medicamentos administrados durante la atención.

El modelo puede crecer agregando recursos a las transacciones sin cambiar su núcleo (paciente, establecimiento, encuentro, documento).
