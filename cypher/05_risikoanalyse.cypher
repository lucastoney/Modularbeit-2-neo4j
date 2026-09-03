// RISIKOANALYSE 1
// Ein nachvollziehbarer Punktwert kombiniert Gefahrenstufe, kritische Räume,
// Sicherheitstüren und den Umfang der Berechtigungen.
MATCH (p:Person)-[:HAT_ROLLE]->(:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür`)
      -[:`FÜHRT_ZU`]->(r:Raum)
WHERE p.status = 'aktiv'
WITH p,
     count(DISTINCT t) AS anzahlTüren,
     count(DISTINCT r) AS anzahlRäume,
     count(DISTINCT CASE WHEN r.`kritikalität` = 'hoch' THEN r END) AS kritischeRäume,
     count(DISTINCT CASE WHEN t.`sicherheitstür` = true THEN t END) AS sicherheitstüren
WITH p, anzahlTüren, anzahlRäume, kritischeRäume, sicherheitstüren,
     CASE p.gefahrenstufe WHEN 'hoch' THEN 4 WHEN 'mittel' THEN 2 ELSE 0 END
     + (kritischeRäume * 2)
     + sicherheitstüren
     + CASE WHEN anzahlTüren >= 5 THEN 2 ELSE 0 END AS risikopunkte
RETURN p.personId AS personId,
       p.vorname + ' ' + p.nachname AS person,
       p.gefahrenstufe AS fachlicheGefahrenstufe,
       anzahlTüren,
       anzahlRäume,
       kritischeRäume,
       sicherheitstüren,
       risikopunkte,
       CASE
         WHEN risikopunkte >= 8 THEN 'hoch'
         WHEN risikopunkte >= 4 THEN 'mittel'
         ELSE 'tief'
       END AS analysiertesRisiko
ORDER BY risikopunkte DESC, person;

// RISIKOANALYSE 2
// Analytischer Hinweis: Eine mittel oder hoch eingestufte Person besitzt eine
// Berechtigung für eine Sicherheitstür. Es wird kein Alarm-Node erzeugt.
MATCH (p:Person)-[:HAT_ROLLE]->(:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(g:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür`)
      -[:`FÜHRT_ZU`]->(r:Raum)
WHERE p.status = 'aktiv'
  AND p.gefahrenstufe IN ['mittel', 'hoch']
  AND t.`sicherheitstür` = true
RETURN p.vorname + ' ' + p.nachname AS person,
       p.gefahrenstufe AS gefahrenstufe,
       g.name AS berechtigungsgruppe,
       t.bezeichnung AS sicherheitstür,
       r.name AS zielraum,
       CASE
         WHEN p.gefahrenstufe = 'hoch'
           THEN 'Kritischer Hinweis: hoch eingestufte Person an Sicherheitstür'
         ELSE 'Hinweis: mittel eingestufte Person an Sicherheitstür prüfen'
       END AS analysehinweis
ORDER BY gefahrenstufe DESC, person, zielraum;

// RISIKOANALYSE 3
// Ereignisnahe Prüfung anhand einer Person und einer Tür. Die beiden IDs können
// bei einer Demo wie Eingabewerte eines Zutrittsereignisses angepasst werden.
MATCH (p:Person {personId: 'P006'})-[:HAT_ROLLE]->(:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür` {`türId`: 'T003'})
      -[:`FÜHRT_ZU`]->(r:Raum)
RETURN p.vorname + ' ' + p.nachname AS person,
       t.bezeichnung AS sicherheitstür,
       r.name AS raum,
       CASE
         WHEN t.`sicherheitstür` AND p.gefahrenstufe = 'hoch' THEN 'KRITISCHER HINWEIS'
         WHEN t.`sicherheitstür` AND p.gefahrenstufe = 'mittel' THEN 'PRÜFHINWEIS'
         ELSE 'KEIN BESONDERER HINWEIS'
       END AS entscheidung,
       'Analytischer Hinweis - kein technischer Alarm' AS fachlicheEinordnung;

// RISIKOANALYSE 4
// Personen mit besonders vielen erreichbaren Türen.
MATCH (p:Person)-[:HAT_ROLLE]->(:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(t:`Tür`)
WHERE p.status = 'aktiv'
WITH p, count(DISTINCT t) AS anzahlTüren
WHERE anzahlTüren >= 4
RETURN p.vorname + ' ' + p.nachname AS person,
       p.gefahrenstufe AS gefahrenstufe,
       anzahlTüren,
       'Berechtigungsumfang prüfen' AS analysehinweis
ORDER BY anzahlTüren DESC;
