// Extensiones para datos del CMBD de Urgencia que no tienen un elemento FHIR R4 equivalente.
// Todas son opcionales: no son necesarias para la continuidad de la atención,
// pero permiten que los mismos mensajes alimenten la estadística nacional.

RuleSet: MetadataExt
* ^status = #draft
* ^experimental = true

Extension: MedioLlegada
Id: medio-llegada
Title: "Medio de llegada"
Description: "Medio de transporte con que el paciente llega a la unidad de urgencia."
* insert MetadataExt
* ^context[0].type = #element
* ^context[=].expression = "Encounter.hospitalization"
* value[x] only CodeableConcept
* value[x] from VSMedioLlegada (required)

Extension: Prevision
Id: prevision
Title: "Previsión de salud"
Description: "Previsión de salud del paciente al momento de la atención y, si es FONASA, su tramo."
* insert MetadataExt
* ^context[0].type = #element
* ^context[=].expression = "Encounter"
* extension contains
    prevision 1..1 MS and
    tramoFonasa 0..1 MS
* extension[prevision].value[x] only CodeableConcept
* extension[prevision].value[x] from $VSPrevisionNID (required)
* extension[prevision] ^short = "Previsión de salud"
* extension[tramoFonasa].value[x] only CodeableConcept
* extension[tramoFonasa].value[x] from $VSTramosFONASA (required)
* extension[tramoFonasa] ^short = "Tramo FONASA (solo si la previsión es FONASA)"

Extension: LeyPrevisional
Id: ley-previsional
Title: "Ley previsional o programa"
Description: "Ley social o programa que cubre la atención de urgencia. Usa la terminología del NID; el binding es extensible porque el NID aún no incluye PRAIS (código 05 del CMBD)."
* insert MetadataExt
* ^context[0].type = #element
* ^context[=].expression = "Encounter"
* value[x] only CodeableConcept
* value[x] from $VSLeyPrevisionales (extensible)

Extension: ClasificacionConsulta
Id: clasificacion-consulta
Title: "Clasificación de la consulta"
Description: "Clasificación médico-legal de la consulta registrada en la admisión."
* insert MetadataExt
* ^context[0].type = #element
* ^context[=].expression = "Encounter"
* value[x] only CodeableConcept
* value[x] from VSClasificacionConsulta (required)

Extension: PronosticoMedicoLegal
Id: pronostico-medico-legal
Title: "Pronóstico médico-legal"
Description: "Pronóstico médico-legal registrado al cierre de la atención."
* insert MetadataExt
* ^context[0].type = #element
* ^context[=].expression = "Encounter"
* value[x] only CodeableConcept
* value[x] from VSPronosticoMedicoLegal (required)

Extension: Pertinencia
Id: pertinencia
Title: "Pertinencia de la atención"
Description: "Indica si la consulta fue pertinente para una unidad de urgencia."
* insert MetadataExt
* ^context[0].type = #element
* ^context[=].expression = "Encounter"
* value[x] only boolean

Extension: DiagnosticoGES
Id: diagnostico-ges
Title: "Diagnóstico GES"
Description: "Indica si el diagnóstico corresponde a un problema de salud con Garantías Explícitas en Salud (GES)."
* insert MetadataExt
* ^context[0].type = #element
* ^context[=].expression = "Condition"
* value[x] only boolean
