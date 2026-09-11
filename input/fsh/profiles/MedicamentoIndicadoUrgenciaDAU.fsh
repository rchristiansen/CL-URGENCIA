Profile: MedicamentoIndicadoUrgenciaDAU
Parent: MedicationRequest
Id: medicamento-indicado-urgencia-dau
Title: "Medicamento indicado en urgencia"
Description: "Medicamento prescrito o indicado al cierre de la atención."

* identifier 0..* MS
* status 1..1 MS
* intent 1..1 MS
* medication[x] 1..1 MS
* subject 1..1 MS
* subject only Reference(DauPatient)
* encounter 1..1 MS
* encounter only Reference(DauEncounter)
* authoredOn 1..1 MS
* requester 1..1 MS
* requester only Reference(ProfesionalUrgenciaDAU)
* dosageInstruction 1..* MS
* dispenseRequest 0..1 MS
* note 0..* MS