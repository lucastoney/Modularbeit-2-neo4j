// Manueller, reproduzierbarer Datenaufbau ohne CSV-Dateien.
// Vorher 01_constraints.cypher ausführen. MERGE macht den Aufbau wiederholbar.

// Personen
UNWIND [
  {personId: 'P001', vorname: 'Anna', nachname: 'Keller', abteilung: 'Personal', status: 'aktiv', gefahrenstufe: 'tief'},
  {personId: 'P002', vorname: 'Marco', nachname: 'Frei', abteilung: 'Informatik', status: 'aktiv', gefahrenstufe: 'mittel'},
  {personId: 'P003', vorname: 'Lara', nachname: 'Meier', abteilung: 'Sicherheit', status: 'aktiv', gefahrenstufe: 'hoch'},
  {personId: 'P004', vorname: 'Jonas', nachname: 'Roth', abteilung: 'Externe Wartung', status: 'aktiv', gefahrenstufe: 'mittel'},
  {personId: 'P005', vorname: 'Nina', nachname: 'Baum', abteilung: 'Facility Management', status: 'aktiv', gefahrenstufe: 'tief'},
  {personId: 'P006', vorname: 'Elias', nachname: 'Moser', abteilung: 'Informatik', status: 'aktiv', gefahrenstufe: 'hoch'},
  {personId: 'P007', vorname: 'Sophia', nachname: 'Graf', abteilung: 'Besuch', status: 'inaktiv', gefahrenstufe: 'tief'}
] AS item
MERGE (n:Person {personId: item.personId})
SET n.vorname = item.vorname,
    n.nachname = item.nachname,
    n.abteilung = item.abteilung,
    n.status = item.status,
    n.gefahrenstufe = item.gefahrenstufe;

// Rollen
UNWIND [
  {rolleId: 'R01', name: 'Mitarbeitende', beschreibung: 'Reguläre Mitarbeitende mit Bürozugang'},
  {rolleId: 'R02', name: 'IT-Administration', beschreibung: 'Administration der zentralen IT-Infrastruktur'},
  {rolleId: 'R03', name: 'Sicherheitsdienst', beschreibung: 'Überwachung und Intervention in Sicherheitsbereichen'},
  {rolleId: 'R04', name: 'Externe Wartung', beschreibung: 'Zeitlich begrenzte technische Wartungsaufgaben'},
  {rolleId: 'R05', name: 'Facility Management', beschreibung: 'Betrieb und Unterhalt der Gebäudeinfrastruktur'},
  {rolleId: 'R06', name: 'Besuch', beschreibung: 'Beaufsichtigter Zutritt zum Empfangsbereich'}
] AS item
MERGE (n:Rolle {rolleId: item.rolleId})
SET n.name = item.name, n.beschreibung = item.beschreibung;

// Ausweise
UNWIND [
  {ausweisId: 'A001', kartennummer: 'DEMO-BADGE-1001', status: 'aktiv', `gültigBis`: date('2099-12-31')},
  {ausweisId: 'A002', kartennummer: 'DEMO-BADGE-1002', status: 'aktiv', `gültigBis`: date('2099-12-31')},
  {ausweisId: 'A003', kartennummer: 'DEMO-BADGE-1003', status: 'aktiv', `gültigBis`: date('2099-12-31')},
  {ausweisId: 'A004', kartennummer: 'DEMO-BADGE-1004', status: 'aktiv', `gültigBis`: date('2099-12-31')},
  {ausweisId: 'A005', kartennummer: 'DEMO-BADGE-1005', status: 'aktiv', `gültigBis`: date('2099-12-31')},
  {ausweisId: 'A006', kartennummer: 'DEMO-BADGE-1006', status: 'aktiv', `gültigBis`: date('2099-12-31')},
  {ausweisId: 'A007', kartennummer: 'DEMO-BADGE-1007', status: 'gesperrt', `gültigBis`: date('2020-01-01')}
] AS item
MERGE (n:Ausweis {ausweisId: item.ausweisId})
SET n.kartennummer = item.kartennummer,
    n.status = item.status,
    n.`gültigBis` = item.`gültigBis`;

// Berechtigungsgruppen
UNWIND [
  {gruppeId: 'G01', name: 'Standard Büro', risikostufe: 'tief'},
  {gruppeId: 'G02', name: 'Wartung eingeschränkt', risikostufe: 'mittel'},
  {gruppeId: 'G03', name: 'IT kritische Bereiche', risikostufe: 'hoch'},
  {gruppeId: 'G04', name: 'Sicherheitsvollzug', risikostufe: 'hoch'},
  {gruppeId: 'G05', name: 'Gebäudebetrieb', risikostufe: 'mittel'},
  {gruppeId: 'G06', name: 'Besucherbereich', risikostufe: 'tief'}
] AS item
MERGE (n:Berechtigungsgruppe {gruppeId: item.gruppeId})
SET n.name = item.name, n.risikostufe = item.risikostufe;

// Räume und Sicherheitszonen
UNWIND [
  {zoneId: 'Z01', name: 'Öffentlicher Bereich', stufe: 'tief'},
  {zoneId: 'Z02', name: 'Interner Bereich', stufe: 'mittel'},
  {zoneId: 'Z03', name: 'Kritische Zone', stufe: 'hoch'},
  {zoneId: 'Z04', name: 'Sicherheitskern', stufe: 'hoch'}
] AS item
MERGE (n:Sicherheitszone {zoneId: item.zoneId})
SET n.name = item.name, n.stufe = item.stufe;

UNWIND [
  {raumId: 'RA001', name: 'Empfang', funktion: 'Empfang und Anmeldung', `kritikalität`: 'tief'},
  {raumId: 'RA002', name: 'Großraumbüro', funktion: 'Allgemeiner Bürobereich', `kritikalität`: 'mittel'},
  {raumId: 'RA003', name: 'Serverraum', funktion: 'Betrieb zentraler IT-Systeme', `kritikalität`: 'hoch'},
  {raumId: 'RA004', name: 'Technikraum', funktion: 'Gebäude- und Versorgungstechnik', `kritikalität`: 'hoch'},
  {raumId: 'RA005', name: 'Archiv', funktion: 'Aufbewahrung vertraulicher Unterlagen', `kritikalität`: 'mittel'},
  {raumId: 'RA006', name: 'Sicherheitsleitstelle', funktion: 'Überwachung und Alarmbearbeitung', `kritikalität`: 'hoch'}
] AS item
MERGE (n:Raum {raumId: item.raumId})
SET n.name = item.name,
    n.funktion = item.funktion,
    n.`kritikalität` = item.`kritikalität`;

// Türen, Leser und Controller
UNWIND [
  {`türId`: 'T001', bezeichnung: 'Haupteingang', sicherheitsrelevant: false, `sicherheitstür`: false},
  {`türId`: 'T002', bezeichnung: 'Büroflur', sicherheitsrelevant: false, `sicherheitstür`: false},
  {`türId`: 'T003', bezeichnung: 'Serverraumtür', sicherheitsrelevant: true, `sicherheitstür`: true},
  {`türId`: 'T004', bezeichnung: 'Technikraumtür', sicherheitsrelevant: true, `sicherheitstür`: true},
  {`türId`: 'T005', bezeichnung: 'Archivzugang', sicherheitsrelevant: true, `sicherheitstür`: true},
  {`türId`: 'T006', bezeichnung: 'Leitstellenzugang', sicherheitsrelevant: true, `sicherheitstür`: true},
  {`türId`: 'T007', bezeichnung: 'Besucherzugang', sicherheitsrelevant: false, `sicherheitstür`: false}
] AS item
MERGE (n:`Tür` {`türId`: item.`türId`})
SET n.bezeichnung = item.bezeichnung,
    n.sicherheitsrelevant = item.sicherheitsrelevant,
    n.`sicherheitstür` = item.`sicherheitstür`;

UNWIND [
  {leserId: 'L001', bezeichnung: 'Leser Haupteingang außen', typ: 'RFID'},
  {leserId: 'L002', bezeichnung: 'Leser Büroflur', typ: 'RFID'},
  {leserId: 'L003', bezeichnung: 'Leser Serverraum', typ: 'Biometrie und RFID'},
  {leserId: 'L004', bezeichnung: 'Leser Technikraum', typ: 'RFID'},
  {leserId: 'L005', bezeichnung: 'Leser Archiv', typ: 'RFID'},
  {leserId: 'L006', bezeichnung: 'Leser Sicherheitsleitstelle', typ: 'Biometrie und RFID'},
  {leserId: 'L007', bezeichnung: 'Leser Besucherzugang', typ: 'QR-Code'}
] AS item
MERGE (n:Leser {leserId: item.leserId})
SET n.bezeichnung = item.bezeichnung, n.typ = item.typ;

UNWIND [
  {controllerId: 'C001', name: 'Controller Erdgeschoss', standort: 'Technikschrank Erdgeschoss'},
  {controllerId: 'C002', name: 'Controller Technikzone', standort: 'Technikschrank Untergeschoss'},
  {controllerId: 'C003', name: 'Controller Sicherheitskern', standort: 'Sicherheitsleitstelle'}
] AS item
MERGE (n:Controller {controllerId: item.controllerId})
SET n.name = item.name, n.standort = item.standort;

// Systeme und Alarme
UNWIND [
  {systemId: 'S001', name: 'Zentrale Zutrittskontrolle', typ: 'Zutrittskontrolle', status: 'aktiv'},
  {systemId: 'S002', name: 'Einbruchmeldeanlage', typ: 'Einbruchmeldeanlage', status: 'aktiv'},
  {systemId: 'S003', name: 'Videoüberwachung', typ: 'Videoüberwachung', status: 'aktiv'}
] AS item
MERGE (n:Sicherheitssystem {systemId: item.systemId})
SET n.name = item.name, n.typ = item.typ, n.status = item.status;

UNWIND [
  {alarmId: 'AL001', typ: 'Tür zu lange offen', schweregrad: 'hoch', status: 'aktiv', zeitpunkt: datetime('2026-06-12T08:15:00+02:00')},
  {alarmId: 'AL002', typ: 'Einbruchalarm', schweregrad: 'kritisch', status: 'aktiv', zeitpunkt: datetime('2026-06-12T22:41:00+02:00')},
  {alarmId: 'AL003', typ: 'Bewegung außerhalb Zeitfenster', schweregrad: 'mittel', status: 'quittiert', zeitpunkt: datetime('2026-06-11T23:05:00+02:00')},
  {alarmId: 'AL004', typ: 'Manipulation am Leser', schweregrad: 'hoch', status: 'geschlossen', zeitpunkt: datetime('2026-06-10T14:20:00+02:00')},
  {alarmId: 'AL005', typ: 'Unbefugte Bewegung erkannt', schweregrad: 'hoch', status: 'aktiv', zeitpunkt: datetime('2026-06-12T02:33:00+02:00')}
] AS item
MERGE (n:Alarm {alarmId: item.alarmId})
SET n.typ = item.typ,
    n.schweregrad = item.schweregrad,
    n.status = item.status,
    n.zeitpunkt = item.zeitpunkt;

// Person -> Rolle und Person -> Ausweis
UNWIND [
  ['P001', 'R01', 'A001'], ['P002', 'R02', 'A002'],
  ['P003', 'R03', 'A003'], ['P004', 'R04', 'A004'],
  ['P005', 'R05', 'A005'], ['P006', 'R02', 'A006'],
  ['P007', 'R06', 'A007']
] AS link
MATCH (p:Person {personId: link[0]})
MATCH (r:Rolle {rolleId: link[1]})
MATCH (a:Ausweis {ausweisId: link[2]})
MERGE (p)-[:HAT_ROLLE]->(r)
MERGE (p)-[:HAT_AUSWEIS]->(a);

// Rolle -> Berechtigungsgruppe
UNWIND [
  ['R01', 'G01'], ['R02', 'G03'], ['R03', 'G04'],
  ['R04', 'G02'], ['R05', 'G05'], ['R06', 'G06']
] AS link
MATCH (r:Rolle {rolleId: link[0]})
MATCH (g:Berechtigungsgruppe {gruppeId: link[1]})
MERGE (r)-[:NUTZT_BERECHTIGUNGSGRUPPE]->(g);

// Berechtigungsgruppe -> Tür
UNWIND [
  ['G01', 'T001'], ['G01', 'T002'],
  ['G02', 'T001'], ['G02', 'T004'],
  ['G03', 'T001'], ['G03', 'T002'], ['G03', 'T003'],
  ['G04', 'T001'], ['G04', 'T002'], ['G04', 'T003'],
  ['G04', 'T004'], ['G04', 'T005'], ['G04', 'T006'],
  ['G05', 'T001'], ['G05', 'T002'], ['G05', 'T004'], ['G05', 'T005'],
  ['G06', 'T007']
] AS link
MATCH (g:Berechtigungsgruppe {gruppeId: link[0]})
MATCH (t:`Tür` {`türId`: link[1]})
MERGE (g)-[:ERLAUBT_ZUGANG_ZU]->(t);

// Tür -> Raum und Tür -> Leser
UNWIND [
  ['T001', 'RA001', 'L001'], ['T002', 'RA002', 'L002'],
  ['T003', 'RA003', 'L003'], ['T004', 'RA004', 'L004'],
  ['T005', 'RA005', 'L005'], ['T006', 'RA006', 'L006'],
  ['T007', 'RA001', 'L007']
] AS link
MATCH (t:`Tür` {`türId`: link[0]})
MATCH (r:Raum {raumId: link[1]})
MATCH (l:Leser {leserId: link[2]})
MERGE (t)-[:`FÜHRT_ZU`]->(r)
MERGE (t)-[:HAT_LESER]->(l);

// Raum -> Sicherheitszone
UNWIND [
  ['RA001', 'Z01'], ['RA002', 'Z02'], ['RA003', 'Z03'],
  ['RA004', 'Z03'], ['RA005', 'Z02'], ['RA006', 'Z04']
] AS link
MATCH (r:Raum {raumId: link[0]})
MATCH (z:Sicherheitszone {zoneId: link[1]})
MERGE (r)-[:LIEGT_IN_ZONE]->(z);

// Leser -> Controller
UNWIND [
  ['L001', 'C001'], ['L002', 'C001'], ['L003', 'C002'],
  ['L004', 'C002'], ['L005', 'C002'], ['L006', 'C003'],
  ['L007', 'C001']
] AS link
MATCH (l:Leser {leserId: link[0]})
MATCH (c:Controller {controllerId: link[1]})
MERGE (l)-[:ANGEBUNDEN_AN]->(c);

// Sicherheitssystem -> Raum und Sicherheitszone
UNWIND [
  ['S001', ['RA001','RA002','RA003','RA004','RA005','RA006'], ['Z01','Z02','Z03','Z04']],
  ['S002', ['RA003','RA004','RA005','RA006'], ['Z02','Z03','Z04']],
  ['S003', ['RA001','RA003','RA006'], ['Z01','Z03','Z04']]
] AS systemLink
MATCH (s:Sicherheitssystem {systemId: systemLink[0]})
UNWIND systemLink[1] AS raumId
MATCH (r:Raum {raumId: raumId})
MERGE (s)-[:`ÜBERWACHT_RAUM`]->(r)
WITH s, systemLink
UNWIND systemLink[2] AS zoneId
MATCH (z:Sicherheitszone {zoneId: zoneId})
MERGE (s)-[:`ÜBERWACHT_ZONE`]->(z);

// Alarm -> Raum, Zone und auslösendes System
UNWIND [
  ['AL001', 'RA003', 'Z03', 'S001'],
  ['AL002', 'RA006', 'Z04', 'S002'],
  ['AL003', 'RA004', 'Z03', 'S003'],
  ['AL004', 'RA005', 'Z02', 'S001'],
  ['AL005', 'RA003', 'Z03', 'S003']
] AS link
MATCH (a:Alarm {alarmId: link[0]})
MATCH (r:Raum {raumId: link[1]})
MATCH (z:Sicherheitszone {zoneId: link[2]})
MATCH (s:Sicherheitssystem {systemId: link[3]})
MERGE (a)-[:BETRIFFT_RAUM]->(r)
MERGE (a)-[:BETRIFFT_ZONE]->(z)
MERGE (a)-[:`AUSGELÖST_DURCH`]->(s);

// Kompakte Abschlusskontrolle.
MATCH (n)
RETURN count(n) AS nodesNachSeed;
