// El Encounter es el recurso central: un solo episodio desde la admisión hasta el
// alta o el abandono. Cada evento reenvía el mismo Encounter (mismo identifier)
// con su estado actualizado. Los perfiles por evento solo agregan las reglas de
// ese momento sobre el perfil base.

Invariant: urg-enc-1
Description: "Un episodio finalizado debe informar la fecha y hora de término (period.end)."
Severity: #error
Expression: "status = 'finished' implies period.end.exists()"

Invariant: urg-enc-2
Description: "Un episodio finalizado debe informar el destino de egreso o el tipo de abandono."
Severity: #error
Expression: "status = 'finished' implies hospitalization.dischargeDisposition.exists()"

Profile: EncuentroUrgencia
Parent: EncounterCL
Id: encuentro-urgencia
Title: "Encuentro de urgencia"
Description: "Episodio de atención en una unidad de urgencia, desde la admisión hasta el alta o el abandono. Basado en EncounterCL de CL-Core. Es el recurso que la red usa para saber que el paciente estuvo en urgencia, cuándo y cómo terminó."
* ^status = #draft
* obeys urg-enc-1 and urg-enc-2
* extension contains
    Prevision named prevision 0..1 MS and
    LeyPrevisional named leyPrevisional 0..* MS and
    ClasificacionConsulta named clasificacionConsulta 0..1 and
    PronosticoMedicoLegal named pronosticoMedicoLegal 0..1 and
    Pertinencia named pertinencia 0..1
* identifier 1..* MS
* identifier ^short = "ID DAU: identificador único del episodio en el establecimiento"
* identifier ^definition = "Identificador único del episodio de urgencia (ID DAU del CMBD). Debe ser el mismo en los mensajes de admisión, alta y abandono: es la llave con que la red correlaciona los eventos."
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* status 1..1 MS
* status from VSEstadoEncuentroUrgencia (required)
* status ^short = "in-progress (admitido) | finished (alta o abandono) | entered-in-error"
* class 1..1 MS
* class = $v3ActCode#EMER
* serviceType 0..1 MS
* serviceType from VSUnidadAtencion (required)
* serviceType ^short = "Unidad de atención: pediatría, adulto, gineco-obstétrica, odontológica..."
* subject 1..1 MS
* subject only Reference($MINSALPaciente)
* participant MS
* participant ^short = "Profesional que da el alta o atiende"
* participant.type MS
* participant.individual only Reference($MINSALPrestadorProfesional)
* period 1..1 MS
* period.start 1..1 MS
* period.start ^short = "Fecha y hora de admisión"
* period.end MS
* period.end ^short = "Fecha y hora de alta o de detección del abandono"
* reasonCode 0..1 MS
* reasonCode ^short = "Motivo de consulta (texto libre, hasta 200 caracteres)"
* reasonCode.text 1..1 MS
* diagnosis MS
* diagnosis ^short = "Hipótesis diagnóstica (AD) y diagnóstico de egreso (DD)"
* diagnosis.condition ^short = "Referencia a un Diagnóstico de urgencia incluido en el mismo mensaje"
* diagnosis.use 1..1 MS
* diagnosis.use from VSUsoDiagnostico (required)
* diagnosis.rank MS
* hospitalization MS
* hospitalization.extension contains MedioLlegada named medioLlegada 0..1 MS
* hospitalization.admitSource MS
* hospitalization.admitSource from VSProcedencia (required)
* hospitalization.admitSource ^short = "Procedencia del paciente"
* hospitalization.dischargeDisposition MS
* hospitalization.dischargeDisposition from VSDestinoEgreso (required)
* hospitalization.dischargeDisposition ^short = "Destino de alta o tipo de abandono"
* hospitalization.destination MS
* hospitalization.destination ^short = "Establecimiento de destino (traslado o derivación)"
* serviceProvider 1..1 MS
* serviceProvider only Reference($MINSALPrestadorOrganizacional)

Profile: EncuentroUrgenciaAdmision
Parent: EncuentroUrgencia
Id: encuentro-urgencia-admision
Title: "Encuentro de urgencia - Admisión"
Description: "Estado del episodio al momento de la admisión: abierto, sin fecha de término ni destino."
* ^status = #draft
* status = #in-progress
* period.end 0..0
* hospitalization.dischargeDisposition 0..0

Profile: EncuentroUrgenciaAlta
Parent: EncuentroUrgencia
Id: encuentro-urgencia-alta
Title: "Encuentro de urgencia - Alta"
Description: "Estado del episodio al alta: cerrado, con fecha de alta, destino indicado y diagnóstico de egreso."
* ^status = #draft
* status = #finished
* period.end 1..1
* diagnosis 1..*
* hospitalization 1..1
* hospitalization.dischargeDisposition 1..1
* hospitalization.dischargeDisposition from VSDestinoAlta (required)

Profile: EncuentroUrgenciaAbandono
Parent: EncuentroUrgencia
Id: encuentro-urgencia-abandono
Title: "Encuentro de urgencia - Abandono"
Description: "Estado del episodio cuando el paciente se retira voluntariamente sin alta médica (fuga o NEA): cerrado, con la fecha y hora en que se constató el abandono y el tipo de abandono."
* ^status = #draft
* status = #finished
* period.end 1..1
* period.end ^short = "Fecha y hora en que se constata el abandono"
* hospitalization 1..1
* hospitalization.dischargeDisposition 1..1
* hospitalization.dischargeDisposition from VSTipoAbandono (required)
