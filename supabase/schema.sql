-- Food Tracker — Supabase schema
--
-- Column names are camelCase and quoted, exactly as used by the Dart model.
-- Do not rename them: the app and this table share the same identifiers.

create extension if not exists "pgcrypto";

create table if not exists public.food_tracker_tb (
  id             uuid primary key default gen_random_uuid(),
  created_at     timestamptz not null default now(),
  "foodDate"     text,
  "foodMeal"     text,
  "foodName"     text,
  "foodPrice"    double precision,
  "foodPerson"   integer,
  "foodImageUrl" text
);

comment on table public.food_tracker_tb is
  'Food log rows for the Food Tracker app. One row per meal, optional photo.';

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
-- The app has no login screen, so it uses the anon key. The policies below
-- let anyone holding that key read and write the shared log. This is the
-- intended model for this single-user student project; the app never ships
-- a service role key.
alter table public.food_tracker_tb enable row level security;

drop policy if exists "food_tracker_tb select" on public.food_tracker_tb;
create policy "food_tracker_tb select"
  on public.food_tracker_tb for select
  to anon, authenticated
  using (true);

drop policy if exists "food_tracker_tb insert" on public.food_tracker_tb;
create policy "food_tracker_tb insert"
  on public.food_tracker_tb for insert
  to anon, authenticated
  with check (true);

drop policy if exists "food_tracker_tb update" on public.food_tracker_tb;
create policy "food_tracker_tb update"
  on public.food_tracker_tb for update
  to anon, authenticated
  using (true)
  with check (true);

drop policy if exists "food_tracker_tb delete" on public.food_tracker_tb;
create policy "food_tracker_tb delete"
  on public.food_tracker_tb for delete
  to anon, authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- Storage bucket "food_tracker_bk" — public bucket
-- ---------------------------------------------------------------------------
-- Public read lets Image.network render a stored photo without signing every
-- URL. Writes still go through the anon-key policies below.
-- Size and MIME limits match what the app uploads (image/jpeg, image/png,
-- image/webp) and keep the bucket from being used as generic file storage.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'food_tracker_bk',
  'food_tracker_bk',
  true,
  10485760,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "food_tracker_bk read" on storage.objects;
create policy "food_tracker_bk read"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'food_tracker_bk');

drop policy if exists "food_tracker_bk insert" on storage.objects;
create policy "food_tracker_bk insert"
  on storage.objects for insert
  to anon, authenticated
  with check (bucket_id = 'food_tracker_bk');

drop policy if exists "food_tracker_bk update" on storage.objects;
create policy "food_tracker_bk update"
  on storage.objects for update
  to anon, authenticated
  using (bucket_id = 'food_tracker_bk')
  with check (bucket_id = 'food_tracker_bk');

drop policy if exists "food_tracker_bk delete" on storage.objects;
create policy "food_tracker_bk delete"
  on storage.objects for delete
  to anon, authenticated
  using (bucket_id = 'food_tracker_bk');

-- ---------------------------------------------------------------------------
-- Photo lifecycle used by the app
-- ---------------------------------------------------------------------------
-- insert with a photo  : upload to food_tracker_bk, store the public URL in foodImageUrl
-- update with new photo: upload new, delete the replaced object, update the column
-- delete a row         : remove the food_tracker_bk object when foodImageUrl is set
