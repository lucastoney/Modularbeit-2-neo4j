// ALARMANALYSE 1
// Übersicht aller Alarme mit betroffenem Raum, Zone und auslösendem System.
MATCH (a:Alarm)-[:BETRIFFT_RAUM]->(r:Raum),
      (a)-[:BETRIFFT_ZONE]->(z:Sicherheitszone),
      (a)-[:`AUSGELÖST_DURCH`]->(s:Sicherheitssystem)
RETURN a.alarmId AS alarmId,
       a.typ AS alarmtyp,
       a.schweregrad AS schweregrad,
       a.status AS status,
       a.zeitpunkt AS zeitpunkt,
       r.name AS raum,
       z.name AS zone,
       s.name AS system
ORDER BY a.zeitpunkt DESC;

// ALARMANALYSE 2
// Aktive hohe oder kritische Alarme und alle aktiven Personen mit Zugang zum
// betroffenen Raum.
MATCH (a:Alarm)-[:BETRIFFT_RAUM]->(r:Raum)
MATCH (p:Person)-[:HAT_ROLLE]->(:Rolle)
      -[:NUTZT_BERECHTIGUNGSGRUPPE]->(:Berechtigungsgruppe)
      -[:ERLAUBT_ZUGANG_ZU]->(:`Tür`)
      -[:`FÜHRT_ZU`]->(r)
WHERE a.status = 'aktiv'
  AND a.schweregrad IN ['hoch', 'kritisch']
  AND p.status = 'aktiv'
RETURN a.alarmId AS alarmId,
       a.typ AS alarm,
       a.schweregrad AS schweregrad,
       r.name AS betroffenerRaum,
       collect(DISTINCT p.vorname + ' ' + p.nachname) AS berechtigtePersonen
ORDER BY schweregrad DESC, alarmId;

// ALARMANALYSE 3
// Welche Systeme überwachen Räume, in denen ein Alarm aufgetreten ist?
MATCH (a:Alarm)-[:BETRIFFT_RAUM]->(r:Raum)
MATCH (überwachendesSystem:Sicherheitssystem)-[:`ÜBERWACHT_RAUM`]->(r)
MATCH (a)-[:`AUSGELÖST_DURCH`]->(auslösendesSystem:Sicherheitssystem)
RETURN a.alarmId AS alarmId,
       r.name AS raum,
       auslösendesSystem.name AS ausgelöstDurch,
       collect(DISTINCT überwachendesSystem.name) AS überwachendeSysteme
ORDER BY alarmId;

// ALARMANALYSE 4
// Alarme in hoch eingestuften Sicherheitszonen.
MATCH (a:Alarm)-[:BETRIFFT_ZONE]->(z:Sicherheitszone)
WHERE z.stufe = 'hoch'
RETURN z.name AS kritischeZone,
       a.alarmId AS alarmId,
       a.typ AS alarm,
       a.schweregrad AS schweregrad,
       a.status AS status
ORDER BY kritischeZone, schweregrad DESC;
