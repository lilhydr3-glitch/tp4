create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(btrim(name)) > 0),
  created_at timestamptz not null default now()
);

alter table public.clients enable row level security;

grant select, insert, delete on public.clients to authenticated;

drop policy if exists "Authenticated users can view clients"
  on public.clients;
create policy "Authenticated users can view clients"
  on public.clients for select to authenticated
  using (true);

drop policy if exists "Authenticated users can add clients"
  on public.clients;
create policy "Authenticated users can add clients"
  on public.clients for insert to authenticated
  with check (true);

drop policy if exists "Authenticated users can remove clients"
  on public.clients;
create policy "Authenticated users can remove clients"
  on public.clients for delete to authenticated
  using (true);

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'clients'
  ) then
    alter publication supabase_realtime add table public.clients;
  end if;
end
$$;
