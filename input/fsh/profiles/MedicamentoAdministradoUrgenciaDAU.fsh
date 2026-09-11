Profile: MedicamentoAdministradoUrgenciaDAU
Parent: MedicationAdministration
Id: medicamento-administrado-urgencia-dau
Title: "Medicamento administrado en urgencia"
Description: "Medicamento administrado efectivamente durante la atención."

* status 1..1 MS
* medication[x] 1..1 MS
* subject 1..1 MS
* subject only Reference(DauPatient)
* context 1..1 MS
* context only Reference(DauEncounter)
* effective[x] 1..1 MS
* performer 0..* MS
* performer.actor only Reference(ProfesionalUrgenciaDAU)
* dosage 0..1 MS
* note 0..* MS