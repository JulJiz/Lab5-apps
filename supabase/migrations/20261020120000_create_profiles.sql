create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  full_name text not null default ''
);

alter table public.profiles enable row level security;

grant select, insert, update on public.profiles to authenticated;

create policy "Cada quien crea su perfil" on public.profiles
  for insert to authenticated with check (auth.uid() = id);

create policy "Usuarios autenticados leen perfiles" on public.profiles
  for select to authenticated using (true);

create policy "Cada quien edita su perfil" on public.profiles
  for update to authenticated using (auth.uid() = id);
