// Códigos locales de la guía. Los dominios provienen del CMBD de Urgencia (DEIS)
// salvo que se indique otra fuente. Se mantienen experimentales hasta su
// publicación en el Servidor Terminológico Nacional.

RuleSet: MetadataCS
* ^status = #draft
* ^experimental = true
* ^content = #complete
* ^caseSensitive = true

CodeSystem: CSProcedencia
Id: procedencia
Title: "Procedencia del paciente"
Description: "Origen del paciente al consultar en urgencia (CMBD Urgencia: PROCEDENCIA DEL PACIENTE)."
* insert MetadataCS
* #1 "Referido de unidad de emergencia"
* #2 "Referido de APS"
* #3 "Referido de atención de especialidades"
* #4 "Referido de establecimiento extra-red"
* #5 "Referido de otra procedencia"
* #6 "Espontáneo"
* #7 "SAPU"

CodeSystem: CSMedioLlegada
Id: medio-llegada
Title: "Medio de llegada"
Description: "Medio de transporte con que el paciente llega a urgencia (CMBD Urgencia: LLEGADA)."
* insert MetadataCS
* #1 "SAMU básica"
* #2 "SAMU avanzada"
* #3 "SAMU medicalizada"
* #4 "Vehículo de Carabineros o PDI"
* #5 "Por sus propios medios"
* #6 "Vehículo particular"
* #7 "Otra ambulancia medicalizada"
* #8 "Otra ambulancia avanzada"
* #9 "Otra ambulancia básica"
* #10 "Marítimo (crítico)"
* #11 "No crítico (aéreo)"
* #12 "No crítico (marítimo)"
* #13 "Otros vehículos no motorizados"
* #14 "A pie"
* #15 "Gendarmería"
* #16 "Bomberos"
* #17 "Desconocido"

CodeSystem: CSUnidadAtencion
Id: unidad-atencion
Title: "Unidad de atención de urgencia"
Description: "Tipo de atención asignada en la admisión (CMBD Urgencia: UNIDAD DE ATENCIÓN)."
* insert MetadataCS
* #01 "Atención de pediatría"
* #02 "Atención de adulto"
* #03 "Atención gineco-obstétrica"
* #04 "Atención odontológica"
* #05 "Atención niño y adulto"
* #06 "Otros"

CodeSystem: CSClasificacionConsulta
Id: clasificacion-consulta
Title: "Clasificación de la consulta"
Description: "Clasificación médico-legal de la consulta (CMBD Urgencia: CLASIFICACIÓN DE LA CONSULTA)."
* insert MetadataCS
* #01 "Abuso sexual"
* #02 "Maltrato - violencia de género"
* #03 "Constatar lesiones"
* #04 "Alcoholemia"
* #05 "Procedimiento policial"
* #09 "Otros"

CodeSystem: CSDestinoAlta
Id: destino-alta
Title: "Destino al alta de urgencia"
Description: "Destino indicado por el profesional al dar el alta de urgencia (CMBD Urgencia: DESTINO_ALTA; NT 149 con ajustes DGTIC)."
* insert MetadataCS
* #01 "Hospitalización"
* #02 "Traslado"
* #03 "Fallecido"
* #04 "Derivación"
* #05 "Domicilio"
* #06 "Otro"

CodeSystem: CSTipoAbandono
Id: tipo-abandono
Title: "Tipo de abandono de la atención"
Description: "Momento en que el paciente abandona voluntariamente la atención de urgencia. Códigos alineados con la versión 0.1.2-ballot de esta guía."
* insert MetadataCS
* #1 "Abandono antes de la atención médica (NEA)" "El paciente se retira antes de ser atendido por el profesional: No Espera Atención."
* #2 "Abandono durante la atención médica (fuga)" "El paciente se retira después de iniciada la atención, sin alta médica."

CodeSystem: CSPronosticoMedicoLegal
Id: pronostico-medico-legal
Title: "Pronóstico médico-legal"
Description: "Pronóstico médico-legal registrado al cierre (CMBD Urgencia: PRONÓSTICO MÉDICO LEGAL)."
* insert MetadataCS
* #01 "Leve"
* #02 "Mediana gravedad"
* #03 "Grave"
* #04 "Sin lesiones"
