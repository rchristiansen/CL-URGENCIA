CodeSystem: TipoDocumentoDAU
Id: tipo-documento-dau
Title: "Tipo de documento DAU"
Description: "Tipos de documentos clínicos del dominio de urgencia."
* ^status = #draft
* ^content = #complete
* ^caseSensitive = true
* #dau "Datos de Atención de Urgencia"

CodeSystem: SeccionesDAU
Id: secciones-dau
Title: "Secciones del documento DAU"
Description: "Secciones clínicas del documento de atención de urgencia."
* ^status = #draft
* ^content = #complete
* ^caseSensitive = true
* #resumen "Resumen de la atención"
* #admision "Admisión e identificación"
* #categorizacion "Categorización y signos vitales"
* #atencion "Atención clínica"
* #diagnosticos "Diagnósticos"
* #solicitudes "Solicitudes de exámenes y procedimientos"
* #tratamientos "Tratamientos y procedimientos"
* #egreso "Egreso e indicaciones"

CodeSystem: CondicionEgresoDAU
Id: condicion-egreso-dau
Title: "Condición de egreso DAU"
Description: "Condiciones de cierre de una atención de urgencia."
* ^status = #draft
* ^content = #complete
* ^caseSensitive = true
* #alta "Alta"
* #hospitalizacion "Hospitalización"
* #traslado "Traslado o derivación"
* #abandono "Abandono"
* #nea "No espera atención"
* #fallecido "Fallecido"

CodeSystem: TipoDiagnosticoDAU
Id: tipo-diagnostico-dau
Title: "Tipo de diagnóstico DAU"
Description: "Clasificación funcional de los diagnósticos registrados."
* ^status = #draft
* ^content = #complete
* ^caseSensitive = true
* #hipotesis "Hipótesis diagnóstica"
* #principal "Diagnóstico principal"
* #secundario "Diagnóstico secundario"
* #final "Diagnóstico final"

ValueSet: VSTipoDocumentoDAU
Id: vs-tipo-documento-dau
Title: "Tipos de documento DAU"
Description: "Tipos de documento clínico definidos para la atención de urgencia."
* include codes from system TipoDocumentoDAU

ValueSet: VSSeccionesDAU
Id: vs-secciones-dau
Title: "Secciones del documento DAU"
Description: "Secciones permitidas en la Composition del DAU."
* include codes from system SeccionesDAU

ValueSet: VSCondicionEgresoDAU
Id: vs-condicion-egreso-dau
Title: "Condición de egreso DAU"
Description: "Condiciones de cierre de la atención de urgencia."
* include codes from system CondicionEgresoDAU

ValueSet: VSTipoDiagnosticoDAU
Id: vs-tipo-diagnostico-dau
Title: "Tipo de diagnóstico DAU"
Description: "Clasificación funcional de los diagnósticos del DAU."
* include codes from system TipoDiagnosticoDAU
