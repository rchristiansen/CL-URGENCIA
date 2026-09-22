Profile: DiagnosticoUrgenciaDAU
Parent: CoreDiagnosticoCl
Id: diagnostico-urgencia-dau
Title: "Diagnóstico de atención de urgencia"
Description: "Hipótesis o diagnóstico registrado durante la atención de urgencia."

* clinicalStatus 1..1 MS
* verificationStatus 1..1 MS
* category 1..1 MS
* category.coding 1..* MS
* category from VSTipoDiagnosticoDAU (required)
* code 1..1 MS
* code.coding 1..* MS
* subject 1..1 MS
* subject only Reference(DauPatient)
* encounter 1..1 MS
* encounter only Reference(DauEncounter)
* onset[x] 0..1 MS
* recordedDate 0..1 MS
* recorder only Reference(ProfesionalUrgenciaDAU)
