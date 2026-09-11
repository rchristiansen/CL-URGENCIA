Profile: ProcedimientoUrgenciaDAU
Parent: Procedure
Id: procedimiento-urgencia-dau
Title: "Procedimiento realizado en urgencia"
Description: "Procedimiento efectuado durante la atención de urgencia."

* identifier 0..* MS
* status 1..1 MS
* code 1..1 MS
* subject 1..1 MS
* subject only Reference(DauPatient)
* encounter 1..1 MS
* encounter only Reference(DauEncounter)
* performed[x] 1..1 MS
* performer 0..* MS
* performer.actor only Reference(ProfesionalUrgenciaDAU)
* reasonReference 0..* MS
* reasonReference only Reference(DiagnosticoUrgenciaDAU)
* note 0..* MS