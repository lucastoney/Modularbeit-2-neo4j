// FUNKTIONSNACHWEIS 1: Gesamtumfang
// Erwartet werden 61 Nodes und 103 Relationships.
MATCH (n)
WITH count(n) AS nodes
MATCH ()-[r]->()
RETURN nodes,
       count(r) AS relationships,
       CASE WHEN nodes = 61 AND count(r) = 103
            THEN 'OK' ELSE 'PRÜFEN' END AS ergebnis;

// FUNKTIONSNACHWEIS 2: Anzahl pro Node-Label
MATCH (n:Person) RETURN 'Person' AS typ, count(n) AS ist, 7 AS soll
UNION ALL
MATCH (n:Rolle) RETURN 'Rolle' AS typ, count(n) AS ist, 6 AS soll
UNION ALL
MATCH (n:Ausweis) RETURN 'Ausweis' AS typ, count(n) AS ist, 7 AS soll
UNION ALL
MATCH (n:Berechtigungsgruppe) RETURN 'Berechtigungsgruppe' AS typ, count(n) AS ist, 6 AS soll
UNION ALL
MATCH (n:`Tür`) RETURN 'Tür' AS typ, count(n) AS ist, 7 AS soll
UNION ALL
MATCH (n:Raum) RETURN 'Raum' AS typ, count(n) AS ist, 6 AS soll
UNION ALL
MATCH (n:Sicherheitszone) RETURN 'Sicherheitszone' AS typ, count(n) AS ist, 4 AS soll
UNION ALL
MATCH (n:Leser) RETURN 'Leser' AS typ, count(n) AS ist, 7 AS soll
UNION ALL
MATCH (n:Controller) RETURN 'Controller' AS typ, count(n) AS ist, 3 AS soll
UNION ALL
MATCH (n:Alarm) RETURN 'Alarm' AS typ, count(n) AS ist, 5 AS soll
UNION ALL
MATCH (n:Sicherheitssystem) RETURN 'Sicherheitssystem' AS typ, count(n) AS ist, 3 AS soll;

// FUNKTIONSNACHWEIS 3: Relationship-Typen mit Sollwerten
MATCH ()-[r]->()
WITH type(r) AS typ, count(r) AS ist
RETURN typ,
       ist,
       CASE typ
         WHEN 'HAT_ROLLE' THEN 7
         WHEN 'HAT_AUSWEIS' THEN 7
         WHEN 'NUTZT_BERECHTIGUNGSGRUPPE' THEN 6
         WHEN 'ERLAUBT_ZUGANG_ZU' THEN 18
         WHEN 'FÜHRT_ZU' THEN 7
         WHEN 'HAT_LESER' THEN 7
         WHEN 'ANGEBUNDEN_AN' THEN 7
         WHEN 'LIEGT_IN_ZONE' THEN 6
         WHEN 'ÜBERWACHT_RAUM' THEN 13
         WHEN 'ÜBERWACHT_ZONE' THEN 10
         WHEN 'BETRIFFT_RAUM' THEN 5
         WHEN 'BETRIFFT_ZONE' THEN 5
         WHEN 'AUSGELÖST_DURCH' THEN 5
       END AS soll,
       CASE WHEN ist = CASE typ
         WHEN 'HAT_ROLLE' THEN 7
         WHEN 'HAT_AUSWEIS' THEN 7
         WHEN 'NUTZT_BERECHTIGUNGSGRUPPE' THEN 6
         WHEN 'ERLAUBT_ZUGANG_ZU' THEN 18
         WHEN 'FÜHRT_ZU' THEN 7
         WHEN 'HAT_LESER' THEN 7
         WHEN 'ANGEBUNDEN_AN' THEN 7
         WHEN 'LIEGT_IN_ZONE' THEN 6
         WHEN 'ÜBERWACHT_RAUM' THEN 13
         WHEN 'ÜBERWACHT_ZONE' THEN 10
         WHEN 'BETRIFFT_RAUM' THEN 5
         WHEN 'BETRIFFT_ZONE' THEN 5
         WHEN 'AUSGELÖST_DURCH' THEN 5
       END THEN 'OK' ELSE 'PRÜFEN' END AS ergebnis
ORDER BY typ;

// FUNKTIONSNACHWEIS 4: Verwaiste Datensätze müssen 0 ergeben.
CALL {
  MATCH (p:Person)
  WHERE NOT EXISTS { MATCH (p)-[:HAT_ROLLE]->(:Rolle) }
  RETURN count(p) AS personenOhneRolle
}
CALL {
  MATCH (r:Raum)
  WHERE NOT EXISTS { MATCH (r)-[:LIEGT_IN_ZONE]->(:Sicherheitszone) }
  RETURN count(r) AS räumeOhneZone
}
CALL {
  MATCH (t:`Tür`)
  WHERE NOT EXISTS { MATCH (t)-[:`FÜHRT_ZU`]->(:Raum) }
  RETURN count(t) AS türenOhneRaum
}
CALL {
  MATCH (a:Alarm)
  WHERE NOT EXISTS { MATCH (a)-[:`AUSGELÖST_DURCH`]->(:Sicherheitssystem) }
  RETURN count(a) AS alarmeOhneSystem
}
RETURN personenOhneRolle,
       räumeOhneZone,
       türenOhneRaum,
       alarmeOhneSystem,
       CASE WHEN personenOhneRolle + räumeOhneZone + türenOhneRaum + alarmeOhneSystem = 0
            THEN 'OK' ELSE 'PRÜFEN' END AS ergebnis;

// FUNKTIONSNACHWEIS 5: Gefahrenstufen und Sicherheitstüren.
MATCH (p:Person)-[:HAT_ROLLE]->(:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür`)
WHERE p.status = 'aktiv'
  AND p.gefahrenstufe IN ['mittel', 'hoch']
  AND t.`sicherheitstür` = true
RETURN count(DISTINCT [p.personId, t.`türId`]) AS risikohinweise,
       7 AS soll,
       CASE WHEN count(DISTINCT [p.personId, t.`türId`]) = 7
            THEN 'OK' ELSE 'PRÜFEN' END AS ergebnis;

// FUNKTIONSNACHWEIS 6: Ein Beispielpfad muss vollständig vorhanden sein.
MATCH pfad = (p:Person {personId: 'P002'})-[:HAT_ROLLE]->(:Rolle)
             -[:NUTZT_BERECHTIGUNGSGRUPPE]->(:Berechtigungsgruppe)
             -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür` {`türId`: 'T003'})
             -[:`FÜHRT_ZU`]->(r:Raum {raumId: 'RA003'})
RETURN p.vorname + ' ' + p.nachname AS person,
       t.bezeichnung AS `Tür`,
       r.name AS raum,
       length(pfad) AS pfadlänge,
       'OK' AS ergebnis;
