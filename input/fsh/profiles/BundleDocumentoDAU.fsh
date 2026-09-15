Profile: BundleDocumentoDAU
Parent: Bundle
Id: bundle-documento-dau
Title: "DAU - Bundle documental"
Description: "Bundle FHIR R4 de tipo document para transportar el documento clínico DAU."
* ^url = "https://interoperabilidad.minsal.cl/fhir/ig/urgencia/StructureDefinition/bundle-documento-dau"
* ^status = #draft
* ^version = "0.1.0"
* identifier 1..1 MS
* type 1..1 MS
* type = #document
* timestamp 1..1 MS
* entry 1..* MS
* entry ^slicing.discriminator.type = #profile
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry contains composition 1..1 MS
* entry[composition].resource 1..1 MS
* entry[composition].resource only ComposicionDocumentoDAU
