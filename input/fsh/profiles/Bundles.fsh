// Bundle de tipo transaction para los tres eventos de urgencia.
// Cada transacción es autocontenida: trae el paciente, el establecimiento y el
// encuentro, de modo que el servidor puede procesarla aunque no haya recibido
// los eventos anteriores.
//
// Todas las entradas usan PUT condicional por identificador
// (PUT [Tipo]?identifier=[system]|[value]): el servidor crea el recurso si no
// existe o lo actualiza si ya existe. Así el ID DAU correlaciona los eventos y
// un reenvío no duplica información.

Invariant: urg-tx-put-condicional
Description: "Todas las entradas deben usar PUT condicional por identificador: request.method = PUT y request.url = [Tipo]?identifier=[system]|[value]."
Severity: #error
Expression: "entry.all(request.method = 'PUT' and request.url.contains('?identifier=') and request.url.contains('|'))"

Profile: BundleUrgencia
Parent: Bundle
Id: bundle-urgencia
Title: "Bundle de urgencia (base)"
Description: "Estructura común de los tres Bundle de urgencia. No se usa directamente: se usa el perfil del evento correspondiente."
* ^status = #draft
* ^abstract = true
* obeys urg-tx-put-condicional
* type = #transaction
* entry 3..* MS
* entry.fullUrl 1..1 MS
* entry.fullUrl ^short = "urn:uuid: usado por las referencias internas de la transacción"
* entry.resource 1..1 MS
* entry.request 1..1 MS
* entry.request.method = #PUT
* entry.request.url ^short = "[Tipo]?identifier=[system]|[value]"
* entry ^slicing.discriminator.type = #type
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry ^slicing.ordered = false
* entry contains
    paciente 1..1 MS and
    establecimiento 1..* MS and
    profesional 0..* MS
* entry[paciente].resource only $MINSALPaciente
* entry[establecimiento].resource only $MINSALPrestadorOrganizacional
* entry[establecimiento] ^short = "Establecimiento emisor y, si corresponde, establecimiento de destino"
* entry[profesional].resource only $MINSALPrestadorProfesional

Profile: BundleAdmisionUrgencia
Parent: BundleUrgencia
Id: bundle-admision-urgencia
Title: "Bundle de admisión de urgencia"
Description: "Evento admisión: el paciente es admitido en urgencia. Abre el episodio (Encounter en in-progress) y avisa a la red que el paciente se encuentra en atención."
* ^status = #draft
* ^abstract = false
* entry contains encuentro 1..1 MS
* entry[encuentro].resource only EncuentroUrgenciaAdmision

Profile: BundleAltaUrgencia
Parent: BundleUrgencia
Id: bundle-alta-urgencia
Title: "Bundle de alta de urgencia"
Description: "Evento alta: el profesional da el alta de urgencia. Cierra el episodio (Encounter en finished) e informa diagnóstico de egreso, destino, medicamentos indicados y el documento clínico en PDF."
* ^status = #draft
* ^abstract = false
* entry contains
    encuentro 1..1 MS and
    diagnostico 1..* MS and
    medicamento 0..* MS and
    documento 1..1 MS
* entry[encuentro].resource only EncuentroUrgenciaAlta
* entry[diagnostico].resource only DiagnosticoUrgencia
* entry[medicamento].resource only IndicacionMedicamentoUrgencia
* entry[documento].resource only DocumentoUrgencia

Profile: BundleAbandonoUrgencia
Parent: BundleUrgencia
Id: bundle-abandono-urgencia
Title: "Bundle de abandono de urgencia"
Description: "Evento abandono: el paciente se retira voluntariamente sin alta médica (fuga o NEA). Cierra el episodio (Encounter en finished). Si alcanzó a ser evaluado, puede incluir la hipótesis diagnóstica y el documento clínico."
* ^status = #draft
* ^abstract = false
* entry contains
    encuentro 1..1 MS and
    diagnostico 0..* MS and
    documento 0..1 MS
* entry[encuentro].resource only EncuentroUrgenciaAbandono
* entry[diagnostico].resource only DiagnosticoUrgencia
* entry[documento].resource only DocumentoUrgencia
