-- ════════════════════════════════════════════════════════════════
--  LinkedIn Studio — Team-Datenbank (Supabase)
--  Einmalig im Supabase-Dashboard unter "SQL Editor" ausführen.
--  Enthält KEINE Geheimnisse und darf im Repo liegen.
-- ════════════════════════════════════════════════════════════════

-- Eine Zeile pro Kunde / CI-Programm + eine "meta"-Zeile (Vergleiche, Notizen, ...)
create table if not exists public.app_docs (
  kind        text        not null check (kind in ('client', 'program', 'meta')),
  id          text        not null,
  data        jsonb       not null default '{}'::jsonb,
  deleted     boolean     not null default false,   -- Löschen ist "weich": nichts geht verloren
  rev         bigint      not null default 1,       -- Revision für Konflikterkennung
  updated_at  timestamptz not null default now(),
  updated_by  text,
  primary key (kind, id)
);

-- Sicherheitsnetz: ältere Stände (höchstens einer alle 15 Minuten je Eintrag) bleiben erhalten
create table if not exists public.app_docs_history (
  hid       bigserial   primary key,
  kind      text        not null,
  id        text        not null,
  data      jsonb       not null,
  rev       bigint,
  saved_at  timestamptz not null default now(),
  saved_by  text
);
create index if not exists app_docs_history_lookup on public.app_docs_history (kind, id, saved_at desc);

create or replace function public.app_docs_touch() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if tg_op = 'UPDATE' then
    if not exists (
      select 1 from public.app_docs_history h
      where h.kind = old.kind and h.id = old.id and h.saved_at > now() - interval '15 minutes'
    ) then
      insert into public.app_docs_history (kind, id, data, rev, saved_by)
      values (old.kind, old.id, old.data, old.rev, old.updated_by);
    end if;
    new.rev := old.rev + 1;
  else
    new.rev := 1;
  end if;
  new.updated_at := now();
  new.updated_by := coalesce(auth.jwt() ->> 'email', 'unbekannt');
  return new;
end $$;

drop trigger if exists app_docs_touch on public.app_docs;
create trigger app_docs_touch before insert or update on public.app_docs
  for each row execute function public.app_docs_touch();

-- Zugriff: NUR angemeldete Teammitglieder. Ohne Login ist nichts les- oder schreibbar.
alter table public.app_docs         enable row level security;
alter table public.app_docs_history enable row level security;

drop policy if exists team_select on public.app_docs;
drop policy if exists team_insert on public.app_docs;
drop policy if exists team_update on public.app_docs;
create policy team_select on public.app_docs for select to authenticated using (true);
create policy team_insert on public.app_docs for insert to authenticated with check (true);
create policy team_update on public.app_docs for update to authenticated using (true) with check (true);
-- bewusst KEINE delete-Policy: niemand kann Zeilen endgültig löschen (nur weich über "deleted")

drop policy if exists team_history_select on public.app_docs_history;
create policy team_history_select on public.app_docs_history for select to authenticated using (true);

revoke all on public.app_docs         from anon;
revoke all on public.app_docs_history from anon;
