# Prosjektkontekst – Vitnemålsportalen

> **Sist oppdatert:** 2026-03-15
> **Roller:** Bruker er lærling, Claude er testleder/mentor.
> **Regler:** Små steg. Ett steg om gangen. Forklar alltid. Lærlingen bestemmer hvem som utfører. Ikke spør om ting mentor kan finne ut selv.

---

## Hva er gjort

### Fase 1 — Ferdig ✅
- Parent POM med Quarkus + jOOQ + Graphitron (opprinnelig Spring Boot, byttet til Sikt-stack)
- GraphQL-schema for resultat-service med Federation `@key`, beskrivelser, lint-godkjent
- Publisert schema til Apollo GraphOS (`vitnemalsportalengr-99q18sy@current`)
- Rover CLI autentisert mot GraphOS
- `supergraph.yaml` for lokal utvikling
- Dokumentasjon: domene.md, prosjektplan.md, teststrategi.md, federation-forklaring.md
- Git repo: https://github.com/ishfaqkhan80/vitnemalsportalen (pushet Fase 1)
- Fjernet demo-subgraf fra GraphOS (`rover subgraph delete ... --name subgraph`)

### Fase 2 — Pågår 🔨
**Siste fullførte steg:** 2.2 — Graphitron-direktiver lagt til i schema.graphql

**Ny prosjektstruktur:**
```
vitnemålsportalen/
├── pom.xml                          (parent: Quarkus BOM + jOOQ + Graphitron)
├── supergraph.yaml                  (kun resultat-service foreløpig)
├── dokumenter/
│   ├── domene.md
│   ├── prosjektplan.md
│   ├── teststrategi.md
│   └── federation-forklaring.md
└── resultat-service/
    ├── pom.xml                      (multi-modul: packaging pom)
    ├── resultat-service-db/         (jOOQ codegen fra PostgreSQL)
    │   ├── pom.xml
    │   └── src/main/resources/db/migration/V1__create_resultat_schema.sql
    ├── resultat-service-spec/       (Graphitron codegen fra schema)
    │   └── pom.xml
    └── resultat-service-server/     (Quarkus GraphQL-server)
        ├── pom.xml
        └── src/main/resources/schema.graphql
```

**Byggerrekkefølge:** db → spec → server (jOOQ først, deretter Graphitron, til slutt Quarkus-app)

## Hva ble gjort i steg 2.2

- Lagt til `@table` på Resultat, Institusjon, Grad, Emne (kobler GraphQL-typer til DB-tabeller)
- Lagt til `@field(name: "UTSTEDT_DATO")` på `utstedtDato` (camelCase → DB-kolonne)
- Lagt til `@field(name: "PERSON_ID")` på `personId`-argumentet i `resultater`-query
- Lagt til `@splitQuery` på `grad` og `emner` (separate DataFetchere for relasjoner)

## Neste steg

**Steg 2.3:** Starte PostgreSQL (Docker), kjøre SQL-migrasjonen

**Deretter:**
- Kjøre jOOQ-codegen (generere Java-klasser fra DB)
- Kjøre Graphitron-codegen (generere resolvers fra schema + jOOQ)
- Skrive Quarkus-server med GraphQL-endepunkt
- Teste med Apollo Sandbox

## Nøkkelinfo

| Nøkkel | Verdi |
|---|---|
| GraphOS Graph Ref | `vitnemalsportalengr-99q18sy@current` |
| GraphOS API Key | `service:vitnemalsportalengr-99q18sy:AsmFg6zvn7OVXFFNVwJcEQ` |
| GitHub repo | https://github.com/ishfaqkhan80/vitnemalsportalen |
| Java-versjon | 21 (Graphitron/Quarkus-kompatibel) |
| Graphitron-versjon | 8.6.1 |
| jOOQ-versjon | 3.20.11 |
| Quarkus-versjon | 3.19.2 |
| Rover CLI | 0.37.2 |

## Viktige versjoner i parent POM

```xml
<quarkus.platform.version>3.19.2</quarkus.platform.version>
<graphitron.version>8.6.1</graphitron.version>
<graphql-java.version>22.7</graphql-java.version>
<federation-graphql-java-support.version>5.4.0</federation-graphql-java-support.version>
<jooq.version>3.20.11</jooq.version>
<postgresql.version>42.7.5</postgresql.version>
<testcontainers.version>1.20.6</testcontainers.version>
```
