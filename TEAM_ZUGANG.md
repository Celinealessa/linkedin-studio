# Team-Zugang einrichten (einmalig, ca. 15 Minuten)

Ohne diese Einrichtung läuft LinkedIn Studio wie bisher rein lokal im Browser.
Mit der Einrichtung melden sich Mitarbeiter mit E-Mail + Passwort an und arbeiten alle auf **denselben Kundendaten**.

## 1. Datenbank anlegen (Supabase)
1. Auf <https://supabase.com> ein Konto anlegen und **New project** wählen.
2. **Region: Frankfurt (eu-central-1)** — damit liegen die Daten in der EU.
3. Name z. B. `linkedin-studio`, ein langes Datenbank-Passwort vergeben (wird später nicht gebraucht).

## 2. Tabellen und Zugriffsschutz einspielen
1. Links **SQL Editor → New query**.
2. Den kompletten Inhalt von `supabase_setup.sql` einfügen → **Run**.
   Danach können nur noch angemeldete Teammitglieder Daten lesen/schreiben.

## 3. Selbst-Registrierung ausschalten
**Authentication → Sign In / Providers** (bzw. *Settings*): **„Allow new users to sign up"** deaktivieren.
So kann sich niemand von außen ein Konto anlegen — nur du legst Zugänge an.

## 4. Mitarbeiter-Zugänge anlegen
**Authentication → Users → Add user → Create new user**
- E-Mail des Mitarbeiters und ein Passwort eintragen
- **„Auto Confirm User"** anhaken
- Zugangsdaten an den Mitarbeiter weitergeben. Zugang entziehen: den Nutzer dort wieder löschen.

## 5. Zwei Werte an die App übergeben
**Project Settings → API** (bzw. *Data API*):
- **Project URL** (`https://xxxx.supabase.co`)
- **anon public key** (langer Text, beginnt mit `eyJ…`)

> ⚠️ Nur diese beiden Werte weitergeben. Den **`service_role`-Key niemals** teilen oder irgendwo eintragen —
> der umgeht den gesamten Zugriffsschutz. Der anon-Key ist öffentlich gedacht, geschützt wird durch Login + Regeln aus Schritt 2.

Diese beiden Werte werden in `index.html` bei `CLOUD_CFG` eingetragen und veröffentlicht.

## 6. Erster Start
Du meldest dich zuerst selbst an. Deine bisherigen Kundendaten werden automatisch in die Cloud hochgeladen.
Danach melden sich die Mitarbeiter an und sehen alle Kunden.

## Verhalten im Alltag
- Änderungen werden ca. 2 Sekunden nach dem Speichern abgeglichen, zusätzlich jede Minute und beim Zurückkehren in den Tab.
- Bearbeiten zwei Personen **gleichzeitig denselben Kunden**, geht nichts verloren: die zweite Fassung bleibt als „Konflikt-Kopie" erhalten.
- Löschen ist „weich" (Markierung statt echtem Löschen). Ältere Stände (max. alle 15 Min.) liegen in der Tabelle `app_docs_history` und können über den SQL-Editor wiederhergestellt werden.
- Kunden-/Gruppen-Links für Kunden funktionieren weiterhin ohne Login.

## Datenschutz
Kundendaten liegen dann in der Supabase-Datenbank (EU-Region). Für den geschäftlichen Einsatz bitte den
Auftragsverarbeitungsvertrag (AVV/DPA) mit Supabase abschließen: <https://supabase.com/legal/dpa>.
