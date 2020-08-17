# COVID19 Access

Durch die Vorgaben in der Verordnung zum Schutz vor Neuinfizierungen mit dem Coronavirus SARS-CoV-2 (CoronaSchVO) sind Bibliotheken gehalten, eine Benutzerregistrierung sowie eine Reglementierung der Besucherzahl umzusetzen.

Aus diesem Grund müssen sich alle Personen bis auf Weiteres beim Betreten und Verlassen der Bibliothek mit ihrem Bibliotheksausweis ein- bzw. ausbuchen. Zudem werden beim Betreten der Bibliothek Name, Adresse und Telefonummer aller Personen erfasst und für einen Zeitraum von vier Wochen gespeichert. 

Weitere Informationen dazu finden Sie in unserer [Datenschutzerklärung](https://www.ub.uni-paderborn.de/fileadmin/ub/Dokumente_Formulare/DSE_UB_001_COVID19_Access_v1.pdf).

## Nachnutzung

Die Anwendung ist für den Einsatz an der UB Paderborn entwickelt und optimiert. Grundsätzlich ist eine Nachnutzung für andere Bibliotheken möglich. Dazu sind ggf. kleine Anpassungen am Quellcode erforderlich. Dies betrifft insb. den Datenabzug aus dem Bibliothekssystem (hier Aleph).

Es ist in jedem Fall ratsam einen Fork des Codes zu erstellen.

Dateien die möglicherweise angepasst werden müssen:

1. `app/utils/aleph_client.rb`

   In dieser Datei werden Daten aus Aleph geladen. Hier sind ggf. mappings anzupassen.

2. `app/controllers/registrations_controller.rb`

   In dieser Datei ist die komplette Logik für die Nutzerregsistrierung. Hier wird auch der Aleph Client angesprochen. Ist ein Abgleich mit dem Bibliothekssystem nicht gewünscht kann dies hier abgestellt werden. 

   Wir versuchen so viele Daten wie möglich zu aus dem Biblieothekssystem zu laden um die Menge der manuell zu erfassenen Daten zu minimieren. Es ist jedoch nicht erforderlich dies zu tun.

## Installation

### Lokal zum Testen

0. Quellcode clonen (am Besten einen eigenen Fork) in ein lokales Verzeichnis `covid19_access`

   `$ cd covid19_acess`

1. Installation von Ruby. Es gibt viele Möglichkeiten Ruby zu installieren. Wir empfehlen RVM (https://rvm.io). Die Anwdenung nutzt aktuell Ruby Version `2.6.5`. Grundsätzlich sollte auch `2.7.x` funktionieren. In dem Fall muss die Datei `.ruby-version` entsprechend angepasst werden.

2. Node.js (https://nodejs.org) installieren

3. yarn 1.x (https://classic.yarnpkg.com) installieren

4. Programm-Abhängigkeiten installieren

   `$ bundle install`

   `$ yarn install`

5. Datenbank-Settings: `config/database.yml` anpassen.

6. Datenbank anlegen

   `$ rails db:create`

   (oder manuell anlegen)

7. Einstellungen: `config/application.yml` erstellen und anpassen.

   `$ cp config/application.yml.sample config/application.yml`

7. Anwendung starten

   `$ rails s -p 3000`

   Die Anwendung ist jetzt unter `http://localhost:3000` erreichbar. Die Anwendung wird per HTTP BASIC AUTH geschützt. Das PW kann in `config/application.yml` gesetzt werden.

### Auf einem Produktionsserver

TBD.
