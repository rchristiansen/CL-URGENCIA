// Terminologías internacionales
Alias: $loinc = http://loinc.org
Alias: $sct = http://snomed.info/sct
Alias: $icd10 = http://hl7.org/fhir/sid/icd-10
Alias: $v3ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $v3ParticipationType = http://terminology.hl7.org/CodeSystem/v3-ParticipationType
Alias: $diagnosisRole = http://terminology.hl7.org/CodeSystem/diagnosis-role
Alias: $conditionClinical = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $conditionVerStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status

// CL-Core
Alias: $CSTipoIdentificador = https://hl7chile.cl/fhir/ig/clcore/CodeSystem/CSTipoIdentificador
Alias: $CSSexoListadoDeis = https://hl7chile.cl/fhir/ig/clcore/CodeSystem/CSSexoListadoDeis
Alias: $CSEspecialidadesDeisCL = https://hl7chile.cl/fhir/ig/clcore/CodeSystem/CSEspecialidadesDeisCL
Alias: $SexoBiologico = https://hl7chile.cl/fhir/ig/clcore/StructureDefinition/SexoBiologico

Alias: $CodigoPaises = https://hl7chile.cl/fhir/ig/clcore/StructureDefinition/CodigoPaises
Alias: $CodPais = https://hl7chile.cl/fhir/ig/clcore/CodeSystem/CodPais
Alias: $IdentidadDeGenero = https://hl7chile.cl/fhir/ig/clcore/StructureDefinition/IdentidadDeGenero
Alias: $CSIdentidaddeGenero = https://hl7chile.cl/fhir/ig/clcore/CodeSystem/CSIdentidaddeGenero

// NID - Núcleo de Interoperabilidad de Datos (hl7.fhir.cl.minsal.nid 0.4.6)
Alias: $MINSALPaciente = https://interoperabilidad.minsal.cl/fhir/ig/nid/StructureDefinition/MINSALPaciente
Alias: $MINSALPrestadorProfesional = https://interoperabilidad.minsal.cl/fhir/ig/nid/StructureDefinition/MINSALPrestadorProfesional
Alias: $MINSALPrestadorOrganizacional = https://interoperabilidad.minsal.cl/fhir/ig/nid/StructureDefinition/MINSALPrestadorOrganizacional
Alias: $PaisOrigenMPI = https://interoperabilidad.minsal.cl/fhir/ig/nid/StructureDefinition/PaisOrigenMPI
Alias: $VSPrevisionNID = https://interoperabilidad.minsal.cl/fhir/ig/nid/ValueSet/VSPrevision
Alias: $VSTramosFONASA = https://interoperabilidad.minsal.cl/fhir/ig/nid/ValueSet/VSTramosFONASA
Alias: $VSLeyPrevisionales = https://interoperabilidad.minsal.cl/fhir/ig/nid/ValueSet/VSLeyPrevisionales
Alias: $CSPrevisionNID = https://interoperabilidad.minsal.cl/fhir/ig/nid/CodeSystem/CSPrevision
Alias: $CSTramosFONASA = https://interoperabilidad.minsal.cl/fhir/ig/nid/CodeSystem/CSTramosFONASA
Alias: $CSLeyPrevisionales = https://interoperabilidad.minsal.cl/fhir/ig/nid/CodeSystem/CSLeyPrevisionales
Alias: $CSTituloProfesionalNID = https://interoperabilidad.minsal.cl/fhir/ig/nid/CodeSystem/CSTituloProfesional

// Sistemas de identificadores
// RUN: el mismo OID que usan los ejemplos del NID.
Alias: $sidRUN = urn:oid:2.16.840.1.113883.2.22.1.152.787300
// Establecimientos DEIS: el mismo sistema que usan las guías MINSAL (TEI / Lista de Espera).
Alias: $sidDEIS = https://interoperabilidad.minsal.cl/fhir/ig/tei/CodeSystem/CSEstablecimientoDestino
