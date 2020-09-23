# Besucherregistrierung @ UB Paderborn

Durch die Vorgaben in der Verordnung zum Schutz vor Neuinfizierungen mit dem Coronavirus SARS-CoV-2 (CoronaSchVO) ist die Universitätsbibliothek Paderborn gehalten, eine Besucherregistrierung sowie eine Regle- mentierung der Besucherzahl umzusetzen.

Aus diesem Grund dürfen nur Personen mit einem gültigen Bibliotheksausweis die Bibliothek betreten und müssen sich alle Personen bis auf Weiteres beim Betreten und Verlassen der Bibliothek mit ihrem Bibliotheksausweis ein- bzw. ausbuchen. Dabei werden die Bibliotheksausweisnummer, der Name, die Adresse, die Telefonnummer sowie der Zeitpunkt des Betretens bzw. Verlassens der Bibliothek gespeichert.

Werden Arbeitsplätze innerhalb der Bibliothek in Anspruch genommen, wird dies ebenfalls protokolliert um die Regelungen der besonderen Rückverfolgbarkeit im Sinne der CoronaSchVO gewährleisten zu können.

Um diese Vorgaben effizient umsetzen zu können wurde an der UB Paderborn diese Software entwickelt die folgende Funktionsbereiche abdeckt:

* Besucherregistrierung: Check-In mit Registrierung der Kontaktdaten und Check-Out.
* Ressourcenverwaltung: Ressourcen (z.B. Arbeitsplätze) können im System verwaltet und Personen zur Nutzung zugeteilt werden. Zeitpunkt von Belegung und Freigabe wird protokolliert. Damit wird die besondere Rückverfolgbarkeit im Sinne der CoronaSchVO sichergestellt. Eine öffentliche Auslastungsübersicht erlaubt Informationen über die Auslastung der UB in Echtzeit.
* Reservierungen: Ressourcen (z.B. Arbeitsplätze) können vorab durch Nutzerinnen und Nutzer online reserviert werden. Reservierte Plätze können vor Ort bis zum Zeitpunkt der Reservierung von anderen Personen belegt werden. Dies ist vergleichbar mit der Reservierung von Sitzplätzen in der Bahn (Reserviert ab Köln). Erscheint die Person mit der Reservierung muss der Platz freigemacht werden. Reservierungen verfallen automatisch 30 Minuten nach der Reservierungszeit, sofern diese vor Ort nicht in Anspruch genommen werden. Dies erlaubt eine optimale Auslastung der Arbeitsplätze in Zeiten hoher Nachfrage. Jede Nutzerin, jeder Nutzer (Anmeldung über das Bibliothekskonto) darf pro Tag eine Reservierung machen und max. drei Tage im Voraus.

## Nachnutzung

Die Anwendung ist für den Einsatz an der UB Paderborn entwickelt und optimiert. Grundsätzlich ist eine Nachnutzung für andere Bibliotheken möglich. Dazu sind  Anpassungen am Quellcode erforderlich, da nicht alle Details parametriert sind. Dies betrifft insb. den Datenabzug aus dem Bibliothekssystem (hier Aleph).

Es ist in jedem Fall ratsam einen Fork des Codes zu erstellen.

## Installation

### Lokal zum Testen

0. Quellcode clonen (am Besten einen eigenen Fork) in ein lokales Verzeichnis `covid19_access`

   `$ cd covid19_acess`

1. Installation von Ruby. Es gibt viele Möglichkeiten Ruby zu installieren. Wir empfehlen RVM (https://rvm.io). Die Anwdenung nutzt aktuell Ruby Version `2.6.5`. Grundsätzlich sollte auch `2.7.x` funktionieren. In dem Fall muss die Datei `.ruby-version` entsprechend angepasst werden.

2. node.js (https://nodejs.org) installieren

3. yarn 1.x (https://classic.yarnpkg.com) installieren. yarn 2.x sollte auch funktionieren, wurde aber noch nicht getestet.

4. Programm-Abhängigkeiten installieren

   `$ bundle install`

   `$ yarn install`

5. Datenbank-Settings: `config/database.yml` anpassen. Wir nutzen MySQL. PostgreSQL sollte ebenfalls funktionieren, wurde aber nicht getestet.

6. Datenbank anlegen

   `$ rails db:create`

   `$ rails db:schema:load`

7. Einstellungen: `config/application.yml` erstellen und anpassen.

   `$ cp config/application.yml.sample config/application.yml`

8. Anwendung starten

   `$ rails s -p 3000`

   Die Anwendung ist jetzt unter `http://localhost:3000` erreichbar. Die Anwendung wird per HTTP BASIC AUTH geschützt. Das PW kann in `config/application.yml` gesetzt werden.

9. Hinweis: Background Tasks

   Unter `lib/tasks` finden sich Background Worker die auf einem Produktionssystem via Cronjob auszuführen sind.

   * `rails app:dsgvo:cleanup` Dieser Task löscht alle personenbezogenen Daten die älter sind als 4 Wochen. Sollte auf einem Produktionssystem täglich laufen.
   * `rails app:reservations:cleanup` Dieser Task löscht alle nicht in Anspruch genommenen Reservierungen. Sollte auf einem Produktionssystem ca. alle 5 Minuten laufen.

   Ein zusätzlicher Task ist bei Bedarf manuell auszuführen

   * `rails app:report:create` Dieser Task erstellt eine Excel Datei für eine Meldung an die Behörden.

### Auf einem Produktionsserver

Deployment via `capistrano` (https://capistranorb.com). Die Dateien `config/deploy.rb` und `config/deploy/*.rb` sind entsprechend der eigenen Serverinfrastruktur im Fork anzupassen.

Für den Betrieb auf dem Server ist `nginx` (https://nginx.org) mit `passenger` (https://www.phusionpassenger.com) empfohlen.
