# Team-Zugang über Microsoft 365 (SharePoint) einrichten

Die Mitarbeiter melden sich mit ihrem **normalen Firmen-Microsoft-Konto** an. Die Kundendaten liegen als Dateien in einem
**SharePoint-Ordner** eurer Firma – nicht bei einem weiteren Anbieter. Wer dort keinen Zugriff hat, sieht nichts.
Ohne diese Einrichtung läuft LinkedIn Studio wie bisher rein lokal im Browser.

Teil 1 macht die **Administratorin / der Administrator** (ca. 10 Minuten), Teil 2 und 3 mache **ich bzw. Celine**.

---

## Teil 1 – Für den Microsoft-365-Admin

### 1.1 App registrieren (Microsoft Entra Admin Center)
1. <https://entra.microsoft.com> → **Identität → Anwendungen → App-Registrierungen → Neue Registrierung**
2. **Name:** `LinkedIn Studio`
3. **Unterstützte Kontotypen:** *Nur Konten in diesem Organisationsverzeichnis* (Single Tenant)
4. **Umleitungs-URI:** Plattform **Single-Page-Anwendung (SPA)** auswählen und eintragen:

   `https://celinealessa.github.io/linkedin-studio/`

   > Wichtig: Typ **SPA** (nicht „Web"), und mit dem **Schrägstrich am Ende**.
5. **Registrieren** klicken.
6. Auf der Übersichtsseite diese zwei Werte kopieren:
   - **Anwendungs-ID (Client)**
   - **Verzeichnis-ID (Mandant)**

### 1.2 Berechtigung erteilen
1. In der App: **API-Berechtigungen → Berechtigung hinzufügen → Microsoft Graph → Delegierte Berechtigungen**
2. Hinzufügen: **`Sites.ReadWrite.All`** (und `User.Read`, falls nicht schon vorhanden)
3. **Administratorzustimmung für <Firma> erteilen** klicken (grüner Haken muss erscheinen).

> „Delegiert" heißt: Die App darf nie mehr als die angemeldete Person selbst. Wer keinen Zugriff auf den Ordner hat, kommt auch über die App nicht ran.

### 1.3 Datenordner in SharePoint
1. Eine SharePoint-Seite verwenden oder anlegen (z. B. ein Team „Social Media"). Ein Teams-Team bringt automatisch eine SharePoint-Seite mit.
2. In der Dokumentbibliothek (**Dokumente**) einen Ordner **`LinkedInStudio`** anlegen.
3. Den Ordner/die Seite **nur den Mitarbeitern freigeben**, die LinkedIn Studio nutzen sollen (Mitglieder des Teams, Bearbeiten-Recht).
   Zugang entziehen = Person aus dem Team/der Freigabe entfernen.
4. **Versionsverlauf** muss aktiv sein (ist bei neuen Bibliotheken Standard): Bibliothekseinstellungen → Versionsverwaltung.
   Damit lässt sich jede Datei bei Bedarf auf einen früheren Stand zurücksetzen.
5. Die Adresse der SharePoint-Seite kopieren, z. B. `https://firma.sharepoint.com/sites/SocialMedia`

### 1.4 Optional (Zusatzschutz)
Entra → **Unternehmensanwendungen → LinkedIn Studio → Eigenschaften → „Zuweisung erforderlich" = Ja**, dann nur die gewünschten Personen/Gruppe zuweisen.

---

## Teil 2 – Diese 3 Werte an mich geben (keine Geheimnisse)
- Anwendungs-ID (Client)
- Verzeichnis-ID (Mandant)
- Adresse der SharePoint-Seite

Es gibt hier **kein Passwort und keinen geheimen Schlüssel** – die Werte sind nicht geheim, trotzdem bitte nur an mich weitergeben.
Sie werden in `index.html` bei `CLOUD_CFG.ms` eingetragen und veröffentlicht.

## Teil 3 – Erster Start
1. Celine meldet sich zuerst an. Ihre bisherigen Kundendaten werden automatisch in den SharePoint-Ordner hochgeladen.
2. Danach melden sich die Mitarbeiter mit **„Mit Microsoft anmelden"** an und sehen alle Kunden.

## Im Alltag
- Änderungen werden ca. 2 Sekunden nach dem Speichern abgeglichen, zusätzlich jede Minute und beim Zurückkehren in den Tab.
- Arbeiten zwei Personen **gleichzeitig am selben Kunden**, geht nichts verloren: die zweite Fassung bleibt als „Konflikt-Kopie" erhalten.
- Löschen ist „weich" (Datei bleibt, nur markiert); zusätzlich hält SharePoint frühere Dateiversionen vor.
- Etwa **einmal täglich** verlangt Microsoft eine neue Anmeldung (ein Klick; meist ohne Passwort).
- Kunden-/Gruppen-Links für Kunden funktionieren weiterhin ohne Login.

## Fehlermeldungen
| Meldung | Ursache |
|---|---|
| „… nicht als Weiterleitungs-URI … eingetragen" | 1.1 Schritt 4: Typ SPA, genau die Adresse mit `/` am Ende |
| „Administrator-Zustimmung … fehlt" | 1.2 Schritt 3 |
| „kein Zugriff auf den SharePoint-Ordner" | Person nicht für die SharePoint-Seite freigegeben (1.3) |
| „SharePoint-Seite oder Ordner nicht gefunden" | Adresse der Seite falsch |

## Datenschutz
Die Daten liegen in eurem Microsoft-365-Mandanten (Region laut Mandanteneinstellung, für deutsche Firmen i. d. R. EU).
Es gilt euer bestehender Vertrag mit Microsoft; es kommt kein weiterer Anbieter hinzu.
