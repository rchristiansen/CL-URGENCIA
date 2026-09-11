Profile: ObservacionUrgenciaDAU
Parent: Observation
Id: observacion-urgencia-dau
Title: "Observación clínica de urgencia"
Description: "Categorización, signo vital, escala o medición clínica del DAU."

* status 1..1 MS
* category 1..1 MS
* code 1..1 MS
* subject 1..1 MS
* subject only Reference(DauPatient)
* encounter 1..1 MS
* encounter only Reference(DauEncounter)
* effective[x] 1..1 MS
* value[x] 0..1 MS
* component 0..* MS
* performer 0..* MS
* performer only Reference(ProfesionalUrgenciaDAU)
* interpretation 0..* MS
* note 0..* MS