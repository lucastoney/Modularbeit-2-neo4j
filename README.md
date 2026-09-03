# Technischer Teil der Modulararbeit 2: Neo4j

Dieses Repository enthält die technische Umsetzung der Modulararbeit zur Modellierung und Analyse einer fiktiven Zutritts- und Sicherheitsinfrastruktur mit Neo4j.

## Technischer Aufbau
- data/: CSV-Dateien mit den verwendeten Beispieldaten
- cypher/: Cypher-Skripte für Aufbau, Import und Auswertung der Datenbank

## Voraussetzungen
- Neo4j Desktop mit Neo4j 5.x
- lokale Neo4j-Instanz
- Neo4j Query zum Ausführen der Cypher-Skripte

Die CSV-Dateien werden in das Import-Verzeichnis der lokalen Neo4j-Instanz kopiert. Anschliessend können die Cypher-Skripte für Cleanup, Constraints, Import und Analyse ausgeführt werden.

## Ausführungsreihenfolge

1. `cypher/00_cleanup.cypher` – vorhandene Nodes und Relationships löschen
2. `cypher/01_constraints.cypher` – Constraints und Indizes erstellen
3. `cypher/03_import_csv.cypher` – Nodes und Relationships aus den CSV-Dateien importieren
4. `cypher/04_zutrittsanalyse.cypher` – Zutrittsanalysen ausführen
5. `cypher/05_risikoanalyse.cypher` – Risikoanalysen ausführen
6. `cypher/06_alarmanalyse.cypher` – Alarmanalysen ausführen
7. `cypher/99_funktionsnachweis.cypher` – Datenbestand und Beziehungen prüfen

Alternativ kann nach den Constraints `cypher/02_seed_data.cypher` anstelle des CSV-Imports ausgeführt werden. Die Seed- und CSV-Variante erzeugen denselben Beispieldatenbestand und müssen nicht kombiniert werden.

## Erwartetes Prüfergebnis

Der unveränderte Beispieldatenbestand enthält:

- `61` Nodes
- `103` Relationships
- keine verwaisten Kerndatensätze

Die einzelnen Abfragen in `cypher/99_funktionsnachweis.cypher` geben bei korrektem Aufbau `OK` aus.

Die schriftliche Dokumentation wird separat als Word-Datei eingereicht.
