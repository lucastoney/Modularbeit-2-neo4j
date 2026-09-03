// Reproduzierbarer CSV-Import für Neo4j 5.x.
// Alle CSV-Dateien müssen im Import-Verzeichnis der aktiven Datenbank liegen.
// Empfohlene Reihenfolge: 00_cleanup -> 01_constraints -> 03_import_csv.

// 1. Node-Daten importieren
LOAD CSV WITH HEADERS FROM 'file:///personen.csv' AS row
MERGE (n:Person {personId: row.personId})
SET n.vorname = row.vorname,
    n.nachname = row.nachname,
    n.abteilung = row.abteilung,
    n.status = row.status,
    n.gefahrenstufe = row.gefahrenstufe;

LOAD CSV WITH HEADERS FROM 'file:///rollen.csv' AS row
MERGE (n:Rolle {rolleId: row.rolleId})
SET n.name = row.name,
    n.beschreibung = row.beschreibung;

LOAD CSV WITH HEADERS FROM 'file:///ausweise.csv' AS row
MERGE (n:Ausweis {ausweisId: row.ausweisId})
SET n.kartennummer = row.kartennummer,
    n.status = row.status,
    n.`gültigBis` = date(row.`gültigBis`);

LOAD CSV WITH HEADERS FROM 'file:///berechtigungsgruppen.csv' AS row
MERGE (n:Berechtigungsgruppe {gruppeId: row.gruppeId})
SET n.name = row.name,
    n.risikostufe = row.risikostufe;

LOAD CSV WITH HEADERS FROM 'file:///zonen.csv' AS row
MERGE (n:Sicherheitszone {zoneId: row.zoneId})
SET n.name = row.name,
    n.stufe = row.stufe;

LOAD CSV WITH HEADERS FROM 'file:///raeume.csv' AS row
MERGE (n:Raum {raumId: row.raumId})
SET n.name = row.name,
    n.funktion = row.funktion,
    n.`kritikalität` = row.`kritikalität`;

LOAD CSV WITH HEADERS FROM 'file:///tueren.csv' AS row
MERGE (n:`Tür` {`türId`: row.`türId`})
SET n.bezeichnung = row.bezeichnung,
    n.sicherheitsrelevant = toBoolean(row.sicherheitsrelevant),
    n.`sicherheitstür` = toBoolean(row.`sicherheitstür`);

LOAD CSV WITH HEADERS FROM 'file:///leser.csv' AS row
MERGE (n:Leser {leserId: row.leserId})
SET n.bezeichnung = row.bezeichnung,
    n.typ = row.typ;

LOAD CSV WITH HEADERS FROM 'file:///controller.csv' AS row
MERGE (n:Controller {controllerId: row.controllerId})
SET n.name = row.name,
    n.standort = row.standort;

LOAD CSV WITH HEADERS FROM 'file:///systeme.csv' AS row
MERGE (n:Sicherheitssystem {systemId: row.systemId})
SET n.name = row.name,
    n.typ = row.typ,
    n.status = row.status;

LOAD CSV WITH HEADERS FROM 'file:///alarme.csv' AS row
MERGE (n:Alarm {alarmId: row.alarmId})
SET n.typ = row.typ,
    n.schweregrad = row.schweregrad,
    n.status = row.status,
    n.zeitpunkt = datetime(row.zeitpunkt);

// 2. Organisatorische Relationships importieren
LOAD CSV WITH HEADERS FROM 'file:///personen.csv' AS row
MATCH (p:Person {personId: row.personId})
MATCH (r:Rolle {rolleId: row.rolleId})
MATCH (a:Ausweis {ausweisId: row.ausweisId})
MERGE (p)-[:HAT_ROLLE]->(r)
MERGE (p)-[:HAT_AUSWEIS]->(a);

LOAD CSV WITH HEADERS FROM 'file:///rollen.csv' AS row
MATCH (r:Rolle {rolleId: row.rolleId})
MATCH (g:Berechtigungsgruppe {gruppeId: row.gruppeId})
MERGE (r)-[:NUTZT_BERECHTIGUNGSGRUPPE]->(g);

// Das Semikolon trennt mehrere Tür-IDs innerhalb einer CSV-Zelle.
LOAD CSV WITH HEADERS FROM 'file:///berechtigungsgruppen.csv' AS row
UNWIND split(row.`türIds`, ';') AS türId
MATCH (g:Berechtigungsgruppe {gruppeId: row.gruppeId})
MATCH (t:`Tür` {`türId`: trim(türId)})
MERGE (g)-[:ERLAUBT_ZUGANG_ZU]->(t);

// 3. Räumliche und technische Relationships importieren
LOAD CSV WITH HEADERS FROM 'file:///tueren.csv' AS row
MATCH (t:`Tür` {`türId`: row.`türId`})
MATCH (r:Raum {raumId: row.raumId})
MATCH (l:Leser {leserId: row.leserId})
MERGE (t)-[:`FÜHRT_ZU`]->(r)
MERGE (t)-[:HAT_LESER]->(l);

LOAD CSV WITH HEADERS FROM 'file:///raeume.csv' AS row
MATCH (r:Raum {raumId: row.raumId})
MATCH (z:Sicherheitszone {zoneId: row.zoneId})
MERGE (r)-[:LIEGT_IN_ZONE]->(z);

LOAD CSV WITH HEADERS FROM 'file:///leser.csv' AS row
MATCH (l:Leser {leserId: row.leserId})
MATCH (c:Controller {controllerId: row.controllerId})
MERGE (l)-[:ANGEBUNDEN_AN]->(c);

// Systeme überwachen mehrere Räume und Zonen.
LOAD CSV WITH HEADERS FROM 'file:///systeme.csv' AS row
UNWIND split(row.raumIds, ';') AS raumId
MATCH (s:Sicherheitssystem {systemId: row.systemId})
MATCH (r:Raum {raumId: trim(raumId)})
MERGE (s)-[:`ÜBERWACHT_RAUM`]->(r);

LOAD CSV WITH HEADERS FROM 'file:///systeme.csv' AS row
UNWIND split(row.zoneIds, ';') AS zoneId
MATCH (s:Sicherheitssystem {systemId: row.systemId})
MATCH (z:Sicherheitszone {zoneId: trim(zoneId)})
MERGE (s)-[:`ÜBERWACHT_ZONE`]->(z);

// Alarme werden mit ihrem Raum, ihrer Zone und dem auslösenden System verbunden.
LOAD CSV WITH HEADERS FROM 'file:///alarme.csv' AS row
MATCH (a:Alarm {alarmId: row.alarmId})
MATCH (r:Raum {raumId: row.raumId})
MATCH (z:Sicherheitszone {zoneId: row.zoneId})
MATCH (s:Sicherheitssystem {systemId: row.systemId})
MERGE (a)-[:BETRIFFT_RAUM]->(r)
MERGE (a)-[:BETRIFFT_ZONE]->(z)
MERGE (a)-[:`AUSGELÖST_DURCH`]->(s);

// Abschlusskontrolle des Imports.
MATCH (n)
RETURN labels(n) AS labels, count(*) AS anzahl
ORDER BY labels;
