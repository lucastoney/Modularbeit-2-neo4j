// ACHTUNG: Löscht alle Nodes und Relationships der ausgewählten Datenbank.
// Nur in der fiktiven Projektdatenbank ausführen.
MATCH (n)
DETACH DELETE n;

// Nach der Bereinigung muss die Anzahl 0 sein.
MATCH (n)
RETURN count(n) AS verbleibendeNodes;
