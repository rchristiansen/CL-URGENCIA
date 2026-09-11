Profile: DocumentoPDFUrgenciaDAU
Parent: DocumentReference
Id: documento-pdf-urgencia-dau
Title: "PDF del documento DAU"
Description: "Referencia al PDF generado por el HIS/RCE para el documento DAU."

* status 1..1 MS
* type 1..1 MS
* subject 1..1 MS
* subject only Reference(DauPatient)
* date 1..1 MS
* author 1..* MS
* author only Reference(ProfesionalUrgenciaDAU)
* custodian 1..1 MS
* custodian only Reference(OrganizacionUrgenciaDAU)
* context 1..1 MS
* context.encounter 1..1 MS
* context.encounter only Reference(DauEncounter)
* content 1..1 MS
* content.attachment 1..1 MS
* content.attachment.contentType 1..1 MS
* content.attachment.data 0..1 MS
* content.attachment.url 0..1 MS
* content.attachment.title 1..1 MS