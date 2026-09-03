// ZUTRITTSANALYSE 1
// Zeigt alle aktiven Personen mit gültigem Ausweis und ihren vollständigen
// Zutrittspfad von der Rolle bis zum technischen Controller.
MATCH (p:Person)-[:HAT_AUSWEIS]->(a:Ausweis),
      (p)-[:HAT_ROLLE]->(rolle:Rolle)
          -[:NUTZT_BERECHTIGUNGSGRUPPE]->(gruppe:Berechtigungsgruppe)
          -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür`)
          -[:`FÜHRT_ZU`]->(raum:Raum)
OPTIONAL MATCH (t)-[:HAT_LESER]->(leser:Leser)-[:ANGEBUNDEN_AN]->(controller:Controller)
WHERE p.status = 'aktiv'
  AND a.status = 'aktiv'
  AND a.`gültigBis` >= date()
RETURN p.personId AS personId,
       p.vorname + ' ' + p.nachname AS person,
       rolle.name AS rolle,
       gruppe.name AS berechtigungsgruppe,
       t.bezeichnung AS `Tür`,
       raum.name AS raum,
       leser.bezeichnung AS leser,
       controller.name AS controller
ORDER BY person, raum;

// ZUTRITTSANALYSE 2
// Wer besitzt Zugriff auf Räume mit hoher Kritikalität?
MATCH (p:Person)-[:HAT_ROLLE]->(:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(g:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür`)
      -[:`FÜHRT_ZU`]->(r:Raum)-[:LIEGT_IN_ZONE]->(z:Sicherheitszone)
WHERE p.status = 'aktiv' AND r.`kritikalität` = 'hoch'
RETURN DISTINCT p.vorname + ' ' + p.nachname AS person,
       p.gefahrenstufe AS gefahrenstufe,
       g.name AS berechtigungsgruppe,
       t.bezeichnung AS `Tür`,
       r.name AS kritischerRaum,
       z.name AS sicherheitszone
ORDER BY kritischerRaum, person;

// ZUTRITTSANALYSE 3
// Detailansicht für eine einzelne Person; personId bei Bedarf anpassen.
MATCH (p:Person {personId: 'P002'})-[:HAT_ROLLE]->(rolle:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(gruppe:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür`)
      -[:`FÜHRT_ZU`]->(raum:Raum)
MATCH (t)-[:HAT_LESER]->(leser:Leser)-[:ANGEBUNDEN_AN]->(controller:Controller)
RETURN p.vorname + ' ' + p.nachname AS person,
       rolle.name AS rolle,
       gruppe.name AS berechtigungsgruppe,
       t.bezeichnung AS `Tür`,
       raum.name AS raum,
       leser.bezeichnung AS leser,
       controller.name AS controller
ORDER BY raum;
