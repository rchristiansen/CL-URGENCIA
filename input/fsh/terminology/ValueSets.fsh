RuleSet: MetadataVS
* ^status = #draft
* ^experimental = true

ValueSet: VSProcedencia
Id: vs-procedencia
Title: "Procedencia del paciente"
Description: "Procedencia del paciente al consultar en urgencia."
* insert MetadataVS
* include codes from system CSProcedencia

ValueSet: VSMedioLlegada
Id: vs-medio-llegada
Title: "Medio de llegada"
Description: "Medio de llegada del paciente a urgencia."
* insert MetadataVS
* include codes from system CSMedioLlegada

ValueSet: VSUnidadAtencion
Id: vs-unidad-atencion
Title: "Unidad de atención de urgencia"
Description: "Tipo de atención de urgencia asignada en la admisión."
* insert MetadataVS
* include codes from system CSUnidadAtencion

ValueSet: VSClasificacionConsulta
Id: vs-clasificacion-consulta
Title: "Clasificación de la consulta"
Description: "Clasificación médico-legal de la consulta de urgencia."
* insert MetadataVS
* include codes from system CSClasificacionConsulta

ValueSet: VSDestinoAlta
Id: vs-destino-alta
Title: "Destino al alta de urgencia"
Description: "Destinos válidos para el evento de alta."
* insert MetadataVS
* include codes from system CSDestinoAlta

ValueSet: VSTipoAbandono
Id: vs-tipo-abandono
Title: "Tipo de abandono de la atención"
Description: "Tipos de abandono válidos para el evento de abandono."
* insert MetadataVS
* include codes from system CSTipoAbandono

ValueSet: VSDestinoEgreso
Id: vs-destino-egreso
Title: "Destino de egreso de urgencia"
Description: "Todos los desenlaces con que puede cerrarse un episodio de urgencia: destinos de alta y tipos de abandono."
* insert MetadataVS
* include codes from system CSDestinoAlta
* include codes from system CSTipoAbandono

ValueSet: VSPronosticoMedicoLegal
Id: vs-pronostico-medico-legal
Title: "Pronóstico médico-legal"
Description: "Pronóstico médico-legal registrado al cierre de la atención."
* insert MetadataVS
* include codes from system CSPronosticoMedicoLegal

ValueSet: VSDiagnosticoUrgencia
Id: vs-diagnostico-urgencia
Title: "Diagnósticos de urgencia"
Description: "Diagnósticos codificados en CIE-10 (preferente) o SNOMED CT. Se acepta texto libre cuando el diagnóstico no está codificado."
* insert MetadataVS
* include codes from system $icd10
* include codes from system $sct where concept is-a #404684003 "Clinical finding"

ValueSet: VSUsoDiagnostico
Id: vs-uso-diagnostico
Title: "Uso del diagnóstico en el episodio"
Description: "Indica si el diagnóstico corresponde a la hipótesis inicial o al diagnóstico de egreso."
* insert MetadataVS
* $diagnosisRole#AD "Admission diagnosis"
* $diagnosisRole#DD "Discharge diagnosis"

ValueSet: VSEstadoEncuentroUrgencia
Id: vs-estado-encuentro-urgencia
Title: "Estado del encuentro de urgencia"
Description: "Subconjunto de estados de Encounter usados en urgencia."
* insert MetadataVS
* http://hl7.org/fhir/encounter-status#in-progress
* http://hl7.org/fhir/encounter-status#finished
* http://hl7.org/fhir/encounter-status#entered-in-error
