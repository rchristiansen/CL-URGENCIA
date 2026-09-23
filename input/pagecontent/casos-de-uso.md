## Actores

| Actor | Rol |
|---|---|
| Establecimiento de urgencia (HIS/RCE) | Envía las transacciones de cada evento. |
| Bus de Interoperabilidad | Valida y aplica las transacciones en el repositorio. |
| Establecimiento de la red | Consulta para dar continuidad (APS, especialidad, otro hospital). |
| HCC (Portal Ciudadano) | Muestra al paciente sus atenciones de urgencia. |

## Caso 1: Admisión

Una paciente llega por sus propios medios a urgencia del Hospital de Ejemplo con dolor abdominal.

1. El administrativo registra la admisión en el HIS/RCE, que asigna el ID DAU `DAU-2026-000123`.
2. El HIS/RCE envía la [Bundle de admisión](Bundle-BundleAdmisionEj.html): `PUT Encounter?identifier=...|DAU-2026-000123` con el episodio en `in-progress`.
3. El Bus valida, resuelve la identidad en MPI y crea el episodio.

**Valor para la red:** el CESFAM de la paciente puede ver que está siendo atendida en urgencia.

## Caso 2: Alta

Tras la evaluación, la médica diagnostica gastritis aguda, indica omeprazol y da el alta a domicilio con control en su CESFAM.

1. La médica registra el alta en el HIS/RCE, que genera el PDF del DAU.
2. El HIS/RCE envía la [Bundle de alta](Bundle-BundleAltaEj.html) con:
   - el mismo `Encounter` (mismo ID DAU) en `finished`, con `period.end` y destino `05 Domicilio`;
   - el diagnóstico de egreso en CIE-10;
   - la indicación de omeprazol;
   - el documento DAU con la URL del PDF.
3. El `PUT` condicional actualiza el episodio creado en la admisión y lo cierra.

**Valor para la red:** el CESFAM conoce el diagnóstico, el tratamiento indicado y puede descargar el DAU para el control. La paciente ve la atención y el documento en HCC.

## Caso 3: Abandono (fuga)

Días después, la paciente consulta por cefalea. Es evaluada, se registra una hipótesis diagnóstica y, mientras espera exámenes, se retira sin avisar.

1. El equipo constata la ausencia y lo registra en el HIS/RCE.
2. El HIS/RCE envía la [Bundle de abandono](Bundle-BundleAbandonoEj.html) con el `Encounter` en `finished`, `period.end` = hora en que se constató el abandono y tipo `2 Abandono durante la atención médica (fuga)`, junto con la hipótesis diagnóstica.
3. El Bus cierra el episodio.

Si la paciente se hubiese retirado **antes** de ser evaluada, el tipo de abandono sería `1 NEA` y la transacción normalmente no incluiría diagnóstico.

**Valor para la red:** un episodio sin alta es una alerta de continuidad. El CESFAM puede contactar a la paciente para asegurar su seguimiento.

## Caso 4: Consulta por la red y por la paciente

La paciente acude a su control en el CESFAM.

1. El RCE del CESFAM busca las atenciones de urgencia de la paciente por RUN.
2. Obtiene los dos episodios: el alta con diagnóstico y medicamento, y el abandono.
3. Descarga el PDF del DAU desde `DocumentReference`.

La paciente, por su parte, revisa en HCC (Portal Ciudadano) sus atenciones de urgencia y descarga el DAU.

<div class="diagrama-urgencia">
sequenceDiagram
    participant HIS as HIS/RCE Hospital
    participant BUS as Bus MINSAL
    participant APS as RCE CESFAM
    participant HCC as HCC (Portal Ciudadano)

    HIS->>BUS: Bundle admisión (PUT Encounter in-progress)
    BUS-->>HIS: transaction-response
    HIS->>BUS: Bundle alta (PUT Encounter finished, Condition, MedicationRequest, DocumentReference)
    BUS-->>HIS: transaction-response
    APS->>BUS: GET Encounter?patient.identifier=RUN
    BUS-->>APS: Episodios de urgencia
    APS->>BUS: GET DocumentReference?encounter=...
    BUS-->>APS: URL del PDF
    APS->>HIS: Descarga PDF (autenticado)
    HCC->>BUS: GET Encounter / DocumentReference del paciente
    BUS-->>HCC: Atenciones y documento
    HCC->>HIS: Descarga PDF para el paciente
</div>

{% include diagramas.html %}
