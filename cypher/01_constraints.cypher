// Eindeutige fachliche Schlüssel verhindern doppelte Datensätze.
// IF NOT EXISTS macht das Skript wiederholbar (Neo4j 5.x).
CREATE CONSTRAINT person_personId IF NOT EXISTS
FOR (n:Person) REQUIRE n.personId IS UNIQUE;

CREATE CONSTRAINT rolle_rolleId IF NOT EXISTS
FOR (n:Rolle) REQUIRE n.rolleId IS UNIQUE;

CREATE CONSTRAINT ausweis_ausweisId IF NOT EXISTS
FOR (n:Ausweis) REQUIRE n.ausweisId IS UNIQUE;

CREATE CONSTRAINT berechtigungsgruppe_gruppeId IF NOT EXISTS
FOR (n:Berechtigungsgruppe) REQUIRE n.gruppeId IS UNIQUE;

CREATE CONSTRAINT tür_türId IF NOT EXISTS
FOR (n:`Tür`) REQUIRE n.`türId` IS UNIQUE;

CREATE CONSTRAINT raum_raumId IF NOT EXISTS
FOR (n:Raum) REQUIRE n.raumId IS UNIQUE;

CREATE CONSTRAINT sicherheitszone_zoneId IF NOT EXISTS
FOR (n:Sicherheitszone) REQUIRE n.zoneId IS UNIQUE;

CREATE CONSTRAINT leser_leserId IF NOT EXISTS
FOR (n:Leser) REQUIRE n.leserId IS UNIQUE;

CREATE CONSTRAINT controller_controllerId IF NOT EXISTS
FOR (n:Controller) REQUIRE n.controllerId IS UNIQUE;

CREATE CONSTRAINT alarm_alarmId IF NOT EXISTS
FOR (n:Alarm) REQUIRE n.alarmId IS UNIQUE;

CREATE CONSTRAINT sicherheitssystem_systemId IF NOT EXISTS
FOR (n:Sicherheitssystem) REQUIRE n.systemId IS UNIQUE;

// Indizes für häufig verwendete Filter.
CREATE INDEX person_gefahrenstufe IF NOT EXISTS
FOR (n:Person) ON (n.gefahrenstufe);

CREATE INDEX raum_kritikalität IF NOT EXISTS
FOR (n:Raum) ON (n.`kritikalität`);

CREATE INDEX alarm_status IF NOT EXISTS
FOR (n:Alarm) ON (n.status);

SHOW CONSTRAINTS;
