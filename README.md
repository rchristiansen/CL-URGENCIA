# Guía de Implementación FHIR - Urgencia (Admisión, Alta y Abandono)

Guía de Implementación (IG) FHIR R4 que define **lo mínimo** que un establecimiento debe informar a la red cuando atiende a una persona en urgencia, para dar **continuidad a la atención**: quién fue atendido, dónde, cuándo, cómo terminó, qué diagnóstico tuvo, qué se le indicó y dónde está el documento clínico completo (PDF).

## Estado

- Versión: 0.2.0
- Estado FHIR: draft
- FHIR: R4 (4.0.1)
- Publicador: Unidad de Interoperabilidad, MINSAL
- Canonical: `https://interoperabilidad.minsal.cl/fhir/ig/urgencia`
- Dependencias: CL-Core `1.9.2`, NID `0.4.6`

## Modelo

Tres eventos, cada uno un `Bundle` de tipo `transaction` en que todas las entradas son `PUT` condicional por identificador. La información queda disponible para la red asistencial y para el paciente en HCC (Portal Ciudadano).

| Evento | Cuándo | `Encounter.status` | Contenido clave |
|---|---|---|---|
| `admision` | Al admitir al paciente | `in-progress` | Paciente, establecimiento, fecha/hora de admisión, motivo, procedencia, llegada |
| `alta` | Al dar el alta médica | `finished` | Fecha/hora de alta, destino, diagnóstico de egreso, medicamentos, PDF |
| `abandono` | Al constatar fuga o NEA | `finished` | Fecha/hora de abandono, tipo de abandono, hipótesis y PDF si existen |

El `Encounter` es el recurso central: un único episodio identificado por el **ID DAU**, que se reenvía con su estado actualizado en cada evento.

## Perfiles

| Perfil | Recurso | Uso |
|---|---|---|
| `TransaccionAdmisionUrgencia` | Bundle (transaction) | Evento admisión. |
| `TransaccionAltaUrgencia` | Bundle (transaction) | Evento alta. |
| `TransaccionAbandonoUrgencia` | Bundle (transaction) | Evento abandono. |
| `EncuentroUrgencia` (+ `Admision`, `Alta`, `Abandono`) | Encounter | Episodio de urgencia. |
| `MINSALPaciente` (NID) | Patient | Perfil del NID, usado directamente. |
| `MINSALPrestadorOrganizacional` (NID) | Organization | Perfil del NID, usado directamente. |
| `MINSALPrestadorProfesional` (NID) | Practitioner | Perfil del NID, usado directamente. |
| `DiagnosticoUrgencia` | Condition | Sobre CL-Core `CoreDiagnosticoCl`. |
| `IndicacionMedicamentoUrgencia` | MedicationRequest | Medicamentos indicados al alta. |
| `DocumentoUrgencia` | DocumentReference | Enlace al PDF del DAU. |

## Estructura del proyecto

```text
input/fsh/
├── aliases.fsh
├── profiles/      EncuentroUrgencia.fsh · Clinicos.fsh · Transacciones.fsh
├── extensions/    Extensiones.fsh
├── terminology/   CodeSystems.fsh · ValueSets.fsh
└── examples/      Actores.fsh · Transacciones.fsh
input/pagecontent/ index · modelo · arquitectura · casos-de-uso · mapeo-cmbd · historial-de-cambios
```

## Build

```bash
npm install          # instala SUSHI
npm run doctor       # verifica Node, Java, Jekyll y publisher.jar
npm run publisher    # descarga el IG Publisher
npm run build        # SUSHI + IG Publisher
npm run serve        # sirve la guía en http://localhost:8081
```

Ver `ENTREGA_DESARROLLO.md` para decisiones de diseño y pendientes.
